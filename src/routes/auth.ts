import { Router } from "express";
import { makeLoginController } from "../factories/auth/auth";

export const authRouter = Router();

authRouter.post("/login", async (req, res) => {
  const loginController = makeLoginController();
  const { statusCode, body } = await loginController.execute(req);

  res.status(statusCode).json(body);
});
