/*********** identity ***********/
-- 1: criar uma tabela com campo identity
create table treinamento.tb_identity
(
id smallint identity, 
letra char(1)
)

--2: inserir 3 linhas
insert into treinamento.tb_identity (letra)
values ('A'), ('B'), ('C')

--3: consultando tabela
select * from treinamento.tb_identity

/*
4: simulando um erro, vamos passar um valor maior que a letra, 
ele alocará o valor do incremento (valor 4) em memoria
ERRO APRESENTADO: DATA TRUNCATION - O VALOR INFORMADO PARA A COLUNA 
É MAIOR DO QUE O TAMANHO DEFINIDO NA TABELA. 
*/
insert into treinamento.tb_identity (letra)
values ('AA')

--5: inserindo um novo registro
insert into treinamento.tb_identity (letra)
values ('D')

select * from treinamento.tb_identity

--6: corrigir - desabilitar o identity
set identity_insert treinamento.tb_identity on

--7: inserir o valor com a numeração correta
insert into treinamento.tb_identity (id,letra)
values (4, 'E')

--8: Habilitar o identity
set identity_insert treinamento.tb_identity off

--9: inserindo um novo registro
insert into treinamento.tb_identity (letra)
values ('H')

select * from treinamento.tb_identity

--10: apagando registro 6
delete from treinamento.tb_identity
where id = 6

select * from treinamento.tb_identity

--11: inserindo um novo registro
insert into treinamento.tb_identity (letra)
values ('L')

select * from treinamento.tb_identity

--12: Truncar a tabela para reiniciar a coluna identity, re-executar todos os processos menos o do erro
truncate table treinamento.tb_identity

select * from treinamento.tb_identity








/*********** primary key ***********/
--1: criar tabela com PK
create table treinamento.tb_pk (
id smallint primary key, 
letra char(1)
)

--2: inserir registros
insert into treinamento.tb_pk (id, letra)
values (1, 'A'), (2,'G')

--2.1: inseri registro
insert into treinamento.tb_pk (id, letra)
values (3, 'B')

--3: consultar tabela
select * from treinamento.tb_pk

/*
4: inserir novo registro com a mesma chave
ERRO APRESENTADO: NÃO É POSSÍVEL INSERIR UM NOVO VALOR 
COM UMA CHAVE PRIMARIA JÁ EXISTENTE. A CHAVE PRIMARIA DEVE SER UNICA
*/
insert into treinamento.tb_pk (id, letra)
values (3, 'F')

--VFC (MOSTRAR CONSTRAINT LÁ NO EXPLORER DA TABELA e COM ALT+F1)
--VFC REGRA É CLARA, NÃO POSSO INSERIR NO CAMPO O MESMO VALOR DUAS VEZES
-- NUMA EMPRESA COLOCAR MESMA MATRICULA PARA DOIS FUNCIONARIOS 

-- QUAL A SOLUÇÃO?
-- solução passar um novo valor de chave
insert into treinamento.tb_pk (id, letra)
values (4, 'F')


----5: criar uma tabela com chave primaria identity
create table treinamento.tb_pk2
(
id smallint constraint pk_tb_2 primary key identity,
letra char(1)
)

--6: inserir registros
insert into treinamento.tb_pk2 (letra)
values ('A'), ('G'), ('T'), ('R'), ('X')

--7: consultar tabela
select * from treinamento.tb_pk2


----8: criar uma tabela com chave primaria composta
-- VFC Quais campos identifica o registro como unico? a combinação de letra + ID
create table treinamento.tb_pk3
(
id smallint,
letra char(1),
nome varchar(20),
constraint pk_composta primary key (id, letra)
)

--9: inserir registros
-- Poxa Vinicius mas você tá passando o 1 tres vezes, nao importa! A chave PK é combinação dos dois
-- Se a letra não se repetir não tem problema!
insert into treinamento.tb_pk3 (id, letra, nome)
values (1,'A','Pedro'), (1,'B','Ana'), (1,'C','Maria')

--10: consultar tabela (Veja que aceita o mesmo ID, porém! Com letra diferente)
select * from treinamento.tb_pk3

--10.1: inserir registro
insert into treinamento.tb_pk3 (id, letra, nome)
values (1,'D','Marcos')

/*
11: Simular inclusão de um novo registro com a chave composta 
igual a um registro existente

ERRO APRESENTADO: NÃO É POSSÍVEL INSERIR A MESMA COMBINAÇÃO DE CHAVES 
PRIMARIAS PARA O MESMO REGISTRO.

*/

-- Aqui vai dar erro pois estamos violando o '1' - 'D' das chaves PK.
-- Erro: Cannot insert duplicate key in object 'treinamento.tb_pk3'. The duplicate key value is (1, D).
insert into treinamento.tb_pk3 (id, letra, nome)
values (1, 'D', 'Vinicius')

-- 12: solucao mudar valor da chave
insert into treinamento.tb_pk3 (id, letra, nome)
values (1,'E','Marcos')










