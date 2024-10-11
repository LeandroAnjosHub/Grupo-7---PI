DROP database aeroControl;
CREATE DATABASE IF NOT EXISTS aeroControl;
USE aeroControl;

Create table Aeroporto (
idAeroporto int primary key auto_increment,
nome varchar(40),
CEP char(9),
numero int
);

Create table Usuario (
idUsuario int primary key auto_increment,
nome varchar(40),
dataNasc DATE,
cpf char(11),
senha varchar(30),
cargo varchar(40),
fkAeroporto int,
constraint foreign key (fkAeroporto) references Aeroporto(idAeroporto)
);

Create table Computador (
idComputador int primary key,
hostname varchar(45),
processador varchar(45),
memoria varchar(5),
armazenamento varchar(6),
setor varchar(45),
fkAeroporto int,
constraint foreign key (fkAeroporto) references Aeroporto(idAeroporto)
);

Create table DadoComputador (
idDado int primary key auto_increment,
horaDado datetime default CURRENT_TIMESTAMP,
cpuPorcentagem decimal(5,2),
memoriaPorcentagem decimal(5,2),
memoriaGB int,
fkComputador int,
constraint foreign key (fkComputador) references Computador(idComputador)
);

INSERT INTO Aeroporto VALUES
	(1, 'Congonhas', '3641-001', 1);

INSERT INTO Computador VALUES
	(2, 'nb-martinez', 'i5-1334', '16GB', '1TB', 'Comunicação com Pilotos', 1);
    
    SELECT * FROM DadoComputador;
    
SELECT * FROM Aeroporto;

SELECT * FROM usuario;