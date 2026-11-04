import type { Request } from "express";
import type { LoginService } from "../../services/auth/login.service.js";
import type { LoginParams } from "../../types/auth/login.js";

export class LoginController {
  constructor(private readonly loginService: LoginService) {}

  async execute(httpRequest: Request) {
    const params: LoginParams = httpRequest.body;
    await this.loginService.execute(params);
  }
}
