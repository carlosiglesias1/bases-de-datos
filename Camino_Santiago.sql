USE master;
GO
IF DB_ID ('Camino_santiago') IS NOT NULL
DROP DATABASE Camino_santiago;
GO
CREATE DATABASE Camino_santiago
ON
( NAME = caminodat,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\caminodat.mdf',
    SIZE = 10,
    MAXSIZE = unlimited,
    FILEGROWTH = 5 )
LOG ON
( NAME = caminolog,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\caminolog.ldf',
    SIZE = 5MB,
    MAXSIZE = unlimited,
    FILEGROWTH = 5MB ) ;
GO
use Camino_santiago
go
Create Table Caminos
(Nombre varchar(30) primary key,
Km smallint not null
)
create table Localidades
(Código char(5) primary key,
Nombre varchar(50) not null,
Comunidad_A varchar(40) not null
)
create table Etapas
(Nombre varchar(30),
Número char(2),
km tinyint default 20,
Ciudad_s char(5) not null references localidades(código)
			on delete no action
			on update no action,
Ciudad_ll char(5) not null references localidades(código), 
primary key(nombre, número),
foreign key (nombre) references caminos(nombre)
)
create table peregrinos
(carnet char(4) primary key,
dni char(9) not null,
Nombre varchar(20) not null,
Apellidos varchar(40) not null,
Teléfono char(9) not null
)
create table Recorren
(carnet char(4) references peregrinos(carnet)
					on update cascade,
Nombre varchar(30),
Número char(2),
fecha date not null,
primary key (carnet, nombre, número),
foreign key (nombre, número) references etapas(nombre, número)
	on update cascade
)

--Cambiar el tamaño del archivo primario a 20 MB
alter database Camino_Santiago
modify file (
name = caminodat,
size = 20);
--Cambiar el tamaño del archivo de log a 10MB
alter database Camino_Santiago
modify file (
name = caminolog,
size = 10);
--Cambiar el factor de crecimiento del archivo primario a 3MB
alter database Camino_Santiago
modify file (
name = caminodat,
filegrowth = 3);
---Añadir una restricción check en KM de etapas , tiene que estar entre 15 y 35
alter table etapas
add constraint CK_KM
check (km between 15 and 35);
--Cambiar el tipo de dato de la columna número de etapa por tinyint
alter table etapas
alter column Número tinyint;
-- Añadir la columna Nacionalidad a Peregrinos
alter table Peregrinos
add Nacionalidad varchar (25);
-- Eliminar la columna anterior
alter table Peregrinos
drop column Nacionalidad;