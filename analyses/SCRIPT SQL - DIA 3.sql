/************** UNION - UNION ALL **************/
CREATE TABLE TREINAMENTO.A(
    ID INT NOT NULL,
    NOME VARCHAR(10) NOT NULL)

CREATE TABLE TREINAMENTO.B(
    ID INT NOT NULL,
    NOME VARCHAR(10) NOT NULL)

INSERT INTO TREINAMENTO.A VALUES (1, 'Fiat'), (2, 'Ferrari'), (3, 'VW')
INSERT INTO TREINAMENTO.B VALUES (2, 'Renault'), (3, 'Ferrari'), (4, 'Ford')

-- Mostrar tabelas
select * from TREINAMENTO.A
select * from TREINAMENTO.b


-- Union
-- EXPLICAR QUE TEM O DISTINCT IMPLICITO
select id, nome from TREINAMENTO.A
union 
select id, nome from TREINAMENTO.B


select id, nome from TREINAMENTO.A
union all
select id, nome from TREINAMENTO.B

/* Vamos trazer algo pro mundo real, peguei e dei um select para simular tabelas com n° de colunas diferentes
*/

-- UNION - COMPLENTANDO COLUNAS COM NULL APÓS CONSULTA COM NÚMERO DE COLUNAS DIFERENTES

SELECT
	OrderID as PedidoID,
	CustomerID,
	EmployeeID,
	ShipCountry,
	Freight,
	ShipName
FROM TREINAMENTO.Orders
WHERE ShipRegion IS NOT NULL
AND EmployeeID = 4
AND CustomerID = 'RATTC'

UNION

SELECT
	OrderID,
	CustomerID,
	EmployeeID,
	ShipCountry,
	ShipCity
FROM treinamento.Orders
WHERE ShipCountry = 'Portugal'
-- Explicar que da erro com UNION assim devido a quantidade de colunas
-- Predomina os alias da primeira tabela
-- PERGUNTAR SE ALGUÉM TEM IDEIA DA SOLUÇÃO?





-- UNION - COMPLENTANDO COLUNAS COM NULL - SOLUCAO

SELECT  
	OrderID AS PEDIDOID
	,CustomerID
	,EmployeeID
	,ShipCountry
	,null AS ShipCity -- POR DEPOIS EXPLICAR QUE VAI ASSUMIR VALOR NULO PARA TODA COLUNA
	,Freight
	,ShipName
	,'A' AS TableSource -- POR DEPOIS
FROM treinamento.Orders
WHERE ShipRegion IS NOT NULL
AND EmployeeID = 4
AND CustomerID = 'RATTC'

UNION

SELECT
	OrderID
	,CustomerID
	,EmployeeID
	,ShipCountry
	,ShipCity
	,NULL -- POR DEPOIS
	,NULL -- POR DEPOIS
	,'B' AS TableSource -- POR DEPOIS
FROM treinamento.Orders
WHERE ShipCountry = 'Portugal'  

-- Sistema A não tem cidade de entrega, e sistema B não tem frete nem o nome do transportador
-- Mas podemos juntar os dois resultados e trazer.

-- Explicar que poderiamos ter outro UNION com uma consulta C por exemplo
-- COPIAR BLOCO DO SEGUNDO E COLAR COM FILTRO DE PAIS FRANCE!






-- UNION COM ERRO 2: COLUNAS DE TIPOS DIFERENTES (Erro de conversão) 
SELECT  
	OrderID,
	CustomerID,
	EmployeeID,
	ShipCountry, 
	ShipCity
FROM treinamento.Orders
WHERE ShipRegion IS NOT NULL
AND CustomerID = 'RATTC'

UNION

SELECT
	OrderID,
	CustomerID,
	ShipCountry,
	EmployeeID,
	ShipCity
FROM treinamento.Orders
WHERE ShipCountry = 'Portugal'

-- ERRO NA HORA DE FAZER CONVERSÃO -- Ajustar trocando a ordem
-- SOLUÇÃO AJUSTAR ORDEM
SELECT  
	OrderID,
	CustomerID,
	ShipCountry,
	EmployeeID, 
	ShipCity
FROM treinamento.Orders
WHERE ShipRegion IS NOT NULL
AND CustomerID = 'RATTC'

UNION

SELECT
	OrderID,
	CustomerID,
	ShipCountry,
	EmployeeID,
	ShipCity
FROM treinamento.Orders
WHERE ShipCountry = 'Portugal'







-- UNION COM TABELA DERIVADA. TABELA DERIVADA É UMA TABELA GERADA A PARTIR DE UMA CONSULTA (SELECT * FROM <TABELA> - PODENDO SER COM JOIN OU NÃO) EM TEMPO DE EXECUÇÃO
-- 1: Fazer o SELECT dentro da subquery  2: Jogar o select com select * from (query)
-- 3: JOIN  4: Case
-- E se eu quiser fazer um case só com o UNION? Eu não consigo, não tenho solução
select 
*,
CASE 
	WHEN tbSource = 'A' THEN CONCAT('Seu destino veio da tabela A e pais: ', PaisEntrega)
	ELSE 
		 CONCAT('Seu destino veio da tabela B e pais : ', PaisEntrega) 
	END
from (
SELECT  
	OrderID AS CodigoPedido,
	CustomerID AS IdCliente,
	ShipCountry AS PaisEntrega,
	EmployeeID,
	ShipCity,
	Freight,
	ShipName,
	'A' AS	tbSource
FROM treinamento.Orders
WHERE ShipPostalCode = '1010'

UNION

SELECT
	OrderID,
	CustomerID,
	ShipCountry,
	EmployeeID,
	ShipCity,
	Freight,
	ShipName,
	'B' AS	tbSource
FROM treinamento.Orders
WHERE CustomerID = 'QUEEN'
) as X

LEFT JOIN treinamento.Employees AS E
	ON x.EmployeeID = e.EmployeeID

-- Explicar que primeira ele realiza a consulta interna e depois a externa
-- De dentro para fora.




/*Union de tabelas diferentes com tabela derivada, case de tabela de origem*/
-- 1: Fazer o SELECT dentro da subquery  2: Jogar o select com select * from (query)
-- 3: JOIN  4: Case

SELECT TOP 3 * from TREINAMENTO.CUSTOMERS
SELECT TOP 3 * FROM TREINAMENTO.EMPLOYEES

select
	*,  
	case 
		WHEN ClienteID IS NOT NULL THEN 'Tabela cliente'
	ELSE 'Tabela funcionários'
	END AS TesteCase
