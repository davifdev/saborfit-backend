import type { Request } from "express";
import type { RegisterService } from "../../services/auth/register.service.js";
import { INTERNAL_SERVER_ERROR, OK } from "../helpers/http.js";
import { registerSchema } from "../../schemas/auth/register.schema.js";
export class RegisterController {
  constructor(private readonly registerService: RegisterService) {
    this.registerService = registerService;
  }

  async execute(httpRequest: Request) {
    try {
      const params = httpRequest.body;

      await registerSchema.parseAsync(params);

      const result = await this.registerService.execute(params);

      return OK(result);
    } catch (error) {
      console.error(error);
      return INTERNAL_SERVER_ERROR();
    }
  }
}
