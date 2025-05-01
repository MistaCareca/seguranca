-- Tabela de clientes com criptografia em dados sensíveis
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARBINARY(128) NOT NULL, 
    email VARCHAR(100),
    data_cadastro DATETIME NOT NULL,
    INDEX idx_data_cadastro (data_cadastro)
) ENGINE=InnoDB;

-- Tabela de faturamento
CREATE TABLE faturamento (
    id_faturamento INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    data_faturamento DATE NOT NULL,
    hash_transacao CHAR(64) NOT NULL, 
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    INDEX idx_data_faturamento (data_faturamento)
) ENGINE=InnoDB;

-- Tabela de logs
CREATE TABLE log_operacoes (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    tabela_afetada VARCHAR(50) NOT NULL,
    operacao ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    data_operacao DATETIME NOT NULL,
    detalhes TEXT
) ENGINE=InnoDB;