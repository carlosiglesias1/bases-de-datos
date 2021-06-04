use master;
go
--Creo la base de datos "Proyectos"--
if db_id (N'Proyectos')is not null
	drop database Proyectos;
go
create database Proyectos; 
go
--Creo las tablas--
use Proyectos;
go 
--Tabla de proyectos--
create table pro (
cod_pro smallint,
nombre char(25),
presupuesto money,
primary key (cod_pro)
);
go
--Tabla de investigadores--
create table inv (
dni char (9),
nombre varchar (25),
apellidos varchar (50),
pro smallint,
primary key (dni),
foreign key (pro) references pro(cod_pro),
);
go
--Tabla de fase de proyecto
create table fase (
cod_pro smallint,
num_fase smallint,
fecha_ini date,
fecha_fin date,
primary key (cod_pro,num_fase),
foreign key (cod_pro) references pro(cod_pro),
); 