-- Rodrigo Kapulka Franco

-- a) manter um log com todas as operações DML (insert, update e delete) realizadas na tabela cliente. Dica, criar uma 
-- tabela e registrar os eventos (logs) com: data, hora, operação realizada e usuário. Utilize o usuário 
-- logado na seção (função user()) para saber o usuário que executou a operação. Importante: nos casos que 
-- envolve alterações (update), registrar no logo o valor antigo e o novo valor (alterado);

-- Tabela para armazenar os logs de cada operacao
CREATE OR REPLACE TABLE OPERATION_LOG (
    CD_OPERATION INTEGER AUTO_INCREMENT NOT NULL,
    DT_OPERATION DATE NOT NULL,
    HR_OPERATION TIME NOT NULL,
    DS_USER VARCHAR(50) NOT NULL,
    DS_OPERATION varchar(50) NOT NULL,
    DS_OLD_VALUE varchar(50),
    DS_NEW_VALUE varchar(50),
    CONSTRAINT OPERATION_LOG_pk PRIMARY KEY (CD_OPERATION)
);

delimiter $$
CREATE OR REPLACE TRIGGER tg_generate_insert_log
AFTER INSERT ON cliente FOR EACH ROW 
BEGIN 
	INSERT INTO operation_log(DT_OPERATION, HR_OPERATION, DS_USER, DS_OPERATION) 
	VALUES(CURDATE(), CURTIME(),  USER(), 'INSERT');
END $$

-- Para cada mudança em uma coluna da tabela e gerado um log 
delimiter $$
CREATE OR REPLACE TRIGGER tg_generate_update_log
AFTER UPDATE ON cliente FOR EACH ROW 
BEGIN 
	IF NEW.nm_cliente <> OLD.nm_cliente THEN
		INSERT INTO operation_log(DT_OPERATION, HR_OPERATION, DS_USER, DS_OPERATION, DS_OLD_VALUE, DS_NEW_VALUE )
		VALUES(CURDATE(), CURTIME(),  USER(), 'UPDATE', OLD.nm_cliente, NEW.nm_cliente);
	END IF;
	IF NEW.ds_email <> OLD.ds_email THEN  
		INSERT INTO operation_log(DT_OPERATION, HR_OPERATION, DS_USER, DS_OPERATION, DS_OLD_VALUE, DS_NEW_VALUE )
		VALUES(CURDATE(), CURTIME(),  USER(), 'UPDATE', OLD.ds_email, NEW.ds_email);
	END IF;
	IF NEW.nr_telefone <> OLD.nr_telefone THEN  
		INSERT INTO operation_log(DT_OPERATION, HR_OPERATION, DS_USER, DS_OPERATION, DS_OLD_VALUE, DS_NEW_VALUE )
		VALUES(CURDATE(), CURTIME(),  USER(), 'UPDATE', OLD.nr_telefone, NEW.nr_telefone);
	END IF;
END $$

delimiter $$
CREATE OR REPLACE TRIGGER tg_generate_delete_log
AFTER DELETE ON cliente FOR EACH ROW 
BEGIN 
	INSERT INTO operation_log(DT_OPERATION, HR_OPERATION, DS_USER, DS_OPERATION) 
	VALUES(CURDATE(), CURTIME(),  USER(), 'DELETE');
END $$

-- b) criar uma rotina que sinalize (liste) a disponibilidade de quarto(s), 
-- ou seja sem reserva, considerando uma determinada data passada com parâmetro;
-- Averiguar se está correto

