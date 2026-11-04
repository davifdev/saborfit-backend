import type { Request } from "express";
import type { RegisterService } from "../../services/auth/register.service.js";
import { BAD_REQUEST, INTERNAL_SERVER_ERROR, OK } from "../helpers/http.js";
import { registerSchema } from "../../schemas/auth/register.schema.js";
import { ZodError } from "zod";
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
      if (error instanceof ZodError) {
        return BAD_REQUEST({ message: error.issues[0]?.message });
      }

      return INTERNAL_SERVER_ERROR();
    }
  }
}
