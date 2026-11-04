import type { Request } from "express";
import type { LoginService } from "../../services/auth/login.service.js";
import type { LoginParams } from "../../types/auth/login.js";
import { BAD_REQUEST, INTERNAL_SERVER_ERROR, OK } from "../helpers/http.js";
import { loginSchema } from "../../schemas/auth/login.schema.js";
import { ZodError } from "zod";
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
      if (error instanceof ZodError) {
        return BAD_REQUEST({ message: error.issues[0]?.message });
      }

      return INTERNAL_SERVER_ERROR();
    }
  }
}
