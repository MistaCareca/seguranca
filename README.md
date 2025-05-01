# Sistema de Gerenciamento com Segurança e Auditoria

## Descrição
Este projeto implementa um sistema de gerenciamento de dados com foco em segurança e auditoria. Ele inclui tabelas para clientes com criptografia de dados sensíveis, registro de faturamento e um sistema de logs para rastrear operações no banco de dados.

## Estrutura do Banco de Dados
O banco de dados contém três tabelas principais:
- **clientes**: Armazena informações dos clientes, com o CPF criptografado para maior segurança.
- **faturamento**: Registra informações sobre o faturamento, associando-o a um cliente e incluindo um hash de transação.
- **log_operacoes**: Mantém um registro de todas as operações de inserção, atualização e exclusão realizadas nas tabelas, para fins de auditoria.

### Relacionamentos
- A tabela `faturamento` possui uma chave estrangeira (`id_cliente`) que referencia a tabela `clientes`.

### Índices
- A tabela `clientes` possui um índice no campo `data_cadastro` para otimizar consultas baseadas na data de cadastro.
- A tabela `faturamento` possui um índice no campo `data_faturamento` para otimizar consultas baseadas na data de faturamento.

### Engine
- Todas as tabelas são criadas utilizando a engine `InnoDB`, que oferece suporte a transações e integridade referencial.

## Pré-requisitos
- MySQL ou outro SGBD compatível com SQL e funções de criptografia (se a descriptografia for necessária diretamente no banco de dados).
- Permissões para criar e manipular bancos de dados e tabelas.
- Conhecimento de técnicas de criptografia (se a manipulação dos dados criptografados for necessária fora do contexto da aplicação).

## Instalação
1. Execute o script SQL fornecido para criar as tabelas no seu banco de dados.
   ```bash
   mysql -u [usuário] -p < seu_script_seguranca.sql
   ```
   (Substitua `seu_script_seguranca.sql` pelo nome do arquivo que contém o código SQL.)
2. Conecte-se ao banco de dados onde você deseja criar as tabelas:
   ```sql
   -- Se necessário, selecione o banco de dados
   -- USE nome_do_banco_de_dados;
   ```

## Estrutura do Script
O script contém a criação de três tabelas:
1. **Tabela `clientes`**:
   - `id_cliente`: Identificador único do cliente (chave primária, auto incremento).
   - `nome`: Nome do cliente (campo obrigatório).
   - `cpf`: CPF do cliente, armazenado como um valor binário (`VARBINARY(128)`) para permitir a criptografia dos dados.
   - `email`: Endereço de email do cliente.
   - `data_cadastro`: Data e hora do cadastro do cliente (campo obrigatório).
   - `INDEX idx_data_cadastro (data_cadastro)`: Índice para otimizar buscas por data de cadastro.
   - `ENGINE=InnoDB`: Especifica o uso da engine InnoDB.
2. **Tabela `faturamento`**:
   - `id_faturamento`: Identificador único do faturamento (chave primária, auto incremento).
   - `id_cliente`: Chave estrangeira referenciando o `id_cliente` da tabela `clientes` (campo obrigatório).
   - `valor`: Valor do faturamento (formato decimal com 10 dígitos no total e 2 casas decimais, campo obrigatório).
   - `data_faturamento`: Data do faturamento (campo obrigatório).
   - `hash_transacao`: Um hash único associado à transação de faturamento (campo obrigatório).
   - `FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)`: Define a chave estrangeira para garantir a integridade referencial.
   - `INDEX idx_data_faturamento (data_faturamento)`: Índice para otimizar buscas por data de faturamento.
   - `ENGINE=InnoDB`: Especifica o uso da engine InnoDB.
3. **Tabela `log_operacoes`**:
   - `id_log`: Identificador único do log (chave primária, auto incremento).
   - `id_usuario`: Identificador do usuário que realizou a operação (campo obrigatório).
   - `tabela_afetada`: Nome da tabela em que a operação foi realizada (campo obrigatório).
   - `operacao`: Tipo de operação realizada (`ENUM('INSERT', 'UPDATE', 'DELETE')`, campo obrigatório).
   - `data_operacao`: Data e hora da operação (campo obrigatório).
   - `detalhes`: Informações adicionais sobre a operação (texto longo).
   - `ENGINE=InnoDB`: Especifica o uso da engine InnoDB.

## Funcionalidades
- **Cadastro de Clientes com Segurança**: Permite o cadastro de informações de clientes, com o CPF armazenado de forma criptografada para proteger dados sensíveis. A criptografia geralmente é realizada pela aplicação antes de inserir os dados no banco.
- **Registro de Faturamento**: Permite registrar informações de faturamento associadas a clientes, incluindo valor, data e um hash de transação para rastreamento e integridade.
- **Auditoria de Operações**: Mantém um registro detalhado de todas as operações de modificação de dados (inserção, atualização, exclusão), incluindo o usuário, a tabela afetada, o tipo de operação, a data e hora, e detalhes adicionais. Isso é crucial para rastreabilidade e segurança.

## Considerações sobre Segurança
- **Criptografia do CPF**: O campo `cpf` na tabela `clientes` é do tipo `VARBINARY`, indicando que os dados devem ser criptografados pela aplicação antes de serem armazenados no banco de dados. A escolha do algoritmo de criptografia e a gestão das chaves são aspectos críticos da segurança e devem ser implementados na camada da aplicação.
- **Hash de Transação**: O campo `hash_transacao` na tabela `faturamento` pode ser utilizado para garantir a integridade da transação. Um hash pode ser gerado a partir dos detalhes da transação e armazenado, permitindo a verificação posterior de qualquer alteração nos dados.
- **Logs de Auditoria**: A tabela `log_operacoes` é fundamental para a segurança, pois permite rastrear quem fez o quê e quando no banco de dados. É importante garantir que o acesso a esses logs seja restrito e que eles sejam armazenados de forma segura.
