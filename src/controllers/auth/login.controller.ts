import type { Request } from "express";
import type { LoginService } from "../../services/auth/login.service.js";
import type { LoginParams } from "../../types/auth/login.js";
import { INTERNAL_SERVER_ERROR, OK } from "../helpers/http.js";
import { loginSchema } from "../../schemas/auth/login.schema.js";
export class LoginController {
  constructor(private readonly loginService: LoginService) {
    this.loginService = loginService;
  }

  async execute(httpRequest: Request) {
    try {
      const params: LoginParams = httpRequest.body;

      await loginSchema.parseAsync(params);

      const result = await this.loginService.execute(params);

      return OK(result);
    } catch (error) {
      console.error(error);
      return INTERNAL_SERVER_ERROR();
    }
  }
}