from (

select 
	CustomerID as ClienteID,
	null as FuncionarioID,
	ContactName as Nome,
	Address,
	City,
	Country
from TREINAMENTO.Customers

union

select 
	null,
	EmployeeID, -- Mostrar formas de fazer o concat >>
	(FirstName + ' ' + LastName), --Concat(FirstName, ' ' , LastName), -- Concat_ws(' ', FirstName, LastName)
	Address,
	City,
	null
from TREINAMENTO.Employees
) X
	left join TREINAMENTO.Orders as o
		on x.FuncionarioID = o.EmployeeID
-- Eu posso filtrar resultados, fazer um WHERE






/************** DECLARAÇÃO DE VARIÁVEIS **************/
/*É querer declarar um valor, que é variante e que pode mudar dinamicamente. 
Ou seja, o valor pode mudar de acordo com o que você precisa
*/
--MANEIRA 1 DE DECLARAR UMA VARIAVEL

DECLARE @TEXTO VARCHAR(20) --DECLARANDO A VARIAVEL -- DECLAR + NOME_VARIAVEL + TIPO
SET @TEXTO = 'POD' -- SETAR VALOR NA VARIAVEL -- TEMOS QUE SETAR OQ A VARIAVEL VAI ARMAZENAR

SELECT @TEXTO -- Quando executo sozinho o select da erro, pq é temporario. existe no momento da execução

--MANEIRA 2 DE DECLARAR UMA VARIAVEL
DECLARE @DT DATE = GETDATE(), @VALOR smallmoney = 60.10  -- Declarando duas variaveis NOME + TIPO = VALOR

SELECT @DT, @VALOR

-- VARIAVEIS FILTRANDO CONSULTA EM UMA TABELA
DECLARE @DT1 DATE, @DT2 DATE
SET @DT1 = '1991-05-20' -- Estou dizendo que DT1 recebe esse valor
SET @DT2 = '1991-05-25' -- Estou dizendo que DT1 recebe esse valor

SELECT *
FROM treinamento.Orders -- Vou lá no banco e quero buscar data entre essas variaveis
WHERE OrderDate BETWEEN @DT1 AND @DT2
--> se o valor aumentou agora é 30, rexecutamos

-- VARIAVEL RECEBENDO VALOR DE UM CONSULTA EM TABELA
DECLARE @PAIS VARCHAR (20)
SET @PAIS = (
			SELECT TOP 1 ShipCountry
			FROM treinamento.Orders
			ORDER BY Freight DESC
			) -- Esse select, que retorna o pais com frete mais caro (fazer ele sozinho)
			 -- Um banco que pode mudar toda hora o valor do frete mais caro

SELECT *
FROM treinamento.Orders
WHERE ShipCountry = @PAIS

--> Mostrar que isso funciona também com uma subconsulta, jogar valor da variavel dentro do where




--VARIAVEL RECEBENDO VALOR DE UM CONSULTA EM TABELA 2
DECLARE @dtpedido DATE
SET @dtpedido = (
			SELECT max(OrderDate)
			FROM treinamento.Orders
			where ShipCountry = 'Brazil'	
			) -- Select trazendo a maior data de entrega do Brasil, o pedido mais recente feito no Brasil

SELECT *
FROM treinamento.Orders
WHERE OrderDate > @dtpedido -- Me traga pedidos quando o valor for maior do que está na variavel
							-- 8 pedidos que são maiores que a maior data do Brasil	

--> Mostrar o erro que retorna se retirar o max, vai falar que retornou mais de um valor e não é permitido



-- OUTRA MANEIRA DE DECLARAR VARIAVEIS COM DADOS DE UMA TABELA
--> TER CUIDADO SE NÃO USAR O MAX ELE VAI TRAZER UM VALOR(APRENDI RECENTEMENTE)
DECLARE @dtpedido2 DATE

SELECT  @dtpedido2 = max(OrderDate)
FROM treinamento.Orders
where ShipCountry = 'Brazil'	
			
SELECT @dtpedido2



-- VARIAVEL DO TIPO TABELA
--> Criar uma tabela em memoria
DECLARE @TABELA TABLE (
ID INT IDENTITY,
NOME VARCHAR(10),
PROVA1 INT,
PROVA2 INT
)

INSERT INTO @TABELA (NOME, PROVA1, PROVA2)
VALUES ('VINICIUS','10','8')
	  ,('MARCOS','6','10')
	  ,('LEO','9','5')
	  ,('ANA','4','8')

SELECT * FROM @TABELA
WHERE PROVA2 > (SELECT AVG(PROVA2) FROM @TABELA) -- Fazer só com avg para mostrar que n funciona 
--> Qual finalidade disso? Pode ser usado para teste lógico... para testar uma lógica rápida



-- VARIAVEL DO TIPO TABELA - INSERINDO VALORES DE UMA TABELA REAL - DEPOIS REALIZANDO JOIN DA VARIAVEL TIPO TABELA COM UMA TABELA REAL

DECLARE @TABELAVENDAS TABLE (
VendaID INT,
CodigoCliente VARCHAR(20),
NomVendedor VARCHAR(20),
DataPedido DATE
)

INSERT INTO @TABELAVENDAS (VendaID, CodigoCliente, NomVendedor, DataPedido) -- Conceito insert select, adicionar apartir de um select
-- PRIMEIRO
SELECT O.OrderID, O.CustomerID, E.FirstName, O.OrderDate 
FROM treinamento.Orders AS O 
left join treinamento.Employees as e
	on O.EmployeeID = e.EmployeeID -- Executar só até aqui para mostrar que ele executa
--
SELECT T.*, C.CompanyName AS NomeCliente
FROM @TABELAVENDAS AS T
LEFT JOIN treinamento.Customers AS C
	ON T.CodigoCliente = C.CustomerID

-- No primeiro criamos a tabela, no segundo pegamos as tabelas e inserimos com dados de um join
-- e por ultimo peguei o resultado da tabela vendas que estava carregada e fizemos um join com clientes



/************** SQL FUNCTIONS **************/


/*** CONVERSÃO IMPLICITA ***/

-- O VALOR COM MENOR PRECEDENCIA (TIPO MAIS FRACO) É CONVERTIDO PARA O DE MAIOR PRECEDENCIA(TIPO MAIS FORTE). 
--NUMERIC É MAIS FORTE QUE INTEIRO (Veja que o 10 sai com casa decimal)
-- Estou dizendo que minha variavel é um numerico 5,2 e armazenando nele um numero inteiro
DECLARE @VALOR1 NUMERIC(5,2) = 10
SELECT @VALOR1

