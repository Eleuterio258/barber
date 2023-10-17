import IRegisterResponse from "./dto/IResterRespose";
import IUserLoginRequest from "./dto/IUserLoginRequest";
import IUserRegistrationRequest from "./dto/IUserRegistrationRequest";



interface IAuthRepository {
    register(req: IUserRegistrationRequest): Promise<IRegisterResponse>;
    login(req: IUserLoginRequest): Promise<IRegisterResponse>

}




export default IAuthRepository
