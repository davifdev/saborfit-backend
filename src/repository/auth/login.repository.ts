import type { LoginParams } from "../../types/auth/login.js";

export class LoginRepository {
  async execute(params: LoginParams) {
    console.log({ params });
  }
}