/*********** foreing key ***********/
/* 1: simular modelagem - Dono(1) x (N)Animal - Animal(N) x (1)Raca
- 1 dono pode ter varios animais, 1 animal pode ter 1 raca, e 1 raca em varios animais
-VFC (Primeiro criar tabela que vai ceder chave primeiro, 
se eu tentar criar animal primeiro vai da erro)
- Mostrar no DB DIAGRAM*/

--2: criar tabela de raça
create table treinamento.tb_raca(
raca_cod smallint primary key identity,
raca_nome varchar(20)
)

--3: criar tabela de dono
create table treinamento.tb_dono(
dono_cod smallint primary key identity,
dono_nome varchar(20)
)

--4: criar tabela de animal
create table treinamento.tb_animal(
animal_cod smallint primary key identity,
animal_nome varchar(15),
animal_codRaca smallint foreign key references treinamento.tb_raca (raca_cod),
animal_codDono smallint constraint fk_dono foreign key references treinamento.tb_dono(dono_cod)
)
-- VFC (Se for uma chave estrangeira composta)
animal_codDono smallint foreign key references treinamento.tb_dono(dono_cod1, dono_cod2)

--5: inserir tabela raca
insert into treinamento.tb_raca(raca_nome)
values ('Pitbull'), ('Pinscher')

--5.1: consultando a raça
select * from treinamento.tb_raca

--6: inserir tabela dono
insert into treinamento.tb_dono(dono_nome)
values ('Lorena'), ('Luiz')

--6.1: consultando o dono
select * from treinamento.tb_dono

--VFC(E agora como faço para inserir dados dentro de uma tabela que tem FK?)
--VFC(Lembrando, a tabela animal vai ter o cód animal, FK do dono, e FK da Raça)
--7: inserir tabela animal
insert into treinamento.tb_animal(animal_nome, animal_codDono, animal_codRaca)
values ('Zeus',1,1), ('Atena', 2,2)

/*
8 : inserir na tabela animal uma raça que não existe
ERRO APRESENTADO: NÃO É POSSÍVEL INSERIR UMA RAÇA DE ANIMAL 
QUE NÃO EXISTE NA TABELA DE ORIGEM, OU SEJA, A FK EXIGE QUE O 
REGISTRO EXISTA NA TABELA DE REFERENCIA
*/
insert into treinamento.tb_animal(animal_nome, animal_codDono, animal_codRaca)
values ('Gaya',1,3)

--9: solução: inserindo uma nova raça na tabela Raça
insert into treinamento.tb_raca(raca_nome)
values ('Husky Siberiano')

--10 : re-inserir registro na tabela animal 
insert into treinamento.tb_animal(animal_nome, animal_codDono, animal_codRaca)
values ('Gaya',1,3)

--11: consultando tabela animal
select *  from treinamento.tb_animal

/*
12: Tentando deletar um dono vinculado a um animal -- erro de integridade referencial
Erro de fk - integridade referencial
ERRO APRESENTADO: NÃO É POSSÍVEL EXCLUIR UM REGISTRO QUE ESTA SENDO UTILIZADO COMO REFERENCIA EM OUTRA TABELA
*/
delete from TREINAMENTO.tb_dono
where dono_cod = 2

--VFC(EXEMPLO COMPRAS SITE AMERICANAS, MONTE DE COMPRAS tabela CLIENTES X  PEDIDOS, COMPROU POR 5 ANOS)
-- Tem pedidos que estão vinculados a fulano, então não pode excluir e ficaria venda avulsa.







/*********** NOT NULL ***********/
--é obrigátorio o preenchimento do campo? se sim NOT NULL, se não NULL

--1: criando tabela 
create table treinamento.tb_notNull(
id smallint primary key identity,
letra_1 char(1) not null,
letra_2 char(1) null
)

--2: inserindo registros - as duas colunas preenchidas
insert into treinamento.tb_notNull(letra_1,letra_2)
values ('A', 'B')

--3: inserindo registros - coluna 1 preenchida e a coluna 2 não preenchida
insert into treinamento.tb_notNull(letra_1,letra_2)
values ('C', null)
--OU
insert into treinamento.tb_notNull(letra_1)
values ('D')

/*
4: inserindo registros - coluna 1 não preenchida e a coluna 2 preenchida
ERRO APRESENTADO: NÃO É POSSÍVEL INSERIR UM VALOR NULO EM UMA 
COLUNA QUE POSSUI A CONSTRAINT NOT NULL
*/
insert into treinamento.tb_notNull(letra_1,letra_2)
values (null, 'E')
-- Quando colocamos NOT null o SQL obriga a colocar um valor, tipo cadastro de um aluno e não preencher nome
-- 
--OU
insert into treinamento.tb_notNull(letra_2)
values ('F')

--VFC(Obrigatorio preencher, por exemplo cadastro de uma pessoa não preencher nome)
--VFC(Site de cadastro que tem * para preenchimento obrigatorio)

