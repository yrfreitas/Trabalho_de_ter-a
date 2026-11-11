CREATE DATABASE jg_construcoes CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE jg_construcoes;

CREATE TABLE cliente (
  id_cliente     INT AUTO_INCREMENT PRIMARY KEY,
  nome           VARCHAR(100) NOT NULL,
  cpf_cnpj       VARCHAR(18)  NOT NULL UNIQUE,
  email          VARCHAR(100) NULL,
  telefone       VARCHAR(20)  NOT NULL,
  endereco       VARCHAR(200) NOT NULL,
  data_cadastro  DATE NOT NULL DEFAULT (CURRENT_DATE)
);

CREATE TABLE obra (
  id_obra            INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente         INT NOT NULL,
  endereco           VARCHAR(200) NOT NULL,
  responsavel_cliente VARCHAR(100) NOT NULL,
  data_inicio        DATE NOT NULL,
  data_prevista_fim  DATE NOT NULL,
  data_fim           DATE NULL,
  status             VARCHAR(20) NOT NULL DEFAULT 'Planejada',
  CONSTRAINT fk_obra_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE RESTRICT,
  CONSTRAINT ck_obra_status CHECK (status IN ('Planejada','Em andamento','Pausada','Concluída','Cancelada')),
  CONSTRAINT ck_obra_prevista CHECK (data_prevista_fim >= data_inicio),
  CONSTRAINT ck_obra_fim CHECK (data_fim IS NULL OR data_fim >= data_inicio)
);

CREATE TABLE servico (
  id_servico    INT AUTO_INCREMENT PRIMARY KEY,
  descricao     VARCHAR(100) NOT NULL UNIQUE,
  tipo          VARCHAR(50)  NOT NULL,
  valor_padrao  DECIMAL(10,2) NOT NULL,
  tempo_padrao  INT NOT NULL COMMENT 'horas',
  CONSTRAINT ck_servico_tipo CHECK (tipo IN ('Pintura','Elétrica','Hidráulica','Acabamento','Manutenção')),
  CONSTRAINT ck_servico_valor CHECK (valor_padrao >= 0),
  CONSTRAINT ck_servico_tempo CHECK (tempo_padrao > 0)
);
 
CREATE TABLE funcionario (
  id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
  nome           VARCHAR(100) NOT NULL,
  cpf            VARCHAR(11)  NOT NULL UNIQUE,
  cargo          VARCHAR(50)  NOT NULL,
  telefone       VARCHAR(20)  NOT NULL,
  email          VARCHAR(100) NOT NULL UNIQUE,
  data_admissao  DATE NOT NULL,
  status         VARCHAR(20) NOT NULL DEFAULT 'Ativo',
  CONSTRAINT ck_func_status CHECK (status IN ('Ativo','Inativo','Afastado'))
);

CREATE TABLE prestador (
  id_prestador  INT AUTO_INCREMENT PRIMARY KEY,
  nome          VARCHAR(100) NOT NULL,
  cpf           VARCHAR(11)  NOT NULL UNIQUE,
  especialidade VARCHAR(100) NOT NULL,
  telefone      VARCHAR(20)  NOT NULL,
  email         VARCHAR(100) NULL
);
 
CREATE TABLE material (
  id_material    INT AUTO_INCREMENT PRIMARY KEY,
  nome           VARCHAR(100) NOT NULL,
  tipo           VARCHAR(50)  NOT NULL,
  unidade        VARCHAR(20)  NOT NULL,
  custo_unitario DECIMAL(10,2) NOT NULL,
  CONSTRAINT ck_material_custo CHECK (custo_unitario >= 0)
);
 