-- SELECT COM WHERE BETWEEN EM FREIGHT
-- ANALISAR EXECUTION PLAN E NOTAR QUE OS VALOR 7 E 10 FORAM CONVERTIDOS IMPLICITAMENTE PARA MONEY
-- MOSTRAR NA TABELA QUE O TIPO DA COLUNA É MONEY
-- CRTL + L -- O SQL MOSTRA NO PLANO DE EXECUÇÃO QUE ELE TÁ CONVERTENDO DE UM TIPO PARA OUTRO
SELECT * FROM treinamento.Orders
WHERE Freight BETWEEN 7 AND 10

/*** FUNÇÕES PARA TRAZER A DATA DO SEU SERVIDOR DO SQL / MANIPULAR DATA ***/
SELECT GETDATE() as TEST_GETDATE --2021-05-15 11:44:24.543 
SELECT CURRENT_TIMESTAMP as TEST_CURRENT -- 2021-05-15 11:44:24.543
SELECT SYSDATETIME () as TEST_SYSDATETIME -- 2021-05-15 11:44:24.5450787
SELECT SYSDATETIMEOFFSET() AS TEST_SYSDATETIMEOFFSET -- 2021-05-15 11:45:52.0902620 -03:00
SELECT GETUTCDATE() AS TEST_GETUTCDATE -- 2021-05-15 14:45:52.090
SELECT DATEPART(YEAR, GETDATE()) AS AnoAtual -- Mostrar com dayofyear/day/weekday
SELECT DATEADD(MONTH, 3, GETDATE()) AS EmTresMeses
SELECT DATEDIFF(DAY, '1998-10-24', GETDATE()) AS DiasDesdeNascimento -- Trocar day por MONTH e YEAR



/*** FUNÇÕES DE CONVERSÃO ***/

--FUNÇÕES DE CONVERSÃO EXPLICITA: CAST (PADRÃO ANSI) - CONVERT(SQL SERVER/AZURE SQL/AZURE SYNAPSE ANALYTICS)

-- CAST /TRY_CAST (Declarar valor datetime)
DECLARE @DT3 DATETIME
SET @DT3 = GETDATE()

--- UTILIZANDO CAST EM VARIAVEL
SELECT CAST(@DT3 AS DATE) TEST_CAST -- Convertendo para DATE
SELECT TRY_CAST(@DT3 AS tinyint) TEST_TRYCAST -- CASO NÃO CONSIGA CONVERTER, RETORNE NULO


-- CAST /TRY_CAST -- ERRO DE CONVERSÃO (Tentando converter DATETIME para TINYINT)
DECLARE @DT4 DATETIME
SET @DT4 = GETDATE()

--- ERRO DE TIPO
SELECT CAST(@DT4 AS tinyint) TEST_CAST
--> Exige um cuidado, as vezes pode-se usar o try para ignorar e você pode acabar perdendo um erro.
--> Quando o cliente pegar o dash e perguntar cadê o campo tal? Então não pular para não dar erro na engenharia.
--> Se não tá conseguindo converter, tem que analisar na origem pq o campo tá vindo com erro. Letra espaço no meio

--> Mas blz, vc tá fazendo em variaveis, da pra fazer em uma coluna? dá sim
--UTILIZANDO CAST EM UMA TABELA
SELECT OrderDate,
	CAST(OrderDate AS DATE) AS DATA_PEDIDO
FROM [treinamento].Orders


--CONVERT / TRY_CONVERT
-->Mesmo exemplo só muda a sintaxe
DECLARE @DT5 DATETIME
SET @DT5 = GETDATE()

SELECT CONVERT(DATE, @DT5) TEST_CONVERT
SELECT TRY_CONVERT(tinyint, @DT5) TEST_TRYCCONVERT -- CASO NÃO CONSIGA CONVERTER, RETORNE NULO


--UTILIZANDO CONVERT EM UMA TABELA
SELECT OrderDate,
	CONVERT(DATE, OrderDate) AS DATAPEDIDO
FROM treinamento.Orders

-- CONVERT PARA TRANSFORMAÇÃO DE DATAS EM TEXTO COM FORMATAÇÃO DE PAÍS - TIPO 103 
-- Olhar site da Microsoft para ver os tipos
DECLARE @DT6 DATETIME
SET @DT6 = GETDATE()

SELECT CONVERT(VARCHAR, @DT6,103) TEST_CONVERT_DT

-- CONVERT PARA TRANSFORMAÇÃO DE DATAS EM TEXTO COM FORMATAÇÃO DE PAÍS - TIPO 112 - DATA EM TEXTO, DEPOIS TEXTO EM INTEIRO
DECLARE @DT7 DATETIME
SET @DT7 = GETDATE()

SELECT CONVERT(VARCHAR(15), @DT7, 112) TEST_CONVERT_ISO -- PADRÃO 112 -- 20210515 (Conversão de data em texto VARCHAR)
/* Função encadeada - Transformamos a data em ISO texto e depois em número inteiro.
Primeiro quero converter para inteiro, depois oq quero converter para inteiro? 
INTERNO É EXECUTADO PRIMEIRO QUE A EXTERNA */
SELECT CONVERT(INT, CONVERT(VARCHAR, @DT7,112)) TEST_CONVERT_ISO -- PADRÃO 112 -- 20210515 (Conversão em número)






/*** FUNÇÕES DE TEXTO ***/

-- Substring 
-- Parametro 1: Posição inicial de onde vai começar a cortar o texto.
-- Parametro 2: Quantos caracteres cortar.
DECLARE @TXT VARCHAR(11) = '00011122233' 
SELECT SUBSTRING(@TXT,7,3) AS TEST_SUBSTRING -- 222
SELECT SUBSTRING(@TXT,4,3) AS TEST_SUBSTRING -- 111

-- Substring na query
select  ContactName, substring(ContactName, 1, 5)
from treinamento.Customers

-- LEFT E RIGHT
DECLARE @TXT1 VARCHAR(11) = '00011122233'

SELECT LEFT (@TXT1, 3) TEST_LEFT
SELECT RIGHT(@TXT1, 2) TEST_RIGHT
SELECT RIGHT(LEFT (@TXT1, 6), 3) TESTE_LEFT_RIGHT ---000111 -- Alternativa para substring


select  ContactName, LEFT(ContactName, 1)
from [treinamento].Customers


-- LEN
DECLARE @TXT2 VARCHAR(11) = '00011122233'
SELECT LEN (@TXT2) AS TEST_LEN

select  ContactName, LEN(ContactName)
from [treinamento].Customers

