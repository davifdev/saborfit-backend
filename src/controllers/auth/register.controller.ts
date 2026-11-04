import type { Request } from "express";
import type { RegisterService } from "../../services/auth/register.service.js";
import type { RegisterParams } from "../../types/auth/register.js";

export class RegisterController {
  constructor(private readonly registerService: RegisterService) {}

  async execute(httpRequest: Request) {
    const params: RegisterParams = httpRequest.body;
    this.registerService.execute(params);
  }
}
