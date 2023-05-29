-- Aluno: Rodrigo Kapulka franco

-- Considerando o modelo para a base de dados apresentada, elabore sentenças SQL para atender as requisições a seguir. Lembre-se de utilizar os recursos de otimização, em especial a criação de índices, para as estruturas que julgar necessário.
-- a) Total de localidades por Unidade da Federação (UF);

SELECT L.sg_uf AS UF, COUNT(*) AS 'Quantidade de localidades' 
FROM localidade L
GROUP BY L.sg_uf; 

-- b) Qual é a UF que apresenta o maior número de municípios (fl_tipo_localidade= 'M'). Considerar que pode haver UFs com o mesmo número máximo de municípios;

WITH search AS 
(
	SELECT L.sg_uf AS UF, COUNT(*) AS QTD_LOC
	FROM localidade L
	WHERE L.fl_tipo_localidade= 'M'
	GROUP BY L.sg_uf
	-- ORDER BY COUNT(*) DESC
)

SELECT * FROM search
WHERE search.QTD_LOC = (SELECT MAX(search.QTD_LOC) FROM search);

-- c) Qual o número de CEPs encontrados em cada município (fl_tipo_localidade= 'M'), com respectiva UF, ordenados pelo maior número (de CEPs listados). Considerar apenas os municípios que possuem mais de um CEP (tabela logradouro);

SELECT LC.cd_localidade, LC.nm_localidade, LG.sg_uf, COUNT( LG.nr_cep) AS nr_cep
FROM logradouro LG INNER JOIN localidade LC
ON LG.cd_localidade = LC.cd_localidade 
WHERE LC.fl_tipo_localidade = 'M'
GROUP BY LC.cd_localidade
HAVING COUNT( LG.nr_cep) > 1
ORDER BY nr_cep DESC;

-- d) Qual o nome do logradouro mais popular no Brasil, ou seja, o que é encontrado no maior número de localidades. Atenção, aqui poderá haver mais de um logradouro, haja vista que podem apresentar o mesmo número de ocorrências e, neste caso, todos os empatados na 1a. posição (maior número) devem ser exibidos;

WITH search AS 
(
	SELECT LG.nm_logradouro AS nm_logradouro, COUNT(DISTINCT LC.cd_localidade) AS qtd_loc
	FROM logradouro LG, localidade LC
	WHERE LG.cd_localidade = LC.cd_localidade
	GROUP BY LG.nm_logradouro
)

SELECT * FROM search 
WHERE search.qtd_loc = (SELECT MAX(search.qtd_loc) FROM search); 

-- e) Qual a localidade (nome) que apresenta o maior número de CEPs especiais (grandes usuários). Listar também a UF e a localidade;

WITH search AS 
(
	SELECT L.nm_localidade, COUNT(G.nr_cep) AS nr_cep, G.sg_uf AS UF, L.fl_tipo_localidade AS tipo
	FROM grande_usuario G, localidade L
	WHERE  G.cd_localidade = L.cd_localidade
	GROUP BY G.cd_localidade
)

SELECT * FROM search 
WHERE nr_cep = (SELECT MAX(nr_cep) FROM search);

-- f) Quais municípios possuem distrito (fl_tipo_localidade= 'D'). Listar também o número de distritos de cada município listado, ordenando pelo maior número encontrado;

SELECT L1.nm_localidade AS 'Município', COUNT(*) AS 'Qtd distritos'
FROM localidade L1 INNER JOIN localidade L2 ON L1.cd_localidade = L2.cd_localidade_sub
WHERE L1.fl_tipo_localidade = 'M' AND L2.fl_tipo_localidade = 'D'
GROUP BY L1.nm_localidade
ORDER BY 2 DESC;

-- g) Listar o nome do, ou dos bairros mais populares (que mais são encontrados) na UF "SC", caso tenhamos empate no número máximo listado;

WITH search AS 
(
	SELECT B.nm_bairro, COUNT(*) AS qtd
	FROM bairro B
	WHERE B.sg_uf = 'SC'
	GROUP BY B.nm_bairro -- Errei por bobeira
)

SELECT * FROM search S
WHERE S.qtd = (SELECT MAX(qtd) FROM search);

-- h) Qual o número de CEPs dos bairros dos municípios da UF "SC" que apresentam mais de um CEP (tabela logradouro). Listar o nome do bairro, também. Ordenar pelo maior número de CEPs;

-- Juntando pela chave do bairro
WITH search AS 
(
	SELECT B.cd_bairro, B.nm_bairro, COUNT(L.nr_cep) AS qtd_cep
	FROM logradouro L, bairro B
	WHERE L.sg_uf = 'SC' 
	AND L.cd_bairro_inicio = B.cd_bairro
	GROUP BY B.cd_bairro
)

SELECT * FROM search S
WHERE S.qtd_cep > 1
ORDER BY S.qtd_cep DESC;

-- i) Qual o nome de logradouro mais popular encontrado nos municípios da UF "SC". Listar também o número de vezes encontrado, ordenando pelo maior número;

SELECT L.nm_logradouro, COUNT(*) AS qtd
FROM logradouro L
WHERE L.sg_uf = 'SC'
GROUP BY L.nm_logradouro
ORDER BY COUNT(*) DESC;

-- j) Quais nomes de municípios são encontrados em mais de uma UF. Listar também a quantidade de vezes em que o mesmo é encontrado;

SELECT L.cd_localidade, L.nm_localidade, COUNT(sg_uf) AS qtd_sg_uf
FROM localidade L 
WHERE L.fl_tipo_localidade = 'M'
GROUP BY L.nm_localidade
HAVING qtd_sg_uf > 1
ORDER BY 3 DESC;