CREATE TABLE obra_servico (
  id_obra_servico   INT AUTO_INCREMENT PRIMARY KEY,
  id_obra           INT NOT NULL,
  id_servico        INT NOT NULL,
  id_funcionario    INT NULL,
  id_prestador      INT NULL,
  data_execucao     DATE NOT NULL,
  valor_contratado  DECIMAL(10,2) NOT NULL,
  tempo_estimado    INT NOT NULL COMMENT 'horas',
  tempo_real        INT NULL COMMENT 'horas',
  CONSTRAINT fk_os_obra  FOREIGN KEY (id_obra)        REFERENCES obra(id_obra)               ON DELETE CASCADE,
  CONSTRAINT fk_os_serv  FOREIGN KEY (id_servico)     REFERENCES servico(id_servico)         ON DELETE RESTRICT,
  CONSTRAINT fk_os_func  FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario) ON DELETE RESTRICT,
  CONSTRAINT fk_os_prest FOREIGN KEY (id_prestador)   REFERENCES prestador(id_prestador)     ON DELETE RESTRICT,
  CONSTRAINT ck_os_executor CHECK (id_funcionario IS NOT NULL OR id_prestador IS NOT NULL),
  CONSTRAINT ck_os_valor  CHECK (valor_contratado >= 0),
  CONSTRAINT ck_os_tempos CHECK (tempo_estimado > 0 AND (tempo_real IS NULL OR tempo_real > 0))
);
 
CREATE TABLE alocacao_funcionario (
  id_obra        INT NOT NULL,
  id_funcionario INT NOT NULL,
  data_inicio    DATE NOT NULL,
  data_fim       DATE NULL,
  funcao         VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_obra, id_funcionario),
  CONSTRAINT fk_af_obra FOREIGN KEY (id_obra)        REFERENCES obra(id_obra)               ON DELETE CASCADE,
  CONSTRAINT fk_af_func FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario) ON DELETE RESTRICT,
  CONSTRAINT ck_af_datas CHECK (data_fim IS NULL OR data_fim >= data_inicio)
);
 
CREATE TABLE alocacao_prestador (
  id_obra      INT NOT NULL,
  id_prestador INT NOT NULL,
  data_inicio  DATE NOT NULL,
  data_fim     DATE NULL,
  funcao       VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_obra, id_prestador),
  CONSTRAINT fk_ap_obra FOREIGN KEY (id_obra)      REFERENCES obra(id_obra)           ON DELETE CASCADE,
  CONSTRAINT fk_ap_prest FOREIGN KEY (id_prestador) REFERENCES prestador(id_prestador) ON DELETE RESTRICT,
  CONSTRAINT ck_ap_datas CHECK (data_fim IS NULL OR data_fim >= data_inicio)
);
 
CREATE TABLE orcamento (
  id_orcamento   INT AUTO_INCREMENT PRIMARY KEY,
  id_obra        INT NOT NULL,
  id_funcionario INT NOT NULL,
  valor_total    DECIMAL(10,2) NOT NULL,
  data_emissao   DATE NOT NULL,
  status         VARCHAR(20) NOT NULL DEFAULT 'Pendente',
  CONSTRAINT fk_orc_obra FOREIGN KEY (id_obra)        REFERENCES obra(id_obra)               ON DELETE RESTRICT,
  CONSTRAINT fk_orc_func FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario) ON DELETE RESTRICT,
  CONSTRAINT ck_orc_valor  CHECK (valor_total >= 0),
  CONSTRAINT ck_orc_status CHECK (status IN ('Pendente','Aprovado','Rejeitado','Expirado'))
);
 
CREATE TABLE pagamento (
  id_pagamento    INT AUTO_INCREMENT PRIMARY KEY,
  id_orcamento    INT NOT NULL,
  forma_pagamento VARCHAR(50) NOT NULL,
  valor           DECIMAL(10,2) NOT NULL,
  data_pagamento  DATE NULL COMMENT 'NULL enquanto Pendente/Atrasado',
  status          VARCHAR(20) NOT NULL DEFAULT 'Pendente',
  CONSTRAINT fk_pag_orc FOREIGN KEY (id_orcamento) REFERENCES orcamento(id_orcamento) ON DELETE RESTRICT,
  CONSTRAINT ck_pag_valor  CHECK (valor > 0),
  CONSTRAINT ck_pag_status CHECK (status IN ('Pendente','Pago','Atrasado','Estornado')),
  CONSTRAINT ck_pag_forma  CHECK (forma_pagamento IN ('PIX','Boleto','Cartão','Dinheiro','Transferência'))
);
 