select  ContactName, LEN(ContactName)
from [treinamento].Customers
WHERE LEN(ContactName) > 19


--CHARINDEX
DECLARE @TXT3 VARCHAR(20) = 'CONSULTA BD' ,@TXT4 VARCHAR(11) = '00011122233'

SELECT CHARINDEX('u', @TXT3) TEST_CHARINDEX

SELECT
CHARINDEX('1',@TXT4) ,
SUBSTRING(@TXT4, CHARINDEX('1',@TXT4), 3 )

select  ContactName, CHARINDEX('a',ContactName)
from [treinamento].Customers


--REPLACE
DECLARE @TXT5 VARCHAR(50) 
SET @TXT5 = 'APELIDO : PADAWAN'

SELECT REPLACE(@TXT5, ':', '>>') TEST_REPLACE 

-- Exemplo 2
DECLARE @TXT6 VARCHAR(50) 
SET @TXT6 = '000.111.222-33'

SELECT REPLACE(REPLACE(@TXT6, '.', ''),'-','') TEST_REPLACE 
SELECT REPLACE(REPLACE(REPLACE(@TXT6, '.', ''),'-',''),'0','*') TEST_REPLACE 

select  ContactName, REPLACE(ContactName,'A','@')
from [treinamento].Customers


DECLARE @TXT7 VARCHAR(50) 
SET @TXT7 = 'SERGIO  RODOLFO  BATISTA'


SELECT REPLACE(@TXT7, '  ', ' ') TEST_REPLACE 



/* UTILIZANDO UM REPLACE COM UPDATE PARA REMOVER ESPAÇOS EM BRANCO DE UMA COLUNA TEXTO
UPDATE <TABELA>
SET NOME = REPLACE(<NOME>, '  ', ' ')
WHERE NOME LIKE '%  %'
*/

--UPPER E LOWER
DECLARE @TXT8 VARCHAR(10) = 't-SQL'

SELECT UPPER(@TXT8) TEST_UPPER
SELECT LOWER(@TXT8) TEST_LOWER

--RTRIM, LTRIM, TRIM (VERSÃO 2017)
DECLARE @TXT9 VARCHAR(20) = '   T-SQL   '

SELECT RTRIM(@TXT9) TEST_RTRIM
SELECT LTRIM(@TXT9) TEST_LTRIM
SELECT RTRIM(LTRIM(@TXT9)) TEST_RTRIM_LTRIM
SELECT TRIM (@TXT9) TEST_TRIM

/*
'   T-SQL'
'T-SQL   '
'T-SQL'
'T-SQL'
*/

-- + (SIMBOLO DE MAIS) E O CONCAT
DECLARE @TXT10 VARCHAR(20) = 'SQL SERVER'

--Erro: CONCATENANDO TEXTO COM NÚMERO - ERRO DE CONVERSÃO
--SELECT @TXT10 + 2017 TEST_PLUS

-- É NECESSÁRIO CONVERTER EXPLICITAMENTE O TIPO MAIS FORTE NO TIPO MAIS FRACO
SELECT @TXT10 + ' - ' + CONVERT(VARCHAR (4), 2017)  TEST_PLUS_CONVERT

-- UTILIZANDO O + COM UMA COLUNA NULA = 
--SE EXISTIR UMA COLUNA COM VALOR NULO, TODA A STRING FICA NULA, É NECESSÁRIO TRATAR CADA COLUNA NULA
select City , Region , Country
from [treinamento].Customers

select City + ' ' + Region + ' ' + Country
from [treinamento].Customers


-->>Modo de concatenação com CONCAT<<
DECLARE @TXT11 VARCHAR(20) = 'SQL SERVER'

SELECT CONCAT(@TXT11, ' ' ,2017, ' ', GETDATE(),' - ' , REPLACE('ABC','B','Z'), '-' , LEFT('00112233',3) ) TEST_CONCAT

-- SE UMA COLUNA NO CONCAT ESTIVER NULA, ELA É IGNORADA
select CONCAT(City , ' ' , Region , ' ' , Country)
from [treinamento].Customers


-- CONCAT_WS
SELECT
 	e.FirstName
	,e.LastName
	,CONCAT(e.FirstName,'_', e.LastName, '_', LastName) as CONCAT_NORMAL
	,CONCAT_WS(' - ', e.FirstName, e.LastName, E.LastName) as CONCATWS
from [treinamento].Employees as e





/*** FUNÇÕES PARA TRATAMENTO DE NULOS ***/

SELECT * 
FROM [treinamento].Customers

-- TRATAMENTO DE NULOS
SELECT
ISNULL(NULL, 'Teste') AS TEST_ISNULL, -- Se o teu valor for nulo, coloque algo! (Teste)
NULLIF('SQL','SQL') AS TEST_NULLIF, -- 2 parametros, se a primeira condição for igual a segunda, retorne nulo.
NULLIF('T-SQL','SQL') AS TEST_NULLIF2, -- 2 parametros, se a primeira condição for diferente da segunda, traga primeira.
COALESCE(NULL, NULL, 'SQL') AS TEST_COALESCE, -- Traga o primeiro não nulo de uma lista de colunas
COALESCE(NULL, 'T-SQL', 'SQL') AS TEST_COALESCE2 -- Segundo teste coalesce

SELECT 
Region,
City,
country,
phone,
fax,
ISNULL(Region, 'SEM REGIÃO') AS TESTE1_ISNULL,
ISNULL(Region, City) AS TESTE2_ISNULL,
NULLIF(Region, 'BC') AS TESTE3_NULLIF, -- Se região for igual BC traz nulo, se não traz região.
COALESCE(Region, City, country ) AS TESTE4_COALESCE,
COALESCE(fax , phone ) AS TESTE5_COALESCE
FROM [treinamento].Customers

--  TRATANDO COLUNA NULA COM ISNULL CONCATENANDO COM O MAIS (+). FICAR ATENTO PARA TRATAR TODAS AS COLUNAS QUE CONTIVEREM VALORES NULOS
select City + ' ' + Region + ' ' + Country
from [treinamento].Customers

select City + ' ' + isnull(Region,'Sem região') + ' ' + Country
from [treinamento].Customers

-- CONCAT TRATANDO COLUNA NULA COM ISNULL
select CONCAT(City , ' ' , isnull(Region,0) , ' ' , Country)
from [treinamento].Customers





/*** FUNÇÕES DE DATA ***/