--4.1: inserido um valor em branco na coluna 1
-- Tentar inserir com string nulo '' Vazio é diferente de nulo
insert into treinamento.tb_notNull(letra_1,letra_2)
values ('', 'E')


-- Tentar inserir com palavra'NULL') 
-- Pegadinha, nulo é diferente de nulo - Ele não deixa por causa do char(1)
insert into treinamento.tb_notNull(letra_1,letra_2)
values ('', 'null')

--5: consultar dados da da tabela
select * from treinamento.tb_notNull








/************ DEFAULT ***********/
--1: criar tabela
create table treinamento.tb_default
(
id smallint primary key identity,
letra char(1) default ('A'),
dt date constraint df_data default (getdate()) not null
)
-- QUando não passar valor para as colunas com default, o sql vai assumir os valores default
--VFC(Explicar o getdate() o que é? Função que traz hora do server, CURRENT_TIMESTAMP > SQL PADRÃO)
select getdate()
select CURRENT_TIMESTAMP
select SYSDATETIME()

--2: inserir registro na letra e deixar a data default
insert into treinamento.tb_default (letra)
values ('K')

--3: inserir registro na data e deixar letra default
insert into treinamento.tb_default (dt)
values ('2023-05-01')

--4: consultando tabela
select * from treinamento.tb_default

--5: tabela com coluna de data de insert da linha
-- Comum quando fazemos ingestão de dados, preenche com a data do sistema quando um registro entrou tabela
create table treinamento.tb_default2
(
id char(4),
nome varchar(20) ,
valor smallmoney,
dtInsert date constraint df_DtInsert default (getdate()) not null
)

--6: inserindo um registro não informando a data de insert
insert into treinamento.tb_default2 (id, nome,valor)
values ('V001', 'Ana', 10)

--6.1: inserindo a mesma venda em outro dia
insert into treinamento.tb_default2 (id, nome,valor,dtInsert)
values ('V001', 'Ana', 10, '2023-11-01')

-->> Correlação com exemplo do pedido EXCEL (modelagem), colunas (PEDIDO/STATUS/DT_INSERT só muda data)
-->> data serve para controle no merge também, se alguma coisa muda ele atualiz
-->> Ag pagto/ Pg realizado/ Em separação/ Enviado para transp/ Em entrega/ Entregue

-->> FAZER TESTE (VALOR NULO COMO TEXTO)
insert into treinamento.tb_default2 (id, nome, valor, dtInsert)
values ('V001', 'Null', 10, '2021-07-17') 

insert into treinamento.tb_default2 (id, nome, valor, dtInsert)
values ('V001', null, 10, '2021-07-18')

--7: consultando tabela
select * from treinamento.tb_default2







-- VFC (Para finalizar temos o check)

/************ CHECK ***********/
--1: criar tabela
create table treinamento.tb_check
(
id smallint primary key identity,
letra char(1) check (letra in ('A', 'B', 'C')),
valor smallmoney constraint chk_valor check (valor > 0)
)

--2: inserir os registros - com os dois valores corretos
-- Caminho feliz, inserir de acordo com o que está na checagem
insert into treinamento.tb_check (letra, valor)
values ('A', 10)

/*
3: coluna 1 valor errado, coluna 2 valor certo
ERRO APRESENTADO: NÃO É POSSÍVEL INSERIR UM VALOR DIFERENTE 
DO QUE FOI DEFINIDO PARA A COLUNA QUE CONTÉM A CONSTRAINT CHECK
*/
-- Vamos começar estourar erro:
insert into treinamento.tb_check (letra, valor)
values ('D', 10)

/*
4: coluna 1 valor certo, coluna 2 valor erro
ERRO APRESENTADO: NÃO É POSSÍVEL INSERIR UM VALOR 
DIFERENTE DO QUE FOI DEFINIDO PARA A COLUNA QUE CONTÉM A CONSTRAINT CHECK
*/
insert into treinamento.tb_check (letra, valor)
values ('B', 0)

-- Teste se é case sensitive a letra
insert into treinamento.tb_check (letra, valor)
values ('a', 1)

--5: consultando tabela
select * from treinamento.tb_check

-->> mostar exemplo medland
-->> Quem deveria fazer um check em um coisa de produção, quem deve tratar é o frontend,
-->> Se não entra requisião da aplicação para o banco validar e depois retornar o erro para app







/************ desenvolvendo consultas ***********/
--1: ordenando ascendente (menor para maior) -- ASC (IMPLICITO)
select *
from treinamento.Customers
order by city ASC
-->> Se eu não passar nada ele leva em consideração a ordem de inserção dos dados
-->> Mas SP aparece 4x ? a coluna tem mais registros.

--2: ordenando descendente (maior para o menor)
select *
from treinamento.Customers
order by city desc
-->> Z para A

--2.1: ordenando por data
select *
from treinamento.Orders
order by OrderDate desc