CREATE TABLE obra_material (
  id_obra_material INT AUTO_INCREMENT PRIMARY KEY,
  id_obra          INT NOT NULL,
  id_material      INT NOT NULL,
  id_obra_servico  INT NULL,
  quantidade       DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_om_obra FOREIGN KEY (id_obra)         REFERENCES obra(id_obra)                 ON DELETE CASCADE,
  CONSTRAINT fk_om_mat  FOREIGN KEY (id_material)     REFERENCES material(id_material)         ON DELETE RESTRICT,
  CONSTRAINT fk_om_os   FOREIGN KEY (id_obra_servico) REFERENCES obra_servico(id_obra_servico) ON DELETE SET NULL,
  CONSTRAINT ck_om_qtd CHECK (quantidade > 0)
);

-------------------------------------------------
Dados ficticios 
-------------------------------------------------


INSERT INTO cliente (nome, cpf_cnpj, email, telefone, endereco, data_cadastro) VALUES
('Marcos Antunes Lima',            '900.000.001-01',     'marcos.lima@exemplo.com',     '(11) 90000-0001', 'Rua das Acácias, 120 - Itaquera, São Paulo/SP',         '2025-12-02'),
('Condomínio Residencial Bela Vista','90.000.002/0001-02','sindico@belavista.exemplo',  '(11) 4000-0002',  'Av. dos Ipês, 800 - Guaianases, São Paulo/SP',          '2026-01-10'),
('Fernanda Souza Prado',           '900.000.003-03',     'fernanda.prado@exemplo.com',  '(11) 90000-0003', 'Rua Jacarandá, 45 - Vila Matilde, São Paulo/SP',        '2026-02-18'),
('Padaria Pão Dourado LTDA',       '90.000.004/0001-04', 'contato@paodourado.exemplo',  '(11) 4000-0004',  'Av. Itaquera, 3300 - Itaquera, São Paulo/SP',           '2026-04-27'),
('Ricardo Alves Moreira',          '900.000.005-05',     NULL,                          '(11) 90000-0005', 'Rua Ipanema, 77 - Cidade Líder, São Paulo/SP',          '2026-07-29'),


INSERT INTO obra (id_cliente, endereco, responsavel_cliente, data_inicio, data_prevista_fim, data_fim, status) VALUES
(1, 'Rua das Acácias, 120 - Itaquera, São Paulo/SP',           'Marcos Antunes Lima',   '2026-01-12', '2026-03-15', '2026-03-20', 'Concluída'),
(2, 'Av. dos Ipês, 800 - Guaianases, São Paulo/SP',            'Sônia Barreto (síndica)','2026-02-02', '2026-04-30', '2026-04-28', 'Concluída'),
(3, 'Rua Jacarandá, 45 - Vila Matilde, São Paulo/SP',          'Fernanda Souza Prado',  '2026-03-09', '2026-05-29', '2026-06-12', 'Concluída'),
(4, 'Av. Itaquera, 3300 - Itaquera, São Paulo/SP',             'Dirceu Pão Dourado',    '2026-06-01', '2026-09-30', NULL,         'Em andamento'),
(5, 'Rua Ipanema, 77 - Cidade Líder, São Paulo/SP',            'Ricardo Alves Moreira', '2026-08-17', '2026-12-18', NULL,         'Em andamento'),
(6, 'Rua São Miguel, 560 - São Miguel Paulista, São Paulo/SP', 'Dra. Camila Rezende',   '2026-07-06', '2026-10-30', NULL,         'Pausada'),
(7, 'Rua Oriente, 210 - Penha, São Paulo/SP',                  'Juliana Ferreira Costa','2026-11-23', '2027-02-26', NULL,         'Planejada'),
(1, 'Rua das Acácias, 122 - Itaquera, São Paulo/SP',           'Marcos Antunes Lima',   '2026-09-14', '2026-12-11', NULL,         'Em andamento'),
(8, 'Rua Bahia, 15 - Vila Brasil, São Paulo/SP',               'Paulo Henrique Martins','2026-05-04', '2026-07-31', NULL,         'Cancelada');
 