-- DATEPART
SELECT
DATEPART(YEAR , GETDATE()) AS 'ANO',
DATEPART(QUARTER, GETDATE() ) AS 'TRIMESTRE DO ANO',
DATEPART(MONTH, GETDATE()) AS 'MÊS',
DATEPART(DAYOFYEAR, GETDATE() ) AS 'DIA DO ANO (DE 1 A 365 )',
DATEPART(DAY, GETDATE() ) AS 'DIA',
DATEPART(WEEK, GETDATE() ) AS 'SEMANA',
DATEPART(WEEKDAY, GETDATE() ) AS 'DIA DA SEMANA',
DATEPART(HOUR, GETDATE() ) AS 'HORA',
DATEPART(MINUTE, GETDATE() ) AS 'MINUTO',
DATEPART(SECOND, GETDATE() ) AS 'SEGUNDO',
DATEPART(MILLISECOND, GETDATE() ) AS 'MILISEGUNDO',
DATEPART(MICROSECOND, GETDATE() ) AS 'MICROSEGUNDO',
DATEPART(NANOSECOND, GETDATE() ) AS 'NANOSEGUNDO'

SELECT 
	ORDERID, 
	OrderDate, 
	DATEPART (WEEKDAY, OrderDate) AS DIA_DA_SEMANA 
FROM [treinamento].Orders


--FILTRANDO DIA DA SEMANA - VERIFICANDO PEDIDOS FEITOS NO DOMINGO, DEPOIS TROCAR PARA SEGUNDA
SELECT 
	ORDERID, 
	OrderDate, 
	DATEPART (WEEKDAY, OrderDate) AS DIA_DA_SEMANA 
FROM [treinamento].Orders
WHERE DATEPART (WEEKDAY, OrderDate) =  2

-- DATEDIFF
SELECT
DATEDIFF(YEAR, '2018-01-01', GETDATE()) AS 'ANO',
DATEDIFF(MONTH, '2018-01-01' , GETDATE()) AS 'MÊS',
DATEDIFF(DAY, '2018-01-01' , GETDATE()) AS 'DIAS',
DATEDIFF(WEEK, '2018-01-01' , GETDATE()) AS 'SEMANA',
DATEDIFF(HOUR, '2018-01-01' , GETDATE()) AS 'HORA',
DATEDIFF(MINUTE, '2018-01-01' , GETDATE()) AS 'MINUTO'

SELECT DATEDIFF(YEAR,'1991-11-23', GETDATE())

-- utilizando funcao de data para filtrar registros
SELECT 
	ORDERID, 
	OrderDate, 
	ShippedDate,
	DATEDIFF (DAY, OrderDate, ShippedDate) AS DIFERENCA_DE_DIAS
FROM [treinamento].Orders
where DATEDIFF (DAY, OrderDate, ShippedDate) > 20


SELECT *
FROM (
SELECT 
	ORDERID, 
	OrderDate, 
	ShippedDate,
	DATEDIFF (DAY, OrderDate, ShippedDate) AS DIFERENCA_DE_DIAS
FROM [treinamento].Orders
) X
WHERE X.DIFERENCA_DE_DIAS > 20


SELECT 
	ORDERID, 
	OrderDate,
	DATEDIFF (DAY, OrderDate, GETDATE()) AS DIFERENCA_DE_DIAS,
	CASE
		WHEN DATEDIFF (DAY, OrderDate, GETDATE()) >= 10900 THEN 'PEDIDO MUITO ATRASADO'
		WHEN DATEDIFF (DAY, OrderDate, GETDATE()) BETWEEN  10700 AND 10899 THEN 'PEDIDO EM ATRASADO MODERADO'
		ELSE 'NO PRAZO'
	END AS TESTE_CASE_COM_DATEDIFF
FROM [treinamento].Orders


-- utilizando CASE + tabela derivada + função de data
select *
from
(

SELECT 
	ORDERID, 
	OrderDate,
	DATEDIFF (DAY, OrderDate, GETDATE()) as DIFERENCA_DE_DIAS,
	CASE
		WHEN DATEDIFF (DAY, OrderDate, GETDATE()) >= 10900 THEN 'PEDIDO MUITO ATRASADO'
		WHEN DATEDIFF (DAY, OrderDate, GETDATE()) BETWEEN  10700 AND 10899 THEN 'PEDIDO EM ATRASADO MODERADO'
		ELSE 'NO PRAZO'
	END AS TESTE_CASE_COM_DATEDIFF
FROM [treinamento].Orders
) AS x
where x.TESTE_CASE_COM_DATEDIFF = 'NO PRAZO'


-- utilizando CASE como filtro  + função de data
SELECT 
	ORDERID, 
	OrderDate,
	DATEDIFF (DAY, OrderDate, GETDATE()) as diferenca_1,
	CASE
		WHEN DATEDIFF (DAY, OrderDate, GETDATE()) >= 10900 THEN 'PEDIDO MUITO ATRASADO'
		WHEN DATEDIFF (DAY, OrderDate, GETDATE()) BETWEEN  10700 AND 10899 THEN 'PEDIDO EM ATRASADO MODERADO'
		ELSE 'NO PRAZO'
	END AS TESTE_CASE_COM_DATEDIFF
FROM [treinamento].Orders
where (
	CASE
		WHEN DATEDIFF (DAY, OrderDate, GETDATE()) >= 10900 THEN 'PEDIDO MUITO ATRASADO'
		WHEN DATEDIFF (DAY, OrderDate, GETDATE()) BETWEEN  10700 AND 10899 THEN 'PEDIDO EM ATRASADO MODERADO'
		ELSE 'NO PRAZO'
	END
	) = 'NO PRAZO'





Declare @DtNiver As Date, @DtAtual As Date
Set @DtNiver = '2000-02-20'
SET @DtAtual = GETDATE() 

--CALCULAR IDADE - MANEIRA 1
-- A função FLOOR () retorna o maior valor inteiro menor ou igual a um número.
-- Dividir a idade em dias pelo número de dias em um ano fornece um resultado um pouco mais preciso. O .25 deve levar em consideração os anos bissextos.
SELECT DATEDIFF(DAY, @DtNiver, @DtAtual) , (DATEDIFF(DAY, @DtNiver, @DtAtual) / 365.25) AS IDADE_DECIMAL, floor(DATEDIFF(DAY, @DtNiver, @DtAtual) / 365.25) AS SUA_IDADE

-- CALCULAR IDADE - MANEIRA 2
--remover as casas decimais para fornecer a idade em anos inteiros. Para fazer isso, podemos converter a resposta para o tipo de dados INT.
SELECT (DATEDIFF(DAY, @DtNiver, @DtAtual) / 365.25) AS IDADE_DECIMAL, cast((DATEDIFF(DAY, @DtNiver, @DtAtual) / 365.25) as int) AS SUA_IDADE

