import { Router } from "express";
import {
  makeLoginController,
  makeRegisterController,
} from "../factories/auth/auth";

export const authRouter = Router();

authRouter.post("/login", async (req, res) => {
  const loginController = makeLoginController();
  const { statusCode, body } = await loginController.execute(req);

  res.status(statusCode).json(body);
});

authRouter.post("/register", async (req, res) => {
  console.log("My obj req: ", req.body);
  const registerController = makeRegisterController();
  const { statusCode, body } = await registerController.execute(req);

  res.status(statusCode).json(body);
});