INSERT INTO servico (descricao, tipo, valor_padrao, tempo_padrao) VALUES
('Pintura interna de ambientes',          'Pintura',    2800.00, 40),
('Pintura externa de fachada',            'Pintura',    4500.00, 56),
('Aplicação de textura em paredes',       'Acabamento', 1900.00, 24),
('Instalação elétrica completa',          'Elétrica',   6200.00, 80),
('Troca de quadro de distribuição',       'Elétrica',   1800.00, 16),
('Instalação hidráulica completa',        'Hidráulica', 5400.00, 72),
('Reparo de vazamentos',                  'Hidráulica', 1200.00, 10),
('Assentamento de piso cerâmico',         'Acabamento', 4800.00, 64),
('Revestimento de paredes',               'Acabamento', 3600.00, 48),
('Impermeabilização de laje',             'Acabamento', 3900.00, 40),
('Manutenção preventiva predial',         'Manutenção', 1500.00, 12),
('Instalação de forro de gesso',          'Acabamento', 3100.00, 36);
 

INSERT INTO funcionario (nome, cpf, cargo, telefone, email, data_admissao, status) VALUES
('Carlos Eduardo Ramos',  '90000000101', 'Engenheiro Civil',        '(11) 90001-0001', 'carlos.ramos@jg.exemplo',    '2025-11-10', 'Ativo'),
('Patrícia Nogueira',     '90000000202', 'Orçamentista',            '(11) 90001-0002', 'patricia.nogueira@jg.exemplo','2025-12-01', 'Ativo'),
('Rogério Teixeira',      '90000000303', 'Mestre de Obras',         '(11) 90001-0003', 'rogerio.teixeira@jg.exemplo','2025-11-10', 'Ativo'),
('Anderson Pires',        '90000000404', 'Pedreiro',                '(11) 90001-0004', 'anderson.pires@jg.exemplo',  '2026-01-05', 'Ativo'),
('Luciana Barros',        '90000000505', 'Pintora',                 '(11) 90001-0005', 'luciana.barros@jg.exemplo',  '2026-01-05', 'Ativo'),
('Valter Gomes',          '90000000606', 'Eletricista',             '(11) 90001-0006', 'valter.gomes@jg.exemplo',    '2026-02-02', 'Ativo');
 

INSERT INTO prestador (nome, cpf, especialidade, telefone, email) VALUES
('Edson Martins',   '90000001101', 'Eletricista',            '(11) 90002-0001', 'edson.martins@exemplo.com'),
('Helena Duarte',   '90000001202', 'Encanadora',             '(11) 90002-0002', 'helena.duarte@exemplo.com'),
('Joel Cardoso',    '90000001303', 'Azulejista',             '(11) 90002-0003', 'joel.cardoso@exemplo.com'),
('Wagner Silva',    '90000001404', 'Gesseiro',               '(11) 90002-0004', 'wagner.silva@exemplo.com'),
('Tatiane Rocha',   '90000001505', 'Impermeabilização',      '(11) 90002-0005', NULL);


INSERT INTO material (nome, tipo, unidade, custo_unitario) VALUES
('Tinta acrílica premium 18L',      'Tinta',             'Lata',    389.90),
('Massa corrida 25kg',              'Acabamento',        'Balde',    74.50),
('Textura acrílica 25kg',           'Acabamento',        'Balde',   118.00),
('Fio flexível 2,5mm 100m',         'Elétrico',          'Rolo',    289.00),
('Disjuntor bipolar 40A',           'Elétrico',          'Unidade',  42.90),
('Tubo PVC soldável 25mm 6m',       'Hidráulico',        'Barra',    24.80),
('Registro de gaveta 3/4"',         'Hidráulico',        'Unidade',  58.00),
('Piso cerâmico 60x60',             'Revestimento',      'm²',       49.90),
('Argamassa AC-III 20kg',           'Revestimento',      'Saco',     36.90),
('Manta asfáltica 3mm',             'Impermeabilização', 'Rolo',    412.00),
('Placa de gesso acartonado',       'Gesso',             'Unidade',  46.50),
('Rejunte 1kg',                     'Revestimento',      'Pacote',    9.90);
 
