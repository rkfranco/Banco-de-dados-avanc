-- teste geracao de logs A
SELECT * FROM operation_log;

INSERT INTO cliente (nm_cliente, ds_email, nr_telefone)
VALUES ('Cliente teste','cliente1@provedor.com.br','47999990000');

UPDATE cliente SET ds_email = 'teste@email.com' WHERE nm_cliente = 'Cliente teste';
UPDATE cliente SET nm_cliente = 'teste da silva' WHERE ds_email = 'teste@email.com';
UPDATE cliente SET nr_telefone = '123' WHERE ds_email = 'teste@email.com';

DELETE FROM cliente WHERE nr_telefone = '123';

-- Teste  B
SELECT * FROM quarto
SELECT * FROM reserva
DELETE FROM reserva
INSERT INTO RESERVA (DT_RESERVA, DT_ENTRADA, QT_DIARIAS, FL_SITUACAO, CD_CLIENTE, NR_QUARTO, CD_FUNCIONARIO) 
values(ADDDATE(CURDATE(), -5), ADDDATE(CURDATE(), -5), 5, 'R', 1, 102, 1);

-- Teste C
DELETE FROM reserva;
DELETE FROM hospedagem;

CALL pc_add_hospedagem(1, 101, CURDATE(), ADDDATE(CURDATE(), 5));
SELECT * FROM hospedagem;

INSERT INTO RESERVA (DT_RESERVA, DT_ENTRADA, QT_DIARIAS, FL_SITUACAO, CD_CLIENTE, NR_QUARTO, CD_FUNCIONARIO) 
values(CURDATE(), CURDATE(), 5, 'O', 1, 101, 1);
SELECT * FROM reserva;

CALL pc_add_hospedagem(1, 101, CURDATE(), ADDDATE(CURDATE(), 5));
SELECT * FROM hospedagem;

-- Teste D
SELECT * FROM hospedagem;
SELECT * FROM servico;


CALL pc_insert_hosp_service(2, 1);
CALL pc_insert_hosp_service(2, 2);
CALL pc_insert_hosp_service(2, 3);
SELECT * FROM hospedagem_servico;

INSERT INTO RESERVA (DT_RESERVA, DT_ENTRADA, QT_DIARIAS, FL_SITUACAO, CD_CLIENTE, NR_QUARTO, CD_FUNCIONARIO) 
values(CURDATE(), CURDATE(), 5, 'O', 1, 103, 1);
SELECT * FROM reserva
CALL pc_add_hospedagem(1, 103, CURDATE(), ADDDATE(CURDATE(), 5));
SELECT * FROM hospedagem;

CALL pc_insert_hosp_service(3, 1);
CALL pc_insert_hosp_service(3, 2);
CALL pc_insert_hosp_service(3, 3);
CALL pc_insert_hosp_service(3, 4);
SELECT * FROM hospedagem_servico;

DELETE FROM hospedagem_servico;

-- teste -- Neste caso e 2 E
CALL pc_finalize_fl_status(2);
SELECT * FROM hospedagem;