import type { LoginRepository } from "../../repository/auth/login.repository.js";
import type { LoginParams } from "../../types/auth/login.js";

export class LoginService {
  constructor(private readonly loginRepository: LoginRepository) {}

  async execute(params: LoginParams) {
    await this.loginRepository.execute(params);
  }
}