INSERT INTO obra_servico (id_obra, id_servico, id_funcionario, id_prestador, data_execucao, valor_contratado, tempo_estimado, tempo_real) VALUES
(1, 1,    5, NULL, '2026-02-10', 2800.00, 40, 44),   -- 1
(1, 3,    5, NULL, '2026-03-05', 1900.00, 24, 22),   -- 2
(1, 5, NULL,    1, '2026-01-28', 1800.00, 16, 16),   -- 3
(2, 4, NULL,    1, '2026-02-20', 6200.00, 80, 90),   -- 4
(2, 6, NULL,    2, '2026-03-10', 5400.00, 72, 70),   -- 5
(2, 8, NULL,    3, '2026-04-08', 4800.00, 64, 60),   -- 6
(3, 2,    5, NULL, '2026-04-14', 4500.00, 56, 70),   -- 7
(3,10, NULL,    5, '2026-03-20', 3900.00, 40, 52),   -- 8
(3, 9, NULL,    3, '2026-05-18', 3600.00, 48, 50),   -- 9
(4, 4,    6, NULL, '2026-06-20', 6500.00, 80, 88),   -- 10
(4,12, NULL,    4, '2026-07-25', 3100.00, 36, NULL), -- 11
(4, 8, NULL,    3, '2026-09-05', 4800.00, 64, NULL), -- 12
(5, 6, NULL,    2, '2026-09-10', 5600.00, 72, NULL), -- 13
(5, 7,    4, NULL, '2026-09-02', 1200.00, 10, 9),    -- 14
(6, 1,    5, NULL, '2026-08-03', 2800.00, 40, NULL), -- 15
(8,11,    3, NULL, '2026-09-22', 1500.00, 12, 12),   -- 16
(8, 5,    6, NULL, '2026-10-05', 1800.00, 16, NULL), -- 17
(8, 3,    5, NULL, '2026-10-20', 1900.00, 24, NULL), -- 18
(5, 9, NULL,    3, '2026-11-10', 3600.00, 48, NULL); -- 19
 
INSERT INTO alocacao_funcionario (id_obra, id_funcionario, data_inicio, data_fim, funcao) VALUES
(1, 3, '2026-01-12', '2026-03-20', 'Mestre de obras'),
(1, 5, '2026-02-10', '2026-03-10', 'Pintora'),
(2, 3, '2026-02-02', '2026-04-28', 'Mestre de obras'),
(2, 4, '2026-03-10', '2026-04-28', 'Pedreiro'),
(3, 3, '2026-03-09', '2026-06-12', 'Mestre de obras'),
(3, 5, '2026-04-14', '2026-05-10', 'Pintora'),
(4, 3, '2026-06-01', NULL,         'Mestre de obras'),
(4, 6, '2026-06-20', NULL,         'Eletricista'),
(5, 3, '2026-08-17', NULL,         'Mestre de obras'),
(5, 4, '2026-08-17', NULL,         'Pedreiro'),
(6, 5, '2026-07-06', '2026-08-14', 'Pintora'),
(8, 3, '2026-09-14', NULL,         'Mestre de obras'),
(8, 5, '2026-10-20', NULL,         'Pintora'),
(8, 6, '2026-10-05', NULL,         'Eletricista');
 
INSERT INTO alocacao_prestador (id_obra, id_prestador, data_inicio, data_fim, funcao) VALUES
(1, 1, '2026-01-26', '2026-02-02', 'Eletricista'),
(2, 1, '2026-02-18', '2026-03-05', 'Eletricista'),
(2, 2, '2026-03-09', '2026-03-27', 'Encanadora'),
(2, 3, '2026-04-06', '2026-04-24', 'Azulejista'),
(3, 5, '2026-03-16', '2026-04-03', 'Impermeabilização'),
(3, 3, '2026-05-15', '2026-06-05', 'Azulejista'),
(4, 4, '2026-07-20', NULL,         'Gesseiro'),
(4, 3, '2026-09-01', NULL,         'Azulejista'),
(5, 2, '2026-09-07', NULL,         'Encanadora'),
(5, 3, '2026-11-02', NULL,         'Azulejista');
 
