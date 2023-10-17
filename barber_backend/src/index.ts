import express, { Request, Response } from 'express';
import AuthController from "./modules/auth/AuthController";
import AuthRepository from "./modules/auth/AuthRepository";
import AuthRouter from "./modules/auth/AuthRouter";
import AuthService from "./modules/auth/AuthService";
import AuthUseCase from "./modules/auth/AuthUsecase";
import cors from 'cors';
import morgan from 'morgan';
import * as dotenv from 'dotenv';

const app = express();
const port = process.env.PORT || 5000;
app.use(express.json());
app.use(cors());
dotenv.config();
app.use(morgan('dev'));
app.use(express.json());

app.use((req: Request, res: Response, next: Function) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', '*');
  res.setHeader('Access-Control-Allow-Headers', '*');
  next();
});



const authRepository = new AuthRepository();
const authService = new AuthService(authRepository);
const authUseCase = new AuthUseCase(authService);
const authController = new AuthController(authUseCase);
app.use("/auth", AuthRouter(authController));
app.listen(port, () => {
  console.log(`Auth server running on port ${port}.`);
});