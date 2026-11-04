import type { Request } from "express";
import type { LoginService } from "../../services/auth/login.service.js";
import type { LoginParams } from "../../types/auth/login.js";
import { OK } from "../helpers/http.js";
export class LoginController {
  constructor(private readonly loginService: LoginService) {}

  async execute(httpRequest: Request) {
    const params: LoginParams = httpRequest.body;
    const result = await this.loginService.execute(params);

    return OK(result);
  }
}