--2.2: ordenando valores nulos
-- E seu botar orderby em uma coluna que tenha nuloS?
select *
from treinamento.Orders
order by ShipRegion asc
-->> MOSTRAR COMO DESCENDENTE QUE OS NULOS VEM FINAL
------------------------------------------------------------------------------
--3: ordenando por mais de uma coluna - pais ascendente e cidade descendente 
select *
from treinamento.Customers
order by Country asc, city desc
------------------------------------------------------------------------------
-->> Eu poderia chegar na cidade
-- E tambem ordernar pelo endereço, dando um wheree no brasil -- Mostrar resultado com e sem addres

select *
from treinamento.Customers
where Country = 'Brazil'
order by Country asc, city desc , Address asc

------------------------------------------------------------------------------
--4: valor igual a 18, ou seja, a coluna tem que ser 18
select *
from treinamento.Products
where UnitPrice = 18
-->> MOSTRAR COM VALOR 18.99 (NAO RETORNA É PQ NÃO TEM NADA NA TABELA)
------------------------------------------------------------------------------
-- Também posso usar com nomes
select *
from treinamento.Products
where ProductName = 'Filo mix'

--5: valor diferente a 18, ou seja, a coluna tem que ser diferente de 18 != OU <>
select *
from treinamento.Products
where UnitPrice != 18

select *
from treinamento.Products
where UnitPrice <> 18

--6: valor maior que  50
select *
from treinamento.Products
where UnitPrice > 50

--6.1: valor MENOR que  50
select *
from treinamento.Products
where UnitPrice < 50

--7: valor maior ou igual a 81
select *
from treinamento.Products
where UnitPrice >= 81

--7.1: valor menor ou igual a 9
select *
from treinamento.Products
where UnitPrice <= 9

--8: data maior ou igual maior a '1960-01-27'
select *
from treinamento.Employees
where BirthDate >= '1960-01-27'


--10: AND todas as condições tem que ser verdadeiras
select *
from treinamento.Customers
where Country = 'Brazil'
 and city = 'São Paulo'
 and Region = 'SP'
 and PostalCode = '05634-039'



--11: OR a condição pode ser verdadeira ou falsa
select *
from treinamento.Customers
where Country = 'Brazil'
 or city = 'Buenos Aires'
 or Region = 'BC' --<< CANADA
------------------------------------------------------------------------------
-->> Vinicius, posso utilizar o AND e OR junto? Pode
select *
from treinamento.Customers
where Country = 'Brazil' and (Region is null or Region = 'SP') << ISOLANDO
------------------------------------------------------------------------------

--12: NOT inverso da condição
select *
from treinamento.Customers
where NOT Country = 'Brazil'

--13: calculos matematicos
select *, 
	(UnitPrice * Quantity) as subtotal, 
	((UnitPrice * Quantity)/100) as divisao,
	((UnitPrice * Quantity) - Discount) as subtotal_com_disconto
from treinamento.OrderDetails

--14: is null
select *
from treinamento.Orders
where ShipRegion is null

--15: is not null
select *
from treinamento.Orders
where ShipRegion is not null

--16: is not null para a region e is null para shipostalcode
select *
from treinamento.Orders
where ShipRegion is not null
and ShipPostalCode is null

--17: IN lista de valores, ele vai verificar se um dos valores passados existe na coluna
select *
from treinamento.Orders
where ShipCity in ('Buenos Aires', 'Belo Horizonte', 'Montréal')

--18: IN lista de valores, ele vai verificar se um dos valores passados existe na coluna
select *
from treinamento.Orders
where EmployeeID in (560, 1, 2, 450)

/*
19: NOT IN inverso da lista de valores, ele vai verificar se um dos 
valores passados existe na coluna
*/
select *
from treinamento.Orders
where EmployeeID not in (55555,'1',2, 4568247)


--20: IN com resultado de subconsulta
select *
from treinamento.Orders
where ShipCity in (
	select distinct City
	from treinamento.Customers
	where Country = 'Brazil'
	and Region = 'RJ'
)


--21: BETWEEN valores entre X e Y - valores numericos
select *
from treinamento.Orders
where Freight between 5 and 10.5

select *
from treinamento.Orders
where Freight >= 10 and Freight <= 50


--22: BETWEEN valores entre X e Y - valores de data
select *
from treinamento.Orders
where OrderDate between '1991-05-28' and '1991-06-30'


--erro data maior primeiro que a data menor
select *
from treinamento.Orders
where OrderDate between '1991-06-30' and '1991-05-28' 

--23:  NOT BETWEEN inverso dos valores entre X e Y - valores de data
select *
from treinamento.Orders
where OrderDate not between '1991-05-28' and '1991-06-30'


--24:  like busca de texto personalizada 
select *
from treinamento.Orders
where ShipAddress like '43 rue St. Laurent'

-- mesma coisa da consulta abaixo
select *
from treinamento.Orders
where ShipAddress = '43 rue St. Laurent'

