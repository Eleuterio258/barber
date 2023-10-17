 
import AuthRepository from "./AuthRepository";
import IRegisterResponse from "./dto/IResterRespose";
import IUserLoginRequest from "./dto/IUserLoginRequest";
import IUserRegistrationRequest from "./dto/IUserRegistrationRequest";

class AuthService {
    private authRepository: AuthRepository;

    constructor(authRepository: AuthRepository) {
        this.authRepository = authRepository;
    }
    async register(req: IUserRegistrationRequest): Promise<IRegisterResponse> {
        return await this.authRepository.register(req);
    }
    async login(req: IUserLoginRequest): Promise<IRegisterResponse> {
        return await this.authRepository.login(req);
    }
  
}



export default AuthService