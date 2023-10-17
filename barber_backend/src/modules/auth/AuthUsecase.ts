 
import AuthService from "./AuthService";
import IRegisterResponse from "./dto/IResterRespose";
import IUserLoginRequest from "./dto/IUserLoginRequest";
import IUserRegistrationRequest from "./dto/IUserRegistrationRequest";

class AuthUseCase {

    private authService: AuthService;

    constructor(authService: AuthService) {
        this.authService = authService;;
    }
    register(req: IUserRegistrationRequest): Promise<IRegisterResponse> {
        return this.authService.register(req);
    }
    login(req: IUserLoginRequest): Promise<IRegisterResponse> {
        return this.authService.login(req);
    }
 
}



export default AuthUseCase