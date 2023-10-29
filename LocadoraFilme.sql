create database LocadoraFilme
go
use LocadoraFilme

create table Filme (
    id          int             not null ,
    titulo      varchar(40)     not null ,
    ano         int             null    constraint CH_anoFilme  check (ano <= 2021),
    primary key (id)
)
go
create table Estrela (
    id          int             not null ,
    nome        varchar(50)     not null ,
    primary key (id)
)
go
create table DVD (
    num             int             not null ,
    data_fabricacao date            not null constraint CH_dataFabricacao check (data_fabricacao < getdate()),
    Filmeid         int             not null ,
    primary key (num),
    foreign key (Filmeid) references Filme (id)
)
go
create table Cliente (
    num_cadastro    int             not null ,
    nome            varchar(70)     not null ,
    logradouro      varchar(150)    not null ,
    num             int             not null constraint CH_numEndereco  check (num >= 0),
    cep             char(8)         null     constraint CH_cep          check (len(cep) = 8),
    primary key (num_cadastro)
)
go
create table Locacao (
    DVDnum              int             not null ,
    Clientenum_cadastro int             not null ,
    data_locacao        date            not null constraint DE_dataLocacao default (getdate()),
    data_devolucao      date            not null ,
    valor               decimal(7,2)    not null constraint CH_valorLocacao check (valor >= 0),
    primary key (DVDnum, Clientenum_cadastro, data_locacao),
    foreign key (DVDnum) references DVD (num),
    foreign key (Clientenum_cadastro) references Cliente (num_cadastro),
    constraint CH_dataDevolucao check (data_devolucao > data_locacao)
)
go
create table Filme_Estrela (
    Filmeid             int             not null ,
    Estrelaid           int             not null ,
    primary key (Filmeid, Estrelaid),
    foreign key (Filmeid) references Filme (id),
    foreign key (Estrelaid) references Estrela (id)
)

alter table Estrela
add nome_real       varchar(50)         null
go
alter table Filme
alter column titulo varchar(80)

INSERT INTO filme
VALUES
    (1001, 'Whiplash', 2015),
    (1002, 'Birdman', 2015),
    (1003, 'Interestelar', 2014),
    (1004, 'A Culpa É das Estrelas', 2014),
    (1005, 'Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', 2014),
    (1006, 'Sing', 2016)
GO
INSERT INTO estrela
VALUES
    (9901, 'Michael Keaton', 'Michael John Douglas'),
    (9902, 'Emma Stone', 'Emily Jean Stone'),
    (9903, 'Miles Teller', NULL),
    (9904, 'Steve Carell', 'Steven John Carell'),
    (9905, 'Jennifer Garner', 'Jennifer Anne Garner')
GO
INSERT INTO filme_estrela
VALUES
    (1002, 9901),
    (1002, 9902),
    (1001, 9903),
    (1005, 9904),
    (1005, 9905)
GO
INSERT INTO dvd
VALUES
    (10001, '2020-12-02', 1001),
    (10002, '2019-10-18', 1002),
    (10003, '2020-04-03', 1003),
    (10004, '2020-12-02', 1001),
    (10005, '2019-10-18', 1004),
    (10006, '2020-04-03', 1002),
    (10007, '2020-12-02', 1005),
    (10008, '2019-10-18', 1002),
    (10009, '2020-04-03', 1003)
GO
INSERT INTO cliente
VALUES
    (5501, 'Matilde Luz', 'Rua Síria', 150, '03086040'),
    (5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
    (5503, 'Daniel Ramalho', 'Rua Itajutiba', 169, NULL),
    (5504, 'Roberta Bento', 'Rua Jayme Von Rosenburg', 36, NULL),
    (5505, 'Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110')
GO
INSERT INTO locacao
VALUES
    (10001, 5502, '2021-02-18', '2021-02-21', 3.50),
    (10009, 5502, '2021-02-18', '2021-02-21', 3.50),
    (10002, 5503, '2021-02-18', '2021-02-19', 3.50),
    (10002, 5505, '2021-02-20', '2021-02-23', 3.00),
    (10004, 5505, '2021-02-20', '2021-02-23', 3.00),
    (10005, 5505, '2021-02-20', '2021-02-23', 3.00),
    (10001, 5501, '2021-02-24', '2021-02-26', 3.50),
    (10008, 5501, '2021-02-24', '2021-02-26', 3.50)

update Cliente
set cep = '08411150'
where num_cadastro = '5503'
go
update Cliente
set cep = '02918190'
where num_cadastro = '5504'

-- A locação de 2021-02-18 do cliente 5502 teve o valor de 3.25 para cada DVD alugado

update Locacao
set valor = 3.25
where Clientenum_cadastro = 5502 and data_locacao = '2021-02-18'

-- A locação de 2021-02-24 do cliente 5501 teve o valor de 3.10 para cada DVD alugado

update Locacao
set valor = 3.10
where Clientenum_cadastro = 5501 and data_locacao = '2021-02-24'

-- O DVD 10005 foi fabricado em 2019-07-14

update DVD
set data_fabricacao = '2019-07-14'
where num = 10005

-- O nome real de Miles Teller é Miles Alexander Teller

update Estrela
set nome_real = 'Miles Alexander Teller'
where nome = 'Miles Teller'

-- O filme Sing não tem DVD cadastrado e deve ser excluído

delete from Filme
where titulo = 'Sing'

-- Fazer um select que retorne os nomes dos filmes de 2014

select titulo from Filme
where ano = 2014

-- Fazer um select que retorne o id e o ano do filme Birdman

select id, ano from Filme
where titulo = 'Birdman'

-- Fazer um select que retorne o id e o ano do filme que tem o nome terminado por plash

select id, ano from Filme
where titulo like '%plash'

-- Fazer um select que retorne o id, o nome e o nome_real da estrela cujo nome começa com Steve

select id, nome, nome_real from Estrela
where nome like 'Steve%'

-- Fazer um select que retorne FilmeId e a data_fabricação em formato (DD/MM/YYYY)
-- (apelidar de fab) dos filmes fabricados a partir de 01-01-2020

select Filmeid, convert(char(10), data_fabricacao, 103) as fab from DVD
where data_fabricacao >= '01-01-2020'

-- Fazer um select que retorne DVDnum, data_locacao, data_devolucao, valor e valor
-- com multa de acréscimo de 2.00 da locação do cliente 5505

select DVDnum, data_locacao, data_devolucao, valor, valor + 2.00 as 'valor com multar' from Locacao
where Clientenum_cadastro = 5505

-- Fazer um select que retorne Logradouro, num e CEP de Matilde Luz

select logradouro, num, cep from Cliente
where nome = 'Matilde Luz'

-- Fazer um select que retorne Nome real de Michael Keaton

select nome_real from Estrela
where nome = 'Michael Keaton'

-- Fazer um select que retorne o num_cadastro, o nome e o endereço completo,
-- concatenando (logradouro, numero e CEP), apelido end_comp, dos clientes cujo ID é
-- maior ou igual 5503

select num_cadastro,
       nome,
       logradouro + ' ' + cast(num as varchar(5)) + ' ' + cast(cep as varchar(8)) as end_comp
from Cliente
where num_cadastro >= 5503