-- CALCULAR IDADE - MANEIRA 3
-- UTILIZANDO CASE + FUNÇÕES DE DATA
SELECT 
	 @DtNiver AS DT_ANIVERSARIO
	,@DtAtual AS DATA_HOJE
	,DATEDIFF(YEAR,@DtNiver,@DtAtual) - 
		(
		CASE 
			WHEN MONTH(@DtNiver) > MONTH(@DtAtual) THEN 1 
			WHEN MONTH(@DtNiver) = MONTH(@DtAtual) AND DAY(@DtNiver) > DAY(@DtAtual) THEN 1 
		Else 0 END
		) AS SUA_IDADE





--DATEADD
SELECT
getdate() AS DT_HOJE,
DATEADD(YEAR, 5, getdate() ) AS 'ANO ADICIONADO',
DATEADD(YEAR, -5, getdate() ) AS 'ANO SUBTRAIDO',
DATEADD(MONTH, 5, getdate() ) AS 'MÊS',
DATEADD(DAY, 5, getdate() ) AS 'DIA',
DATEADD(WEEK, 5, getdate() ) AS 'SEMANA',
DATEADD(HOUR, 5, getdate() ) AS 'HORA'



SELECT 
	ORDERID, 
	OrderDate,
	ShippedDate,
	DATEADD (DAY, 5 ,OrderDate) AS ADICIONANDO_5_DIAS_NO_PEDIDO,
	DATEDIFF (DAY, OrderDate, DATEADD (DAY, 5 ,ShippedDate) ) AS DIFERENCA_5_DIAS_NA_ENTREGA,
	DATEADD (DAY, DATEDIFF(DAY,OrderDate, ShippedDate), ShippedDate) as tempo_extra_de_entrega
FROM [treinamento].Orders


--DATENAME
SELECT
DATENAME(YEAR,GETDATE()) AS 'ANO', 
DATENAME(MONTH,GETDATE()) AS 'MES',
DATENAME(WEEKDAY,GETDATE()) AS 'DIA DA SEMANA'


--DATENAME - COM NOMES EM PORTUGUÊS - UTILIZAR O SET LANGUAGE - ELE MUDA O IDIOMA DE DATAS E ALGUNS TEXTOS DO CONTEXTO DA QUERY EM QUESTÃO
set language 'Brazilian'

SELECT
DATENAME(YEAR,GETDATE()) AS 'ANO', 
DATENAME(MONTH,GETDATE()) AS 'MES',
DATENAME(WEEKDAY,GETDATE()) AS 'DIA DA SEMANA'


select 
	orderDate,
	datename(month,orderDate) AS NOME_MES,
	DATENAME(weekday,datepart(weekday,orderDate)) AS NOME_DIA_SEMANA
FROM [treinamento].Orders

-- VOLTANDO O IDIOMA DO CONTEXTO DA QUERY PARA O IDIOMA ORIGINAL 
set language 'English'

-- COMO AS PESSOAS GERAMENTE CONSTROEM O NOME DE DATAS
SELECT
CASE datepart(weekday,GETDATE())
	WHEN 1 THEN 'DOMINGO'
	WHEN 2 THEN 'SEGUNDA'
	WHEN 3 THEN 'TERÇA'
	WHEN 4 THEN 'QUARTA'
	WHEN 5 THEN 'QUINTA'
	WHEN 6 THEN 'SEXTA'
	WHEN 7 THEN 'SABADO'
END AS NOME_DIA_SEMANA

,CASE MONTH (GETDATE())
	WHEN 1 THEN 'JANEIRO'
	WHEN 2 THEN 'FEVEIRO'
	WHEN 3 THEN 'MARÇO'
	WHEN 4 THEN 'ABRIL'
	WHEN 5 THEN 'MAIO'
	WHEN 6 THEN 'JUNHO'
	WHEN 7 THEN 'JULHO'
	WHEN 8 THEN 'AGOSTO'
	WHEN 9 THEN 'SETEMBRO'
	WHEN 10 THEN 'OUTUBRO'
	WHEN 11 THEN 'NOVEMBRO'
	ELSE 'DEZEMBRO'
END AS NOME_MES

-- SUGESTÃO PARA FILTRAR SOMENTE DATAS SEM A HORA
SELECT *
FROM
(
SELECT GETDATE() AS DT_COMPLETA, CAST(GETDATE() AS DATE) AS SOMENTE_DATA
UNION
SELECT GETDATE() + 1 AS DT_COMPLETA, CAST(DATEADD(DAY, 1, GETDATE()) AS DATE) AS SOMENTE_DATA
) AS X
--WHERE CAST(DT_COMPLETA AS DATE) = '20211127' -- YYYY-MM-DD OU PADRAO ISO(112) YYYYMMDD 
WHERE X.SOMENTE_DATA = '2022-02-20'



-- year/ month / day / eomonth
SELECT
GETDATE() DATA_SISTEMA,
YEAR(GETDATE() ) AS 'ANO',
MONTH(GETDATE() ) AS 'MÊS',
DAY(GETDATE() ) AS 'DIA',
EOMONTH(GETDATE()) AS 'ULTIMO DIA DO MES',
EOMONTH(GETDATE(), -1) AS 'decrementando 1 mes na data atual - ULTIMO DIA DO MES',
EOMONTH(GETDATE(), 1) AS 'incrementando 1 mes na data - ULTIMO DIA DO MES',
DAY(EOMONTH(GETDATE())) AS 'extraindo o dia do ultimo dia do mes da data -- utilizando eomonth e day'


--ISDATE
SELECT ISDATE(GETDATE()) as TEST_DATE_VALID -- RETONAR 1 SE A DATA FOR VALIDA

SELECT ISDATE('2018-13-01') as TEST_DATE_INVALID -- RETORNAR 0 SE A DATA FOR INVALIDO




/*** FUNÇÕES DE AGREGAÇÃO ***/

CREATE TABLE [treinamento].PRODUTO(
CODIGO INT PRIMARY KEY IDENTITY,
CATEGORIA VARCHAR(100),
TIPO VARCHAR(100),
NOME VARCHAR(100),
PRECO MONEY,
QTD_ESTOQUE INT)

