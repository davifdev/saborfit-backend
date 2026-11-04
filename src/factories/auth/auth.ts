import { LoginController } from "../../controllers/auth/login.controller.ts";
import { RegisterController } from "../../controllers/auth/register.controller.ts";
import { LoginRepository } from "../../repository/auth/login.repository.ts";
import { RegisterRepository } from "../../repository/auth/register.repository.ts";
import { LoginService } from "../../services/auth/login.service.ts";
import { RegisterService } from "../../services/auth/register.service.ts";

export const makeLoginController = () => {
  const loginRepository = new LoginRepository();
  const loginService = new LoginService(loginRepository);
  const loginController = new LoginController(loginService);

  return loginController;
};

export const makeRegisterController = () => {
  const registerRepository = new RegisterRepository();
  const registerService = new RegisterService(registerRepository);
  const registerController = new RegisterController(registerService);

  return registerController;
};
