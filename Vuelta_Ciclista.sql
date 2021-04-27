USE master;
GO
IF DB_ID ('vuelta') IS NOT NULL
DROP DATABASE vuelta;
GO
CREATE DATABASE vuelta
ON
( NAME = vuelta_dat,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\vueltadat.mdf',
    SIZE = 10,
    MAXSIZE = unlimited,
    FILEGROWTH = 5 )
LOG ON
( NAME = vuelta_log,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\vueltalog.ldf',
    SIZE = 5MB,
    MAXSIZE = unlimited,
    FILEGROWTH = 5MB ) ;
GO
use vuelta;
go
create table vueltas (
Año char (4),
Ciudad_de_salida varchar (30),
Fecha_de_salida date,
Ciudad_de_llegada varchar (30),
Fecha_de_fin date,
Km_totales smallint,
primary key (año),
);
create table etapas (
Año char (4),
Nº_etapa char (3),
Fecha_de_etapa date,
Hora_de_salida time,
Kms_etapa smallint,
Ciudad_de_salida varchar (30),
Ciudad_de_llegada varchar (30),
Primary key (Año, Nº_etapa),
Foreign key (año) references vueltas(Año),
);
create table equipos (
Nombre varchar (25),
Nacionalidad varchar (15),
Primary Key (Nombre),
);
create table ciclistas (
Dni char (9),
Nombre varchar (20),
Apellidos varchar (25),
Equipo varchar (25),
Primary Key (Dni),
Foreign Key (Equipo) references equipos(Nombre)
on delete no action
on update cascade,
);
create table participa (
Año char (4),
Nº_etapa char (3),
Dni char (9),
Horas tinyint,
Minutos tinyint,
Segundos tinyint,
Primary Key (Año, Nº_etapa, Dni),
Foreign Key (Año, Nº_etapa) references etapas(Año, Nº_etapa),
Foreign Key (Dni) references ciclistas(Dni),
);