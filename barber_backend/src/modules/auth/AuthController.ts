import { Request, Response } from "express";
import AuthUsecase from "./AuthUsecase";
class AuthController {
    private authUsecase: AuthUsecase;

    constructor(authUsecase: AuthUsecase) {
        this.authUsecase = authUsecase;
    }


    async login(req: Request, res: Response) {
        const { email, password } = req.body as Record<string, string>;
        const result = await this.authUsecase.login({ email, password });
        return res.json(result);
    }

    async register(req: Request, res: Response) {
        const { email, password, profile, phoneNumber } = req.body as Record<string, string>;
        const result = await this.authUsecase.register({ email, password, profile, phoneNumber });
        return res.json(result);
    }

  
}

export default AuthController