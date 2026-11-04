import type { RegisterRepository } from "../../repository/auth/register.repository.js";
import type { RegisterParams } from "../../types/auth/register.js";

export class RegisterService {
  constructor(private readonly registerRepository: RegisterRepository) {}

  async execute(params: RegisterParams) {
    await this.registerRepository.execute(params);
  }
}