INSERT INTO [treinamento].PRODUTO(CATEGORIA,TIPO,NOME,PRECO,QTD_ESTOQUE)
VALUES ('COZINHA',	'ARMARIO',	'ARMARIO MOGNO A1',	240.5,	10),
('COZINHA',	'ELETRODOMESTICO',	'GELADEIRA BRASTEMP 400 L',	1500.50,	5),
('INFORMATICA',	'SMARTPHONE',	'LG K10 POWER',	750.00, 50),
('INFORMATICA',	'NOTEBOOK',	'ACER GAMER I7',	7500.00,	3),
('INFORMATICA',	'NOTEBOOK',	'DELL I7 16 GB',	5800.00,	1),
('AUTOMOTIVO',	'PNEU',	'FIRESTON ARO 14',	199.99,	100),
('AUTOMOTIVO',	'PNEU',	'PIRELI ARO 16',	339.99,	100),
('AUTOMOTIVO',	'PNEU',	'MICHELAN ARO 15',	449.99,	50),
('INFORMATICA',	'SMARTPHONE',	'IOS 10'	,7000,	50),
('INFORMATICA',	'CONSOLE',	'PS 4',	2000,	20),
('INFORMATICA',	'CONSOLE',	'XBOX',	2200,	60),
('COZINHA',	'ELETRODOMESTICO',	'FOGÃO 8 BOCAS BRASTEMP',	1500,	240),
('INFORMATICA', 	'ULTRABOOK',	'SAMSUNG I7 8GB',	3571,	NULL),
('INFORMATICA', 	'ULTRABOOK',	'DELL I9 32 GB',	NULL,	NULL)



select * from TREINAMENTO.PRODUTO

--COUNT, COUNT(*), COUNT(<NUMERO 0 OU 1 >), COUNT_BIG

SELECT 
 COUNT(*) AS COUNT_ASTERISCO-- PODE-SE UTILIZAR, MAS NÃO É RECOMENDADO
,COUNT(0) AS COUNT_ZERO -- O ZERO SIGNIFICA QUE VOCÊ PODE CONTAR TUDO DA TABELA, RECOMENDADO USAR O COUNT(0) AO INVES DO COUNT(*) 
,COUNT (CATEGORIA) AS COUNT_POR_CATEGORIA -- IGNORA VALORES NULOS
,COUNT (QTD_ESTOQUE) AS COUNT_POR_ESTOQUE-- IGNORA VALORES NULOS
,COUNT (ISNULL(QTD_ESTOQUE,0)) AS COUNT_POR_ESTOQUE_TRATANDO_NULOS -- TRATANDO VALORES NULOS E FAZENDO O COUNT
,COUNT_BIG(CATEGORIA) AS COUNT_BIG_POR_CATEGORIA-- CONTA VALORES ATÉ BIGINT((-9,223,372,036,854,775,808 ATÉ 9,223,372,036,854,775,807)) : UTILIZAR QUANDO O VALOR ULTRAPASSAR O RANGE DO INT (-2,147,483,648 to 2,147,483,647)
FROM [treinamento].PRODUTO


-- SUM

select * from TREINAMENTO.PRODUTO

SELECT 
 SUM(PRECO) AS SOMA_PRECO,
 SUM(QTD_ESTOQUE) AS SOMA_ESTOQUE ,
 SUM(ISNULL(QTD_ESTOQUE,1)) AS SOMA_ESTOQUE_TRATANDO_NULOS
FROM [treinamento].PRODUTO


-- AVG
select * from TREINAMENTO.PRODUTO

SELECT 
 AVG(PRECO) AS MEDIA_PRECO, -- SOMA TUDO E DIVIDE PELA QUANTIDADE ENCONTRADA DA SOMA = SOMA OS PREÇOS E DIVIDE POR 13
 AVG(QTD_ESTOQUE) AS MEDIA_ESTOQUE,
 AVG(ISNULL(QTD_ESTOQUE,0))  AS MEDIA_ESTOQUE_TRATANDO_NULOS -- SOMA TUDO E DIVIDE POR 14
FROM [treinamento].PRODUTO




-- MAX e MIN

select * from TREINAMENTO.PRODUTO

SELECT 
 MAX(PRECO) AS MAIOR_PRECO,
 MAX(QTD_ESTOQUE)  AS MAIOR_ESTOQUE,
 MIN(PRECO)  AS MENOR_PRECO,
 MIN(QTD_ESTOQUE)  AS MENOR_ESTOQUE,
 MIN(ISNULL(QTD_ESTOQUE,0))  AS MENOR_ESTOQUE_TRATANDO_NULOS
FROM [treinamento].PRODUTO


-- SUBQUERY (OU SUBCONSULTA): UMA CONSULTA USADA DENTRO DE OUTRA CONSULTA
-- A CONSULTA INTERNA É EXECUTADA PRIMEIRO DO QUE A CONSULTA EXTERNA
-- a subconsulta só pode retornar o valor de 1 coluna


--subquery não correlacionada - a consulta interna não tem vinculo de chave com a consulta externa
SELECT *
FROM [treinamento].PRODUTO
WHERE PRECO >= (
				SELECT MAX(PRECO) 
				FROM [treinamento].PRODUTO
				)

SELECT *
FROM [treinamento].PRODUTO
WHERE PRECO >= (
				SELECT AVG(PRECO) 
				FROM [treinamento].PRODUTO
				)

SELECT *
FROM [treinamento].PRODUTO
WHERE PRECO between (
				SELECT min(PRECO) 
				FROM [treinamento].PRODUTO
				)
			and
			(
			SELECT max(PRECO) 
			FROM [treinamento].PRODUTO
			WHERE CATEGORIA = 'AUTOMOTIVO'
			)





--subquery correlacionada - a consulta interna tem vinculo de chave com a consulta externa
SELECT*
FROM [treinamento].Orders AS O
order by CustomerID


SELECT
	OrderID, OrderDate, *
FROM [treinamento].Orders AS O
WHERE CustomerID = 'ALFKI'
order by CustomerID

SELECT
	CustomerID, MAX(OrderDate)
FROM [treinamento].Orders AS O
WHERE CustomerID = 'ALFKI'
GROUP BY CustomerID



-- traga o ultimo pedido (o pedido com maior data) de cada cliente
SELECT O.OrderDate, O.*
FROM [treinamento].Orders AS O
WHERE O.OrderDate = (
					SELECT MAX(B.OrderDate) 
					FROM [treinamento].Orders AS B
					WHERE B.CustomerID = O.CustomerID
					)
ORDER BY CustomerID



--GROUP BY 
-- contar a quantidade de produtos por categoria (campo de saida)

select *
FROM [treinamento].PRODUTO

SELECT 
	CATEGORIA
	,COUNT(0) AS QTD_PRD
FROM [treinamento].PRODUTO
GROUP BY CATEGORIA