--25:  like busca de texto personalizada - palavra% - todo mundo que começa com a palavra
select *
from treinamento.Orders
where ShipAddress like 'rue%'

select *
from treinamento.Orders
where ShipAddress like 'T%'

select *
from treinamento.Orders
where ShipAddress like 'C%'

--Expressão regular (Palavras que começam com A B ou C)
select *
from treinamento.Orders
where ShipAddress like '[abc]%'

--26:  like busca de texto personalizada - %palavra - todo mundo que termina com a palavra
select *
from treinamento.Orders
where ShipAddress like '%5'

/*
27:  like busca de texto personalizada - %palavra% - todas mundo que contem 
a palavra no inicio, meio e final do texto
*/
select *
from treinamento.Orders
where ShipAddress like '%St.%'
order by ShipAddress

select *
from treinamento.Orders
where ShipAddress like '%rue%'

--28: ALIAS apelidos para as colunas e tabelas - alias de coluna

	select  
		CustomerID as 'Id Cliente'-- maneira 1 com a palavra AS
		,Cidade = City -- maneira 2 - apelido = coluna
		,Country [País] -- maneira 3 - sem o AS
		,Region as [Região Cliente]
	from treinamento.Customers


--29: ALIAS apelidos para as colunas e tabelas - alias de tabela

select  
	CustomerID as 'Id Cliente'-- maneira 1 com a palavra AS
	,Cidade = City -- maneira 2 - apelido = coluna
	,Country [País] -- maneira 3 - sem o AS
	,Region as 'Região'
	,tbcli.City
	,tbcli.CompanyName
from treinamento.Customers as tbcli



--Ambiguous column name 'City'.
-- Primeiro fazer a query só com City
select 
	--city,
	tbemp.City as 'Cidade Funcionario',
	tbcli.City as 'Cidade Cliente'
from treinamento.Employees as tbemp, treinamento.Customers as tbcli



/*
Utilizando alias (apelido da coluna) no order by -- O order by é a ultima 
clausula da consulta SQL a ser executada
*/
select 
	tbemp.City as 'Cidade Funcionario',
	tbcli.City as 'Cidade Cliente'
from treinamento.Employees as tbemp, treinamento.Customers as tbcli
order by [Cidade Funcionario]


--30: CASE/IIF É SEMELHANTE AO IF ELSE
SELECT
	CASE Region -- MANEIRA 1 COLUNA NO CASE
		WHEN 'SP' THEN 'SUDESTE - BRAZIL'
		WHEN 'RJ' THEN 'SUDESTE - BRAZIL'
		WHEN 'RS' THEN 'SUL - BRAZIL'
		ELSE 'OUTRA REGIÃO'
	END AS ANALISE_CASE_01
		
,	CASE -- MANEIRA 2 A LOGICA VAI NO WHEN
		WHEN Country = 'BRAZIL' AND Region = 'SP' and City = 'Campinas' then 'Outra Cidade de SP'
		WHEN Country = 'BRAZIL' AND Region = 'SP' THEN 'SP - BRAZIL'
		WHEN Country = 'BRAZIL' AND Region = 'RJ' THEN 'RJ - BRAZIL'
		ELSE 'OUTROS VALORES'
	END AS ANALISE_CASE_02
-- IIF Especifico do SQL SERVER
	,IIF (Country = 'BRAZIL' AND Region = 'SP', 'VERDADEIRO', 'FALSO') AS ANALISE_IIF
,*
FROM treinamento.Customers
where Country = 'Brazil'



--31: CASE ENCADEADO
SELECT 
CASE 
	WHEN Country = 'BRAZIL' THEN 
		(CASE 
			WHEN CITY = 'Campinas' THEN 'Verdadeiro - Campinas/SP'
			else 
			(CASE
				WHEN CITY = 'Resende' THEN 'Verdadeiro - Resende/RJ'
				else 'Falso para todos'
				END)
					END)
		ELSE 'OUTRO VALOR'
END AS CASE_ENCADEADO
,*
FROM treinamento.Customers
order by Country


/*case no where*/

select * from TREINAMENTO.Customers
where  (case WHEN Country = 'BRAZIL' AND Region = 'SP' THEN 'SP - BRAZIL' end) = 'SP - BRAZIL'


/* fazendo update com case

update tbFuncionario
set salario = 
			(
			case
				when regiao = 'nordesde' and salario between 1800 and 5000 then salario * 1.3
				when regiao = 'nordesde' and salario > 5000 then salario * 1.4
				when regiao = 'sul' and salario > 5000 then salario * 1.2
			end
			)
		
where status_func = 'A' 

*/


