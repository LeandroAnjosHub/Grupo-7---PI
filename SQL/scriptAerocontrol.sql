DROP DATABASE IF EXISTS aeroControl;
CREATE DATABASE aeroControl;
USE aeroControl;

CREATE TABLE Aeroporto (
cnpj char(14) primary key,
nomeAeroporto varchar(100),
codigoIATA char(3),
codigoICAO char(4),
cep char(9)
);

CREATE TABLE Usuario (
cpf char(11) primary key,
nomeUsuario varchar(100),
email varchar(320),
senha varchar(30),
cargo varchar(17),
fkAeroporto char(14),
constraint fkAeroportoUsuario foreign key (fkAeroporto) references Aeroporto(cnpj)
);

CREATE TABLE Setor(
idSetor int primary key auto_increment,
nomeSetor varchar(100)
);

CREATE TABLE SetorAeroporto (
fkAeroporto char(14),
fkSetorId int,
constraint fkAeroportoSetor foreign key (fkAeroporto) references Aeroporto(cnpj),
constraint fkSetorAeroporto foreign key (fkSetorId) references Setor(idSetor)
);

CREATE TABLE Computador (
idComputador int primary key auto_increment,
hostname varchar(255),
processador varchar(100),
ramMax decimal(5 , 2),
fkUsuario char(11),
fkSetor int,
constraint fkUsuarioComputador foreign key (fkUsuario) references Usuario(cpf),
constraint fkSetorComputador foreign key (fkSetor) references Setor(idSetor)
);

CREATE TABLE DadoComputador (
idDado int primary key auto_increment,
horaDado datetime default CURRENT_TIMESTAMP,
cpuPorcentagem decimal(5,2),
memoriaPorcentagem decimal(5,2),
memoriaGB decimal(5,2),
fkComputador int,
constraint fkDadoComputador foreign key (fkComputador) references Computador(idComputador)
);

CREATE TABLE Alerta (
idAlerta int primary key auto_increment,
dataAlerta datetime default current_timestamp,
fkDadoComputador int,
constraint fkAlertaDado foreign key (fkDadoComputador) references DadoComputador (idDado),
tipo varchar(50)
);

INSERT INTO Aeroporto VALUES
	('12345678901234', 'Congonhas', 'CGH', 'SBSP', '3641-001'), 
	('43210987654321', 'Guarulhos', 'GRU', 'SBGR', '5437-002'),
	('11223344556677', 'Viracopos', 'VCP', 'SBKP', '0142-003');
    
INSERT INTO Usuario VALUES
	('12345678901' , 'Matheus Requena' , 'matheus@gmail.com' , '1234321', 'Analista de Dados' , '12345678901234'),
	('83526735482' , 'Arthur Herculano' , 'arthur@gmail.com' , '1223334', 'Suporte de T.I.' , '11223344556677'),
	('92653478291' , 'Ricken Scharlack' , 'ricken@gmail.com' , 'rick#Sp', 'Suporte de T.I.' , '43210987654321'),
	('64281964382' , 'Miguel Luvizon' , 'miguel@gmail.com' , '123M!guel', 'Analista de Dados' , '11223344556677'),
	('25107632415' , 'Murilo Martinez' , 'murilo@gmail.com' , 'murilo123', 'Analista de Dados' , '43210987654321');

INSERT INTO Setor VALUES
	(1, 'Despache de Voo'),
	(2, 'Torre de Controle'),
	(3, 'Centro de Meteorologia');

INSERT INTO SetorAeroporto VALUES
	('12345678901234', 1),
	('12345678901234', 2),
	('12345678901234', 3),
	('43210987654321', 1),
	('43210987654321', 2),
	('43210987654321', 3),
	('11223344556677', 1),
	('11223344556677', 2),
	('11223344556677', 3);
    
INSERT INTO Computador VALUES
	(1, 'C1DP', 'i3', '8' ,'12345678901', 1);
    
INSERT INTO Alerta VALUES
(default, "2024-01-01 23:45:32", 4, "alerta");
    
SELECT * FROM Aeroporto;
SELECT * FROM Setor;    
SELECT * FROM SetorAeroporto;
SELECT * FROM Usuario;  
SELECT * FROM Computador;
SELECT * FROM DadoComputador;
SELECT * FROM Alerta;

insert into Computador values (2, 'nb-martinez', 'i5-10', '16', '25107632415', 1);
insert into Computador values (3, "ACER_ASPIRE",'i3-10', '8', '64281964382', 2);

SELECT idComputador FROM Computador WHERE hostname = 'nb-martinez';

-- SELECT DO REQUENA
SELECT horaDado, cpuPorcentagem, memoriaPorcentagem FROM DadoComputador
JOIN Computador
ON idComputador = fkComputador
WHERE idComputador = 1
ORDER BY idDado DESC
LIMIT 25;

-- SELECT DO MARTINEZ

