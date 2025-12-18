DROP DATABASE IF EXISTS parque_diversoes;        -- Apagar a base de dados se já existir
CREATE DATABASE parque_diversoes;                -- Criar a base de dados
USE parque_diversoes;                            -- Selecionar a base de dados

-- Tabela das atrações
CREATE TABLE Atracao (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,                 -- obrigatório para identificar a atração
    Preco DECIMAL(6,2) NOT NULL DEFAULT 0.00,   -- preço do bilhete para a atração
    Horario_inicio TIME,                        -- horário de início da operação (usar TIME em vez de VARCHAR)
    Horario_fim TIME,
    Num_Pessoas INT NOT NULL DEFAULT 1,         -- capacidade (pelo menos 1)
    Peso_Min DECIMAL(5,2),                      -- valores opcionais, NULL se não aplicável
    Peso_Max DECIMAL(5,2),
    Altura_Min DECIMAL(5,2),
    Altura_Max DECIMAL(5,2),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CHECK (Num_Pessoas >= 1),
    CHECK (Preco >= 0),
    CHECK (Peso_Min IS NULL OR Peso_Max IS NULL OR Peso_Min <= Peso_Max),
    CHECK (Altura_Min IS NULL OR Altura_Max IS NULL OR Altura_Min <= Altura_Max)
);

-- Tabela de manutenção (cada registo ligado a uma atração)
CREATE TABLE Manutencao (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Data DATE NOT NULL,
    Problema VARCHAR(200),
    Descricao TEXT,
    AtracaoID INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AtracaoID) REFERENCES Atracao(ID)
      ON UPDATE CASCADE    -- quando o ID da atração for alterado, o valor em todas as tabelas que usam esse ID é automaticamente alterado.
      ON DELETE RESTRICT   -- evita apagar uma atração que tenha registos de manutenção
);

-- Tabela de funcionários
CREATE TABLE Funcionario (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Funcao VARCHAR(50),
    Turno VARCHAR(50),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela associativa para N:M entre manutencao e funcionario
CREATE TABLE Manutencao_Funcionario (
    ID_Funcionario INT NOT NULL,
    ID_Manutencao INT NOT NULL,
    PRIMARY KEY (ID_Funcionario, ID_Manutencao),
    FOREIGN KEY (ID_Funcionario) REFERENCES Funcionario(ID)
      ON UPDATE CASCADE
      ON DELETE CASCADE,   -- se apagar um funcionario, apagam-se as associações
    FOREIGN KEY (ID_Manutencao) REFERENCES Manutencao(ID)
      ON UPDATE CASCADE
      ON DELETE CASCADE
);

-- Tabela de visitantes (pode ser expandida com nome, contacto, idade)
CREATE TABLE Visitante (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100),     -- opcional inicialmente
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de bilhetes
CREATE TABLE Bilhete (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    Preco DECIMAL(6,2) NOT NULL,
    DataCompra DATE NOT NULL,
    AtracaoID INT NOT NULL,
    VisitanteID INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AtracaoID) REFERENCES Atracao(ID)
      ON UPDATE CASCADE
      ON DELETE RESTRICT,  -- evita apagar atrações com bilhetes associados
    FOREIGN KEY (VisitanteID) REFERENCES Visitante(ID)
      ON UPDATE CASCADE
);

-- Índices permite que o SQL pesquise certos elementos muito mais rapido
CREATE INDEX idx_bilhete_atracao ON Bilhete(AtracaoID);
CREATE INDEX idx_bilhete_visitante ON Bilhete(VisitanteID);
CREATE INDEX idx_manutencao_atracao ON Manutencao(AtracaoID);