INSERT INTO orcamento (id_obra, id_funcionario, valor_total, data_emissao, status) VALUES
(1, 1,  6500.00, '2026-01-05', 'Aprovado'),   -- 1
(2, 1, 16400.00, '2026-01-22', 'Aprovado'),   -- 2
(3, 2, 12000.00, '2026-02-27', 'Aprovado'),   -- 3
(4, 1, 14400.00, '2026-05-20', 'Aprovado'),   -- 4
(5, 2, 14000.00, '2026-08-05', 'Aprovado'),   -- 5  (6.800 de materiais/serviços extras incluídos)
(6, 1,  2800.00, '2026-06-25', 'Aprovado'),   -- 6
(7, 2, 21000.00, '2026-10-10', 'Rejeitado'),  -- 7
(8, 1,  5200.00, '2026-09-08', 'Aprovado'),   -- 8
(9, 2,  9800.00, '2026-04-20', 'Rejeitado'),  -- 9
(4, 1, 15800.00, '2026-05-08', 'Rejeitado'),  -- 10 (versão anterior da obra 4)
(7, 2, 18500.00, '2026-10-28', 'Pendente'),   -- 11
(9, 2,  8700.00, '2026-03-02', 'Expirado');   -- 12

INSERT INTO pagamento (id_orcamento, forma_pagamento, valor, data_pagamento, status) VALUES
(1, 'PIX',           3250.00, '2026-01-12', 'Pago'),
(1, 'PIX',           3250.00, '2026-03-20', 'Pago'),
(2, 'Transferência', 8200.00, '2026-02-02', 'Pago'),
(2, 'Boleto',        4100.00, '2026-03-15', 'Pago'),
(2, 'Boleto',        4100.00, '2026-04-30', 'Pago'),
(3, 'PIX',           4000.00, '2026-03-09', 'Pago'),
(3, 'Cartão',         500.00, '2026-03-12', 'Estornado'),
(3, 'Boleto',        4000.00, '2026-04-30', 'Pago'),
(3, 'Boleto',        4000.00, '2026-06-15', 'Pago'),
(4, 'Transferência', 4800.00, '2026-06-01', 'Pago'),
(4, 'Boleto',        4800.00, '2026-08-01', 'Pago'),
(4, 'Boleto',        4800.00, NULL,         'Atrasado'),
(5, 'PIX',           4200.00, '2026-08-17', 'Pago'),
(5, 'Cartão',        4200.00, '2026-10-15', 'Pago'),
(5, 'Boleto',        5600.00, NULL,         'Pendente'),
(6, 'PIX',           1400.00, '2026-07-06', 'Pago'),
(6, 'PIX',           1400.00, NULL,         'Atrasado'),
(8, 'PIX',           2600.00, '2026-09-14', 'Pago'),
(8, 'Dinheiro',      2600.00, NULL,         'Pendente')

INSERT INTO obra_material (id_obra, id_material, id_obra_servico, quantidade) VALUES
(1,  1,  1,  6.00),
(1,  2,  1,  4.00),
(1,  3,  2,  3.00),
(1,  5,  3,  1.00),
(2,  4,  4,  5.00),
(2,  6,  5, 40.00),
(2,  8,  6, 62.00);

----------------------------------
Conferencia 
----------------------------------
SELECT 'cliente' AS tabela, COUNT(*) AS linhas FROM cliente
UNION ALL SELECT 'obra', COUNT(*) FROM obra
UNION ALL SELECT 'servico', COUNT(*) FROM servico
UNION ALL SELECT 'funcionario', COUNT(*) FROM funcionario
UNION ALL SELECT 'prestador', COUNT(*) FROM prestador
UNION ALL SELECT 'material', COUNT(*) FROM material
UNION ALL SELECT 'obra_servico', COUNT(*) FROM obra_servico
UNION ALL SELECT 'alocacao_funcionario', COUNT(*) FROM alocacao_funcionario
UNION ALL SELECT 'alocacao_prestador', COUNT(*) FROM alocacao_prestador
UNION ALL SELECT 'orcamento', COUNT(*) FROM orcamento
UNION ALL SELECT 'pagamento', COUNT(*) FROM pagamento
UNION ALL SELECT 'obra_material', COUNT(*) FROM obra_material;

---------------------------------------------------
Consultas 
---------------------------------------------------

-- Consultar clientes cadastrados (RF01)

SELECT id_cliente, nome, cpf_cnpj, telefone, email, endereco, data_cadastro
FROM cliente
ORDER BY nome;

