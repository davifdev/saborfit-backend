// Esse arquivo é executado antes de cada ARQUIVO de teste.
// Ideal para configurar jest-dom, mocks globais, ou resetar estados entre arquivos.

// Importa funções do Vitest para usar depois dos testes
// `afterEach` = executa algo depois de cada teste
// `expect` = função principal para fazer asserções (testar resultados)
import { afterEach } from "vitest";

// Essa função roda automaticamente depois de **cada** teste
// Serve pra limpar tudo e evitar que um teste interfira no outro
afterEach(async () => {
  // Reseta todos os spies e mocks do Vitest (`vi.fn`, `vi.spyOn`, etc.)
  // Garante que os testes sejam independentes e não tenham "lixo" de execuções anteriores
  vi.resetAllMocks();

  // Limpa a tabela da base de dados caso tenha ficado lixo
});