/* -- Gerar tabela primeiro na parte de join!
-- Extração de relatorio com condições: 
1) Salario maior ou igual 900 e Data de admissao maior ou igual 2018 = +20%
2) Salario entre 2000 e 4000 = +10%
3) Salario maior que 4000 = +100 reais
*/
SELECT
NOME,
SALARIO,
DATAADMISSAO,
CASE
	WHEN SALARIO >=900 AND YEAR(DATAADMISSAO) >= 2018 THEN CAST(SALARIO * 1.2 AS DECIMAL(10,2))
	WHEN SALARIO BETWEEN 2000 AND 4000 THEN CAST(SALARIO * 1.1 AS DECIMAL(10,2))
	WHEN SALARIO > 4000 THEN CAST(SALARIO + 100 AS DECIMAL(10,2))
ELSE CAST(SALARIO AS DECIMAL(10,2))
END SALARIO_NOVO
FROM treinamento.FUNCIONARIO



--32: distinct - remove linhas duplicadas do resultado da consulta ** apenas na exibição**
-- Explicar questão da pessoa com mesmo salario que pode ter
SELECT  
	Country--, city, Region
FROM treinamento.Customers
order by country

SELECT distinct 
	Country
FROM treinamento.Customers
order by country

-- Com duas colunas:
SELECT 
	Country, city--, Region
FROM treinamento.Customers
order by country, city

SELECT distinct 
	Country, city
FROM treinamento.Customers
order by country
-- OU com GROUP BY
select Country, city
FROM treinamento.Customers
group by  Country, city
order by country

SELECT  
	Country, city, fax
FROM treinamento.Customers
order by country, city

SELECT distinct 
	Country, city, fax
FROM treinamento.Customers
order by country, city


--33: top - limita a quantidade de registros exibidos na consulta -- o order by influencia na saida
SELECT distinct top (5)
	 Country
FROM treinamento.Customers
order by country asc -- ordem alfabetica de A para Z


SELECT distinct top (5)
	 Country
FROM treinamento.Customers
order by country desc-- ordem alfabetica de Z para A




/************ JOINS ***********/

CREATE TABLE treinamento.DEPARTAMENTO (
CODIGO INT PRIMARY KEY IDENTITY,
DESCRICAO VARCHAR(100) NOT NULL);
GO

CREATE TABLE treinamento.FUNCAO (
CODIGO INT PRIMARY KEY IDENTITY,
DESCRICAO VARCHAR(100))
GO

CREATE TABLE treinamento.FUNCIONARIO(
MATRICULA INT PRIMARY KEY IDENTITY,
NOME VARCHAR (255) NOT NULL,
DATANASCIMENTO DATE NOT NULL,
CPF CHAR(11) UNIQUE CHECK (LEN(CPF) = 11),
SALARIO MONEY NULL,
DATAADMISSAO DATE DEFAULT (GETDATE()),
DATADEMISSAO DATE NULL,
INICIOFERIAS DATE NULL,
FIMFERIAS DATE NULL,
STATUS_FUNC VARCHAR (20) CHECK (STATUS_FUNC IN ('ATIVO','INATIVO','FERIAS','LICENÇA','INSS')),

CODDEPTO INT FOREIGN KEY REFERENCES treinamento.DEPARTAMENTO (CODIGO),

CODSUPERVISOR INT FOREIGN KEY REFERENCES treinamento.FUNCIONARIO (MATRICULA),

CODFUNCAO INT FOREIGN KEY REFERENCES treinamento.FUNCAO (CODIGO))
GO


/*INSERINDO REGISTROS*/


INSERT INTO treinamento.DEPARTAMENTO
VALUES 	('TECNOLOGIA DA INFORMACAO'),
	('RECURSOS HUMANOS'),
	('JURIDICO'),('SELEÇÃO'),
	('CONTABILIDADE'),
	('CONTAS A PAGAR E RECEBER'), 
	('DEPARTAMENTO PESSOAL')
GO

INSERT INTO treinamento.FUNCAO
VALUES ('ESTAGIARIO'), ('ANALISTA JR'),('ANALISTA PL'),('ANALISTA SR'),('COORDENADOR'),('GERENTE')
GO


INSERT INTO treinamento.FUNCIONARIO (NOME, DATANASCIMENTO,CPF, SALARIO,DATAADMISSAO,DATADEMISSAO,INICIOFERIAS,FIMFERIAS, STATUS_FUNC, CODDEPTO, CODSUPERVISOR, CODFUNCAO)
VALUES 
('ANA MARIA', '2000-01-01','12345678911', 1200.55, '2018-05-01',NULL,NULL,NULL, 'ATIVO', 1, 6, 2 ),
('JOSE HENRIQUE', '1998-11-20','12345678912', 2575.55, '2005-09-01','2017-12-01',NULL,NULL, 'INATIVO', 7, NULL, 3 ),
('ANA MARIA', '2002-08-21','12345678913', 950.00, '2019-01-01',NULL,NULL,NULL, 'ATIVO', 6, NULL, 1),
('LUAN FELIX', '1991-09-28','12345678914', 3500.00, '2013-04-01',NULL,NULL,NULL, 'ATIVO', 3,NULL,2),
('FELIPE JOSE DOS SANTOS', '1996-01-11','12345678915', 4000, '2011-05-01','2015-01-29',NULL,NULL, 'INATIVO', 2, NULL, 3),
('MARCELO JOSE', '1980-10-05','12345678916', 7000, '2000-05-01',NULL,'2019-05-01','2019-06-01', 'ATIVO', 1, NULL, 1),
('MARIANA MARIA', '1987-02-08','12345678917', 4500, '2010-01-01',NULL,NULL,NULL, 'INSS', 1, 6, 3 ),
('JULIANA MARIA DOS SANTOS', '2002-01-01','12345678918', 2000, '2017-05-01',NULL,NULL,NULL, 'LICENÇA', 5, NULL, 2 ),
('MARIA ALICIA', '2001-01-01','12345678919', 950, '2018-05-01',NULL,NULL,NULL, 'ATIVO', 1, 6, 1)
GO
	
