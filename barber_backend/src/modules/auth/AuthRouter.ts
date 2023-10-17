import express from 'express';
import AuthController from './AuthController';


const router = express.Router();



function AuthRouter(authController: AuthController) {
    router.post('/login', authController.login.bind(authController));
    router.post('/register', authController.register.bind(authController));
 
    
    return router;
}

export default AuthRouter