-- g

WITH search AS 
(
	SELECT B.nm_bairro, COUNT(*) AS qtd
	FROM logradouro L, bairro B
	WHERE L.sg_uf = 'SC' AND L.cd_bairro_inicio = B.cd_bairro
	GROUP BY B.nm_bairro
)

SELECT S.nm_bairro FROM search S
WHERE S.qtd = (SELECT MAX(qtd) FROM search);

-- ou