INSERT INTO treinamento.FUNCIONARIO (NOME, DATANASCIMENTO,CPF, SALARIO,STATUS_FUNC, CODDEPTO,CODSUPERVISOR,CODFUNCAO)
VALUES ('MARIA ALICIA', '2003-09-18','12345678920', 950,  'ATIVO', NULL, NULL,1)


SELECT *
FROM treinamento.DEPARTAMENTO

SELECT *
FROM treinamento.FUNCIONARIO

SELECT * 
FROM treinamento.FUNCAO

/*
INNER JOIN - TRAGA SOMENTE FUNCIONARIOS QUE TEM DEPARTAMENTO 
E DEPARTAMENTO QUE TEM FUNCIONARIO VINCULADO

SE HOUVER UM JOIN SEM O INNER, NÃO SE PREOCUPE, O INNER ESTA IMPLICITO

*/
SELECT 
	F.NOME
	,D.DESCRICAO
	,F.CODDEPTO AS FK_FUNC_DEPARTAMENTO
	,D.CODIGO AS PK_DEPARTAMENTO
FROM treinamento.FUNCIONARIO as F
	INNER JOIN treinamento.DEPARTAMENTO as D
		ON F.CODDEPTO = D.CODIGO

/*
LEFT JOIN - TRAGA TODOS OS FUNCIONARIOS QUE TEM DEPARTAMENTO OU NÃO
SE HOUVER UM LEFT JOIN SEM O OUTER, NÃO SE PREOCUPE, O OUTER ESTA IMPLICITO

*/
	SELECT 
		F.NOME
		,D.DESCRICAO 
		,F.CODDEPTO AS FK_FUNC_DEPARTAMENTO
		,D.CODIGO AS PK_DEPARTAMENTO
	FROM treinamento.FUNCIONARIO as F
		LEFT OUTER JOIN treinamento.DEPARTAMENTO as D 
			ON F.CODDEPTO = D.CODIGO

/*
LEFT JOIN EXCLUSIVO- TRAGA SOMENTE OS FUNCIONARIOS QUE NÃO TEM DEPARTAMENTO
SE HOUVER UM LEFT JOIN SEM O OUTER, NÃO SE PREOCUPE, O OUTER ESTA IMPLICITO

*/
SELECT 
	F.NOME 
	,D.DESCRICAO
	,F.CODDEPTO AS FK_FUNC_DEPARTAMENTO
	,D.CODIGO AS PK_DEPARTAMENTO
FROM treinamento.FUNCIONARIO as F
	LEFT JOIN treinamento.DEPARTAMENTO as D
		ON F.CODDEPTO = D.CODIGO
WHERE D.CODIGO IS NULL


/*
RIGHT JOIN - TRAGA TODOS OS DEPARTAMENTOS QUE TEM FUNCIONARIO OU NÃO
SE HOUVER UM RIGHT JOIN SEM O OUTER, NÃO SE PREOCUPE, O OUTER ESTA IMPLICITO

*/

SELECT 
	F.NOME
	,D.DESCRICAO 
	,F.CODDEPTO AS FK_FUNC_DEPARTAMENTO
	,D.CODIGO AS PK_DEPARTAMENTO
FROM treinamento.FUNCIONARIO as F --> ESQUERDA
	RIGHT JOIN treinamento.DEPARTAMENTO as D --> DEPTO
		ON F.CODDEPTO = D.CODIGO

--RIGHT JOIN EXCLUSIVO
SELECT 
	F.NOME, 
	D.DESCRICAO 
FROM treinamento.FUNCIONARIO as F
	RIGHT JOIN treinamento.DEPARTAMENTO as D
		ON F.CODDEPTO = D.CODIGO
WHERE F.CODDEPTO IS NULL


/*
FULL JOIN - TRAGA TODOS OS DEPARTAMENTOS QUE TEM  NÃO FUNCIONARIO 
E TODOS OS FUNCIONARIOS QUE TEM OU NÃO DEPARTAMENTO

SE HOUVER UM FULL JOIN SEM O OUTER, NÃO SE PREOCUPE, O OUTER ESTA IMPLICITO

*/
SELECT 
	F.NOME, 
	D.DESCRICAO 
