import { gql } from "graphql-request";
import { client } from "../../util/client";
import { generateJWT } from "../../util/jwt";
import { checkEmailExists, checkPhoneNumberExists, checkUserExistence, hashPassword, isValidEmail } from "../../util/util";

import IAuthRepository from "./IAuthRepository";
import IRegisterResponse from "./dto/IResterRespose";
import IUserLoginRequest from "./dto/IUserLoginRequest";
import IUserRegistrationRequest from "./dto/IUserRegistrationRequest";
import InsertUserResponse from "./dto/InsertUserResponse";
import bcrypt from "bcrypt";
class AuthRepository implements IAuthRepository {
    async register(req: IUserRegistrationRequest): Promise<IRegisterResponse> {


        try {
            const { emailExists, phoneNumberExists } = await checkUserExistence(req.email, req.phoneNumber);


            if (emailExists) {
                return ({
                    message: "Usuário já cadastrado usando esse Email",
                    "X-Hasura-User-Id": "",
                    token: "",
                });
            }

            if (phoneNumberExists) {
                return ({
                    message: "Usuário já cadastrado usando esse Número",
                    "X-Hasura-User-Id": "",
                    token: "",
                });
            }

            if (!isValidEmail(req.email)) {
                return ({
                    message: "Email inválido",
                    "X-Hasura-User-Id": "",
                    token: "",
                });

            }

            const hashedPassword = await hashPassword(req.password);


            const userResponse: InsertUserResponse = await client.request<InsertUserResponse>(
                gql`
                    mutation InsertUser($object: users_insert_input!) {
                        insert_users_one(object: $object) {
                            id
                        }
                    }
                `,
                {
                    object: {
                        profile: req.profile,
                        phone_number: req.phoneNumber,
                        password: hashedPassword,
                        email: req.email,
                    },
                }
            );

            const userId = userResponse.insert_users_one.id;

            let tableName;
            if (req.profile === "customer") {
                tableName = "customers";
            } else if (req.profile === "barber") {
                tableName = "barbers";
            } else if (req.profile === "admin") {
                tableName = "adm_users";
            } else {
                await client.request(gql`mutation { _transaction_rollback }`);
                return {
                    message: "Perfil inválido",
                    "X-Hasura-User-Id": "",
                    token: "",
                };
            }

            await client.request(
                gql`
                    mutation InsertUserProfile($object: ${tableName}_insert_input!) {
                        insert_${tableName}_one(object: $object) {
                            id
                        }
                    }
                `,
                {
                    object: {
                        user_id: userId,
                    },
                }
            );

            const token = generateJWT({
                defaultRole: req.profile,
                allowedRoles: [req.profile],
                otherClaims: {
                    "X-Hasura-User-Id": userId,
                },
            });

            return {
                message: `${req.profile.charAt(0).toUpperCase() + req.profile.slice(1)} criado`,
                "X-Hasura-User-Id": userId,
                token,
            };
        } catch (error) {
            await client.request(gql`mutation { _transaction_rollback }`);
            return {
                message: "Internal server error",
                "X-Hasura-User-Id": "",
                token: "",
            };
        }
    }

    async login(req: IUserLoginRequest): Promise<IRegisterResponse> {


        if (!isValidEmail(req.email)) {
            return ({
                message: "Email inválido",
                "X-Hasura-User-Id": "",
                token: "",
            });

        }

        try {
            const response = await client.request<{
                users: {
                    profile: string;
                    password: string;
                    id: string,
                    email: string,
                    phone_number: string,
                }[]
            }>(
                gql`
              query GetUserByEmail($email: String!) {
                users(where: { email: { _eq: $email } }, limit: 1) {
                  id,
                  password,
                  profile,
                  email,
                }
              }
            `,
                { email: req.email }
            );

            const users = response.users;

            if (users.length === 0) {
                return ({
                    "message": "Usuario ou senha inválidos",
                    "X-Hasura-User-Id": "",
                    token: "",
                });

            }

            const user = users[0];
            const passwordMatch = await bcrypt.compare(req.password, user.password);

            if (passwordMatch) {
                const token = generateJWT({
                    defaultRole: user.profile,
                    allowedRoles: [user.profile],
                    otherClaims: {
                        "X-Hasura-User-Id": user.id,
                        // "X-Hasura-Role-Id":  ,
                    }
                });


                return ({
                    "message": "Usuario autenticado",
                    "X-Hasura-User-Id": user.id,
                    token: token
                });
            } else {
                return ({
                    "message": "Usuario ou senha inválidos",
                    "X-Hasura-User-Id": "",
                    token: ""
                });
            }
        } catch (error) {
            console.error(error);
            return ({
                message: "Internal server error",
                "X-Hasura-User-Id": "",
                token: ""
            });
        }
    }



}

export default AuthRepository;