delimiter $$
CREATE OR REPLACE FUNCTION fc_date_is_between (DATA DATE, CD_RESERVA INTEGER) RETURNS BOOLEAN 
-- Funcao que verifica se existe uma reserva na data escolhida
-- Funcao AUXILIAR
BEGIN 
	DECLARE dt_reserve_end DATE;
	DECLARE dt_reserve_begin DATE;
	
	IF (SELECT COUNT(*) FROM reserva R WHERE R.NR_RESERVA = CD_RESERVA) = 0 THEN 
		RETURN TRUE;
	END IF; 

	SELECT R.DT_ENTRADA, ADDDATE(R.DT_ENTRADA, R.QT_DIARIAS)
	INTO dt_reserve_begin, dt_reserve_end
	FROM reserva R WHERE R.NR_RESERVA = CD_RESERVA;
	
	IF DATA < dt_reserve_begin OR dt_reserve_end < DATA THEN
		RETURN TRUE;
	END IF;
	RETURN FALSE;
END $$

-- Funcao PRINCIPAL
delimiter $$
CREATE OR REPLACE PROCEDURE pc_avaliable_room (IN DATA DATE) 
BEGIN	
        SELECT Q.NR_QUARTO, Q.CD_CATEGORIA, Q.DS_QUARTO, Q.NR_OCUPANTES 
        FROM quarto AS Q LEFT JOIN reserva AS R
        ON R.NR_QUARTO = Q.NR_QUARTO 
        WHERE fc_date_is_between(DATA, R.NR_RESERVA);
END $$

call pc_avaliable_room(CURDATE());

-- c) criar uma rotina para adicionar uma hospedagem passando como parâmetros: cliente (o seu cadastro, 
-- ou seja, seu id/nome), quarto, data de entrada e data prevista de saída. Utilizar cd_funcionario (1) 
-- visto que não teremos controle de autenticação, e fl_situacao ('O') para ocupado.  Atenção para a validação 
-- da reserva do cliente, pois a hospedagem só deve acontecer se houver reserva prévia;

DELIMITER $$
CREATE OR REPLACE PROCEDURE pc_add_hospedagem(IN cd_cliente INTEGER, IN nr_quarto INTEGER, IN dt_entrada DATE, IN dt_saida DATE)
BEGIN
	DECLARE qtd_reserve INTEGER;
	
	SELECT COUNT(*) INTO qtd_reserve 
	FROM reserva R 
	WHERE R.CD_CLIENTE = cd_cliente 
	AND R.NR_QUARTO = nr_quarto
	AND R.DT_ENTRADA = dt_entrada;

	IF qtd_reserve > 0 THEN
		INSERT INTO hospedagem(dt_entrada, dt_saida, fl_situacao, cd_cliente, cd_funcionario, nr_quarto) 
		VALUES(dt_entrada, dt_saida, 'O', cd_cliente, 1, nr_quarto);
	END IF;
END $$

-- d) criar uma rotina para adicionar um serviço a uma determinada hospedagem. Considerar os seguintes 
-- parâmetros: identificação da hospedagem e serviço. Atenção para a data de solicitação que deve ser a 
-- atual e o número de sequência (que deve seguir incremental apenas dentro do número da hospedagem, ou seja, 
-- este número é zerado para cada nova hospedagem);

DELIMITER $$
CREATE OR REPLACE PROCEDURE pc_insert_hosp_service (IN cd_hospedagem INTEGER, IN cd_servico INTEGER)
BEGIN 
	DECLARE qtd_services INTEGER;
	
	SELECT COUNT(*) INTO qtd_services FROM hospedagem_servico AS H WHERE H.CD_HOSPEDAGEM = cd_hospedagem;
	
	INSERT INTO HOSPEDAGEM_SERVICO (CD_HOSPEDAGEM, CD_SERVICO, NR_SEQUENCIA, DT_SOLICITACAO)
	VALUES (cd_hospedagem, cd_servico, qtd_services+1, CURDATE());
END $$

-- e) criar uma rotina para mudar o status (coluna fl_situacao) para 'F' - finalizada. Esta rotina deverá 
-- receber como parâmetro o identificador da hospedagem. 

DELIMITER $$
CREATE OR REPLACE PROCEDURE pc_finalize_fl_status (IN cd_hospedagem INTEGER)
BEGIN
	UPDATE hospedagem AS H SET H.FL_SITUACAO = 'F' WHERE H.CD_HOSPEDAGEM = cd_hospedagem;  
END $$