-- k) Listar o nome de todos os bairros do município de "Blumenau", UF "SC", com a respectiva quantidade de CEPs associados a cada bairro listado;

SELECT B.nm_bairro, COUNT(L.nr_cep) AS qtd_cep
FROM logradouro L, bairro B, localidade LC
WHERE LC.cd_localidade = L.cd_localidade
AND L.cd_bairro_inicio = B.cd_bairro
AND LC.fl_tipo_localidade = 'M'
AND B.sg_uf = 'SC'
AND L.nm_logradouro = 'Blumenau'
GROUP BY B.cd_bairro
ORDER BY 2 desc;

-- l) Listar o nome dos logradouros que iniciam em um bairro e terminam em outro (ver colunas cd_bairro_inicio e cd_bairro_fim) da UF "SC". Listar também o nome dos respectivos bairros (início e fim);

WITH bairro_incio AS(
	SELECT L.nm_logradouro, B.nm_bairro AS bairro_inicio
	FROM logradouro L JOIN bairro B ON B.cd_bairro = L.cd_bairro_inicio 
	WHERE L.cd_bairro_inicio <> L.cd_bairro_fim 
	AND L.sg_uf = 'SC' 
	AND L.cd_bairro_fim IS NOT NULL 
)

SELECT L.nm_logradouro, I.bairro_inicio , B.nm_bairro AS bairro_fim
FROM logradouro L, bairro B, bairro_incio I 
where B.cd_bairro = L.cd_bairro_fim 
AND L.sg_uf = 'SC'
AND I.nm_logradouro = L.nm_logradouro
AND L.cd_bairro_fim IS NOT NULL 
and L.cd_bairro_inicio <> L.cd_bairro_fim;


-- m) Listar o nome do(s) bairro(s) que apresenta(m) o maior número de logradouros associado. Listar também o nome da localidade e a sigla da UF onde se encontra este(s) bairro(s);

WITH search AS 
(
	SELECT B.nm_bairro, COUNT(*) AS qtd, LC.nm_localidade, B.sg_uf
	FROM bairro B, logradouro LG, localidade LC
	WHERE B.cd_bairro = LG.cd_bairro_inicio
	AND LG.cd_localidade = LC.cd_localidade
	GROUP BY B.cd_bairro -- Errei pela chave
	ORDER BY 2 desc
)

SELECT nm_bairro, nm_localidade, sg_uf
FROM search
WHERE qtd = (SELECT MAX(qtd) FROM search);

-- o) Criar uma view para listar o nome do município e a respectiva quantidade de bairros associado ao mesmo. Listar também a sigla da UF;

CREATE OR
REPLACE VIEW exe_o AS
SELECT LC.nm_localidade AS 'Munícipio', LC.sg_uf AS 'UF', COUNT(DISTINCT LG.cd_bairro_inicio) AS 'qtd_bairro'
FROM logradouro LG, localidade LC
WHERE LG.cd_localidade = LC.cd_localidade 
AND LC.fl_tipo_localidade = 'M'
GROUP BY LC.nm_localidade
ORDER BY LC.nm_localidade;

-- chamar view
SELECT *
FROM exe_o; 

-- p) Criar uma view para listar a sigla da UF com a respectiva quantidade de  municípios que apresentam mais de um CEP;

CREATE OR
REPLACE VIEW exe_p AS
WITH search AS (
	SELECT LC.nm_localidade, LC.sg_uf, COUNT(distinct LG.nr_cep) AS qtd_cep
	FROM localidade LC INNER JOIN logradouro LG ON LG.cd_localidade = LC.cd_localidade
	WHERE LC.fl_tipo_localidade = 'M'
	GROUP BY LC.nm_localidade, LC.sg_uf
)

SELECT S.sg_uf, COUNT(S.nm_localidade)
FROM search S
WHERE S.qtd_cep > 1
GROUP BY S.sg_uf 
ORDER BY S.sg_uf;

-- chamar view
SELECT *
FROM exe_p; 

-- q) Criar uma view com todos os CEPS existentes na base de dados (localidades, logradouros e grandes usuários). Além do número do CEP, em havendo dados complementares (logradouro, bairro, localidade, uf) estes deverão presentes também. Aos CEPS que não apresentarem dados complementares, recomenda-se deixar em branco estes atributos nas linhas (registros).

CREATE OR
REPLACE VIEW exe_q AS
SELECT GU.nr_cep, LG.nm_logradouro, LC.nm_localidade, B.nm_bairro, GU.nm_grande_usuario, LG.sg_uf
FROM grande_usuario GU 
LEFT JOIN logradouro LG ON GU.cd_logradouro = LG.cd_logradouro
LEFT JOIN localidade LC ON GU.cd_localidade = LC.cd_localidade
LEFT JOIN bairro B ON GU.cd_bairro = B.cd_bairro

UNION 

SELECT LG.nr_cep, LG.nm_logradouro, LC.nm_localidade, B.nm_bairro, '' AS nm_grande_usuario, LG.sg_uf
FROM  logradouro LG
LEFT JOIN localidade LC ON LC.cd_localidade = LG.cd_localidade
LEFT JOIN bairro B ON LG.cd_bairro_inicio = B.cd_bairro

UNION  

SELECT nr_cep AS nr_cep, '' AS nm_logradouro,nm_localidade, '' AS nm_bairro, '' AS nm_grande_usuario, L.sg_uf 
FROM localidade L 
WHERE nr_cep IS NOT NULL

GROUP BY nr_cep;

-- chamar view
SELECT *
FROM exe_q WHERE nr_cep IS NOT NULL; 