use master
go
if db_id ('camino_sdc') is not null
	drop database camino_sdc;
go

create database camino_sdc;
go

use camino_sdc;
go
create table camino(
 nombre varchar(25),
 km smallint not null,
 primary key (nombre),
 )
 go

 create table localidad(
 cod_loc char (5) primary key,
 nombre varchar (25) not null,
 c_a varchar (25) not null,
 )
 go 

 create table etapa(
 nombre varchar (25),
 numero tinyint,
 km tinyint not null,
 ciudad_salida char(5) not null,
 ciudad_llegada char (5) not null,
 constraint PK__etapa primary key (nombre,numero), --Escojo el nombre de la clave
 foreign key (nombre) references camino(nombre),
 foreign key (ciudad_salida) references localidad(cod_loc)
	on update no action
	on delete no action,
 foreign key (ciudad_llegada) references localidad(cod_loc),
 )

go

create table peregrino(
carnet char (9) primary key,
dni char (9) not null,
nombre varchar (20) not null,
apellido varchar (20) not null,
tlf char (9) not null
)

go

create table recorre(
carnet char (9),
nombre varchar (25),
numero tinyint,
fecha date not null,
constraint PK__recorre primary key (carnet, nombre, numero),								--Cambio el nombre de la clave
constraint FK__recorre__etapa foreign key (nombre, numero) references etapa(nombre,numero)	--Cambio el nombre de la clave
	on update cascade,
foreign key (carnet) references peregrino(carnet)
	on update cascade
)
go
