-- Gerente

-- Recepcionista

-- Atendente
SELECT * FROM trabalho_dois.view_atendente_geral;

SELECT * FROM trabalho_dois.hospedagem_servico;


-- Inseri um registro usando outro usuario na tabala hospedagem (estava vazia e não permitia a criação de um registro aqui)
INSERT INTO trabalho_dois.hospedagem_servico (CD_HOSPEDAGEM, CD_SERVICO, NR_SEQUENCIA, DT_SOLICITACAO) 
VALUES (1, 1, 1, "2023-05-13");