-- Consultar obras com cliente e prazos (RF02)

SELECT ob.id_obra, c.nome AS cliente, ob.endereco, ob.status,
       ob.data_inicio, ob.data_prevista_fim, ob.data_fim
FROM obra ob
JOIN cliente c ON c.id_cliente = ob.id_cliente
ORDER BY ob.id_obra;

-- Catálogo de serviços por categoria (RF03)

SELECT id_servico, descricao, tipo, valor_padrao, tempo_padrao
FROM servico
ORDER BY tipo, descricao;

-- Serviços de cada obra, com cliente, executor e valor (RF04)

SELECT ob.id_obra, c.nome AS cliente, s.descricao, s.tipo,
       COALESCE(f.nome, p.nome) AS executor,
       os.valor_contratado, os.data_execucao
FROM obra_servico os
JOIN obra ob     ON ob.id_obra   = os.id_obra
JOIN cliente c   ON c.id_cliente = ob.id_cliente
JOIN servico s   ON s.id_servico = os.id_servico
LEFT JOIN funcionario f ON f.id_funcionario = os.id_funcionario
LEFT JOIN prestador   p ON p.id_prestador   = os.id_prestador
ORDER BY ob.id_obra, os.id_obra_servico;


-- Consultar orçamentos com cliente e responsável (RF06)

SELECT o.id_orcamento, c.nome AS cliente, ob.id_obra,
       f.nome AS responsavel, o.data_emissao, o.valor_total, o.status
FROM orcamento o
JOIN obra ob       ON ob.id_obra        = o.id_obra
JOIN cliente c     ON c.id_cliente      = ob.id_cliente
JOIN funcionario f ON f.id_funcionario  = o.id_funcionario
ORDER BY o.data_emissao;


-- Consultar pagamentos (RF07)

SELECT p.id_pagamento, c.nome AS cliente, o.id_orcamento, p.valor, p.forma_pagamento, p.data_pagamento
FROM pagamento p
JOIN orcamento o ON o.id_orcamento = p.id_orcamento
JOIN obra ob     ON ob.id_obra     = o.id_obra
JOIN cliente c   ON c.id_cliente   = ob.id_cliente
WHERE p.status = 'Pago'
ORDER BY p.data_pagamento;


--Acompanhamento de valores (RF07)

SELECT
    o.id_orcamento,
    o.valor_total,
    COALESCE(SUM(
        CASE
            WHEN p.status = 'Pago'
            THEN p.valor
            ELSE 0
        END
    ), 0) AS total_recebido,
    o.valor_total - COALESCE(SUM(
        CASE
            WHEN p.status = 'Pago'
            THEN p.valor
            ELSE 0
        END
    ), 0) AS saldo_restante
FROM orcamento o
LEFT JOIN pagamento p
    ON o.id_orcamento = p.id_orcamento
GROUP BY o.id_orcamento, o.valor_total;

--Gerar relatorios (RF09)

SELECT ob.id_obra, c.nome AS cliente,
       COUNT(os.id_obra_servico) AS qtd_servicos,
       COALESCE(SUM(os.valor_contratado), 0) AS valor_total_servicos
FROM obra ob
JOIN cliente c ON c.id_cliente = ob.id_cliente
LEFT JOIN obra_servico os ON os.id_obra = ob.id_obra
GROUP BY ob.id_obra, c.nome
ORDER BY ob.id_obra;

-- Controlar andamento das obras (RF10)

SELECT ob.id_obra, c.nome AS cliente, ob.status, ob.data_prevista_fim,
       COUNT(os.id_obra_servico)                AS qtd_servicos,
       SUM(os.tempo_real IS NOT NULL)           AS servicos_com_horas_apuradas,
       SUM(os.tempo_estimado)                   AS horas_previstas,
       SUM(os.tempo_real)                       AS horas_reais
FROM obra ob
JOIN cliente c ON c.id_cliente = ob.id_cliente
LEFT JOIN obra_servico os ON os.id_obra = ob.id_obra
WHERE ob.status IN ('Em andamento','Pausada')
GROUP BY ob.id_obra, c.nome, ob.status, ob.data_prevista_fim
ORDER BY ob.id_obra;