--contar a quantidade de produtos por categoria e tipo
SELECT 
	CATEGORIA
	,TIPO
	,COUNT(0)
FROM [treinamento].PRODUTO
GROUP BY CATEGORIA, TIPO
ORDER BY CATEGORIA



--contar a quantidade de pedidos por cliente
SELECT CustomerID, COUNT(OrderID) AS QTD_PEDIDOS_CLIENTES
FROM [treinamento].Orders
GROUP BY CustomerID
ORDER BY QTD_PEDIDOS_CLIENTES DESC

SELECT 
	CustomerID
	,EmployeeID
	,OrderDate
	, COUNT(OrderID) AS QTD_PEDIDOS_CLIENTES
FROM [treinamento].Orders
GROUP BY CustomerID, EmployeeID, OrderDate
ORDER BY CustomerID DESC

SELECT *
FROM [treinamento].Orders
WHERE CustomerID = 'SAVEA'



--media do frete por navio_pais
SELECT ShipCountry, AVG (Freight) AS MEDIA_FRETE 
FROM [treinamento].Orders
GROUP BY ShipCountry
ORDER BY MEDIA_FRETE desc

--contar quais produtos foram mais vendidos
SELECT
	 P.ProductID
	,P.ProductName
	,COUNT(OD.OrderID) AS NUMERO_DE_PEDIDOS

FROM [treinamento].Products AS P
INNER JOIN [treinamento].[OrderDetails] AS OD
	ON P.ProductID = OD.ProductID
GROUP BY P.ProductID
		,P.ProductName
ORDER BY NUMERO_DE_PEDIDOS



--somatorio do total de vendas por pedido
SELECT *,
	(OD.UnitPrice * OD.Quantity) - od.Discount as sub_total
FROM  [treinamento].[OrderDetails] AS OD
order by od.OrderID

SELECT
	 OD.OrderID
	,SUM((OD.UnitPrice * OD.Quantity) - od.Discount)  TOTAL_VENDA
FROM  [treinamento].[OrderDetails] AS OD
GROUP BY  OD.OrderID
ORDER BY OD.OrderID asc


--HAVING
--somatorio do total de vendas por pedido, filtrando com o having quando o somatório for menor que 3000

SELECT
	 OD.OrderID
	,SUM((OD.UnitPrice * OD.Quantity) - od.Discount) AS TOTAL_VENDA
	
FROM  [treinamento].[OrderDetails] AS OD
GROUP BY  OD.OrderID
HAVING SUM((OD.UnitPrice * OD.Quantity) - od.Discount) > 2000
ORDER BY TOTAL_VENDA ASC



--contar A quantidade de pedidos por país de entrega, filtrando quando a quantidade de pedidos for maior ou igual a 100
SELECT 
	ShipCountry,
	COUNT(0) AS QTD_PEDIDOS
FROM [treinamento]. Orders
GROUP BY ShipCountry
HAVING COUNT(0) >= 100
ORDER BY QTD_PEDIDOS

SELECT 
	ShipCity,
	COUNT(0) AS QTD_PEDIDOS
FROM [treinamento]. Orders
where ShipCountry = 'Canada'
GROUP BY ShipCity
HAVING COUNT(0) >= 20
ORDER BY QTD_PEDIDOS

/* 
ALTERNATIVA DE FILTRO DE AGRUPAMENTO SEM O HAVING 
UTILIZANDO TABELA DERIVADO (SUBQUERY DE TABELA)
*/
select *
from (
			SELECT 
				ShipCity AS CIDADE_ENTREGA,
				COUNT(0) AS QTD_PEDIDOS
			FROM [treinamento]. Orders
			where ShipCountry = 'Canada'
			GROUP BY ShipCity
) as Y
where y.QTD_PEDIDOS >= 20
ORDER BY QTD_PEDIDOS


-- ANALISANDO REGISTROS COM CAMPO(S) COM VALORES DUPLICADOS
DECLARE @TABELA_DUPLICADA TABLE 
(
ID INT,
NOME VARCHAR(10),
DT1 DATE,
DT2 DATE
)

INSERT INTO @TABELA_DUPLICADA (ID, NOME,DT1,DT2)
VALUES (1, 'ANA','2021-01-01','2021-03-03')
	  ,(1, 'ERINALDO','2021-01-01','2021-03-04')
	  ,(2,'SERGIO','2021-01-01','2021-03-05')
	  ,(3,'LORENA','2021-01-01','2021-03-06')


SELECT *
FROM @TABELA_DUPLICADA

SELECT ID, COUNT(ID) AS QTD_REPETICOES
FROM @TABELA_DUPLICADA
GROUP BY ID
HAVING COUNT(ID) >  1


/*
contar a quantidade de pedidos por cliente, 
filtrando os clientes que tem menos ou igual a 10 pedidos
*/

select CustomerID, count(OrderID)
from  [treinamento]. Orders
group by CustomerID
having count(OrderID) <= 10



/************** PROGRAMAÇÃO T-SQL **************/

--CRIANDO UMA VIEW
CREATE OR ALTER VIEW [treinamento].uVW_Clientes_Canada
as
select 
	CustomerID
	,CompanyName
	,ContactName
	,City
	,Country
from [treinamento].Customers
where Country  = 'CANADA'


-- CONSULTANDO A VIEW
select * 
from [treinamento].uVW_Clientes_Canada
ORDER BY CustomerID

select * 
from [treinamento].uVW_Clientes_Canada
WHERE CITY = 'Vancouver'

--VER O CÓDIGO DA VIEW
sp_helptext '[treinamento].uVW_Clientes_Canada' 



-- CRIANDO UMA VIEW COM O CÓDIGO ENCRIPTADO
CREATE OR ALTER VIEW [treinamento].uVW_Clientes
--WITH ENCRYPTION 
/*
OBJETIVO: VIEW DE CLIENTES DO CANADA
DATA DE CRIAÇÃO: 19/02/2022
AUTOR: LUIZ
DATA ALTERAÇÃO: 21/02/2022
ALTERADO POR: LOGAN
MOTIVO ALTERAÇÃO: PRECISEI INCLUIR A COLUNA X
*/

as
select 
  CustomerID AS COD_CLIENTE
, CompanyName AS NOME_EMPRESA
, ContactName AS NOME_CONTATO
, City AS CIDADE
, Country AS PAIS
from [treinamento].Customers
WHERE Country = 'USA'


--TENTANDO VER O CÓDIGO DA VIEW ENCRIPTADA
sp_helptext '[treinamento].uVW_Clientes'


-- CONSULTANDO A VIEW
select * from [treinamento].uVW_Clientes
