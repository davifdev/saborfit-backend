import type { RegisterParams } from "../../types/auth/register.js";

export class RegisterRepository {
  async execute(params: RegisterParams) {
    console.log(params);
  }
}