-- SELECT PARA FAZER A COMPARAÇÃO ENTRE OS SETORES
SELECT 
    s.nomeSetor AS setor,
    SUM(CASE WHEN DAY(a.dataAlerta) <= 7 THEN 1 ELSE 0 END) AS semana_1,
    SUM(CASE WHEN DAY(a.dataAlerta) BETWEEN 8 AND 14 THEN 1 ELSE 0 END) AS semana_2,
    SUM(CASE WHEN DAY(a.dataAlerta) BETWEEN 15 AND 21 THEN 1 ELSE 0 END) AS semana_3,
    SUM(CASE WHEN DAY(a.dataAlerta) >= 22 THEN 1 ELSE 0 END) AS semana_4
FROM 
    Alerta a
JOIN 
    DadoComputador dc ON a.fkDadoComputador = dc.idDado
JOIN 
    Computador c ON dc.fkComputador = c.idComputador
JOIN 
    Setor s ON c.fkSetor = s.idSetor
WHERE 
    MONTH(a.dataAlerta) = MONTH(CURRENT_DATE())
    AND YEAR(a.dataAlerta) = YEAR(CURRENT_DATE())
GROUP BY 
    s.nomeSetor
ORDER BY 
    s.nomeSetor;
    
 -- SELECT PARA COMPARAR O SETOR COM ELE MESMO   
    
SELECT 
    s.nomeSetor AS setor,
    SUM(CASE WHEN DAY(a.dataAlerta) <= 7 THEN 1 ELSE 0 END) AS semana_1,
    SUM(CASE WHEN DAY(a.dataAlerta) BETWEEN 8 AND 14 THEN 1 ELSE 0 END) AS semana_2,
    SUM(CASE WHEN DAY(a.dataAlerta) BETWEEN 15 AND 21 THEN 1 ELSE 0 END) AS semana_3,
    SUM(CASE WHEN DAY(a.dataAlerta) >= 22 THEN 1 ELSE 0 END) AS semana_4
FROM 
    Alerta a
JOIN 
    DadoComputador dc ON a.fkDadoComputador = dc.idDado
JOIN 
    Computador c ON dc.fkComputador = c.idComputador
JOIN 
    Setor s ON c.fkSetor = s.idSetor
WHERE 
    MONTH(a.dataAlerta) = MONTH(CURRENT_DATE())
    AND YEAR(a.dataAlerta) = YEAR(CURRENT_DATE())
    AND s.idSetor = 1
GROUP BY 
    s.nomeSetor
ORDER BY 
    s.nomeSetor;

-- SELECT PARA PEGAR A MÉDIA DE CPU E RAM NA SEMANA ATUAL

SELECT 
    s.nomeSetor AS setor,
    c.hostname AS computador,
    AVG(dc.cpuPorcentagem) AS media_cpu,
    AVG(dc.memoriaPorcentagem) AS media_memoria
FROM 
    DadoComputador dc
JOIN 
    Computador c ON dc.fkComputador = c.idComputador
JOIN 
    Setor s ON c.fkSetor = s.idSetor
WHERE 
    YEAR(dc.horaDado) = YEAR(CURRENT_DATE())  
    AND WEEK(dc.horaDado, 1) = WEEK(CURRENT_DATE(), 1)  
    AND s.idSetor = 2
GROUP BY 
    s.nomeSetor, c.hostname
ORDER BY 
    c.hostname;

-- SELECT PARA PEGAR A MÉDIA DE CPU E RAM DA SEMANA ATUAL MAS SE NÃO TIVER ELE PEGA DE DATAS ANTERIORES
SELECT 
    s.nomeSetor AS setor,
    c.hostname AS computador,
    AVG(dc.cpuPorcentagem) AS media_cpu,
    AVG(dc.memoriaPorcentagem) AS media_memoria
FROM 
    DadoComputador dc
JOIN 
    Computador c ON dc.fkComputador = c.idComputador
JOIN 
    Setor s ON c.fkSetor = s.idSetor
WHERE 
    s.idSetor = 2
    AND dc.horaDado > NOW() - INTERVAL 30 DAY  -- Ajustando para os últimos 30 dias
GROUP BY 
    s.nomeSetor, c.hostname
ORDER BY 
    c.hostname;


-- SELECT PARA VER A QUANTIDADE DE ALERTAS
SELECT count(idAlerta) FROM Alerta;

-- SELECT PARA VER A QUANTIDADE DE ALERTAS POR SETOR
SELECT 
    s.nomeSetor AS setor,
    COUNT(a.idAlerta) AS quantidade_alertas
FROM 
    Alerta a
JOIN 
    DadoComputador dc ON a.fkDadoComputador = dc.idDado
JOIN 
    Computador c ON dc.fkComputador = c.idComputador
JOIN 
    Setor s ON c.fkSetor = s.idSetor
WHERE 
    s.idSetor = 1
GROUP BY 
    s.nomeSetor
ORDER BY 
    s.nomeSetor;