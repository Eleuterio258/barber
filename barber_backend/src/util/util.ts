
import { gql } from "graphql-request";
import { client } from "./client";
import bcrypt from "bcrypt";
import UserResponse from "../modules/auth/dto/UserResponse";

 
export function isValidEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}


export async function checkPhoneNumberExists(phoneNumber: string): Promise<boolean> {
  const response = await client.request<UserResponse>(
    gql`
        query CheckPhoneNumberExists($phoneNumber: String!) {
          users(where: { phone_number: { _eq: $phoneNumber } }) {
            id
          }
        }
      `,
    {
      phoneNumber,
    }
  );
  return response.users.length > 0;
}


export async function checkEmailExists(email: string): Promise<boolean> {
  const response = await client.request<UserResponse>(
    gql`
      query CheckEmailExists($email: String!) {
        users(where: { email: { _eq: $email } }) {
          id
        }
      }
    `,
    {
      email,
    }
  );
  return response.users.length > 0;
}


export async function checkUserExistence(email: string, phoneNumber: string) {
  const emailExists = await checkEmailExists(email);
  const phoneNumberExists = await checkPhoneNumberExists(phoneNumber);
  return { emailExists, phoneNumberExists };
}

export async function hashPassword(password: string) {
  return await bcrypt.hash(password, 10);
}