FROM treinamento.FUNCIONARIO as F
	FULL JOIN treinamento.DEPARTAMENTO as D
		ON F.CODDEPTO = D.CODIGO

--FULL JOIN EXCLUSIVO
SELECT 
	F.NOME, 
	D.DESCRICAO 
FROM treinamento.FUNCIONARIO as F
	FULL JOIN treinamento.DEPARTAMENTO as D
		ON F.CODDEPTO = D.CODIGO
WHERE F.CODDEPTO IS NULL OR D.CODIGO IS NULL


/*
CROSS JOIN - PRODUTO CARTESIANO
*NÃO UTILIZA A CLAUSULA ON
FAZ UMA MULTIPLICAÇÃO DOS REGISTROS DE A COM B
SE A TEM 3 REGISTROS E B TEM 4 REGISTROS O RESULTADO DO CROSS É 12.
*/

SELECT 
	F.NOME, 
	D.DESCRICAO,
	F.CPF
FROM treinamento.FUNCIONARIO as F
	CROSS JOIN treinamento.DEPARTAMENTO as D



--inner join - todo mundo que tem correlação nas duas tabelas, 
--Ex: clientes que fizeram pedidos e pedidos que estão vinculados a um cliente

select 
	cli.CustomerID as codigoCliente,
	ped.OrderID as codigoPedido
from treinamento.Customers as cli
inner join	treinamento.Orders as ped
	on cli.CustomerID = ped.CustomerID
order by codigoCliente


/*
left join - todo mundo da tabela da esquerda que tem ou não correlação com a tabela da direita
Ex: clientes que fizeram ou não um pedido
*/

select 
	cli.CustomerID as codigoCliente,
	ped.OrderID as codigoPedido
from treinamento.Customers as cli
left join	treinamento.Orders as ped
	on cli.CustomerID = ped.CustomerID
order by codigoPedido

-- left join exclusivo (Apenas clientes que não fizeram compras)
select 
	cli.CustomerID as codigoCliente,
	ped.OrderID as codigoPedido
from treinamento.Customers as cli
left join	treinamento.Orders as ped
	on cli.CustomerID = ped.CustomerID
	where ped.OrderID is null
order by codigoCliente


/*
right join - todo mundo da tabela da direita que tem ou não correlação com a tabela da esquerda
Ex: clientes que fizeram ou não um pedido
*/


select 
	cli.CustomerID as codigoCliente,
	ped.OrderID as codigoPedido
from treinamento.Orders as ped
right join treinamento.Customers as cli
	on cli.CustomerID = ped.CustomerID
order by codigoCliente

-- right join exclusivo
select 
	cli.CustomerID as codigoCliente,
	ped.OrderID as codigoPedido
from treinamento.Orders as ped
right join treinamento.Customers as cli
	on cli.CustomerID = ped.CustomerID
	where ped.OrderID is null
order by codigoCliente

--full join - todo mundo que tem ou não correlação da esquerda e direita
-- Ex: clientes que fizeram ou não um pedido, pedidos que tem ou não cliente

select 
	cli.CustomerID as codigoCliente,
	ped.OrderID as codigoPedido
from treinamento.Orders as ped
full join treinamento.Customers as cli
	on cli.CustomerID = ped.CustomerID
order by codigoPedido

-- full join exclusivo
select 
	cli.CustomerID as codigoCliente,
	ped.OrderID as codigoPedido
from treinamento.Orders as ped
full join treinamento.Customers as cli
	on cli.CustomerID = ped.CustomerID
	where ped.OrderID is null
	or cli.CustomerID is null
order by codigoCliente

-- Cross Join - produto cartesiano - multiplica as linhas da tabela A com as da tabela B
-- Quero pegar todos clientes e multiplicar pela empresa de entrega
select 
	a.CompanyName,
	b.CompanyName,
	b.City
from treinamento.Shippers as a
cross join treinamento.Customers as b
order by a.CompanyName

--JOIN com mais de uma tabela
-- "Vinicius tenho muita dificuldade de fazer multiplos joins"
-- Minha tabela padrão é pedidos, primeiro join é inner entre pedidos e clientes.
-- Eu não relaciono employee empregado com cliente, relaciono atraves da venda
select
	cli.CustomerID as codigoCliente,
	cli.CompanyName as nomeClinte,
	ped.OrderID as codigoPedido,
	func.FirstName as PrimeiroNomeFuncionario,
	func.LastName as UltimoNomeFuncionario,
	transp.CompanyName as Transportora
from treinamento.Orders as ped

inner join treinamento.Customers as cli
	on cli.CustomerID = ped.CustomerID

left join treinamento.Employees as func
	on ped.EmployeeID = func.EmployeeID

left join treinamento.Shippers as transp
	on	transp.ShipperID = ped.ShipperID

order by codigoCliente


-- EXPLICAR: JOIN PRECISAMOS ENTENDER A MODELAGEM, AS RELAÇÕES