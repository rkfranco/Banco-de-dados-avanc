-- 1) Criação dos grupos (papéis);

CREATE OR REPLACE role role_gerente;
CREATE OR REPLACE role role_recepcionista;
CREATE OR REPLACE role role_atendente_geral;

-- 2) Designação dos privilégios para cada um dos grupos criados;

-- Gerente 
GRANT SELECT, INSERT, UPDATE, DELETE 
ON trabalho_dois.* 
TO role_gerente
WITH GRANT OPTION;

-- Recepcionista
GRANT SELECT, INSERT, UPDATE, DELETE 
ON trabalho_dois.cliente 
TO role_recepcionista;

GRANT SELECT, INSERT, UPDATE, DELETE 
ON trabalho_dois.reserva
TO role_recepcionista;

GRANT SELECT, INSERT, UPDATE, DELETE 
ON trabalho_dois.hospedagem 
TO role_recepcionista;

-- Atendente Geral
CREATE OR REPLACE VIEW view_atendente_geral
AS
SELECT c.nm_cliente, h.nr_quarto
FROM trabalho_dois.hospedagem AS h
INNER JOIN trabalho_dois.cliente AS C
ON h.cd_cliente = c.cd_cliente;

GRANT INSERT, UPDATE ON trabalho_dois.hospedagem_servico TO "role_atendente_geral";

GRANT SELECT ON view_atendente_geral TO "role_atendente_geral";

-- 3) Criação de, no mínimo, um usuário para cada grupo criado;

CREATE OR REPLACE USER gerente IDENTIFIED BY '12345';
CREATE OR REPLACE USER recepcionista IDENTIFIED BY '12345';
CREATE OR REPLACE USER atendente IDENTIFIED BY '12345';

GRANT "role_gerente" TO gerente;
SET DEFAULT role "role_gerente" FOR gerente;

GRANT "role_recepcionista" TO recepcionista;
SET DEFAULT role "role_recepcionista" FOR recepcionista;

GRANT "role_atendente_geral" TO atendente;
SET DEFAULT role "role_atendente_geral" FOR atendente;

-- 4) Efetuar o login na interface de sua preferência (ferramenta de interação: ex. HeidiSQL) com um usuário de cada papel, 
-- realizando sequência de comandos para validar os mecanismos de segurança implementados. É necessário o registro de cada 
-- operação por meio de "prints" de tela exibindo mensagem de sucesso/insucesso em cada operação simulada, assim como a 
-- limitação de operações não autorizadas;