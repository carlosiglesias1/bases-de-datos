use master;
go

if db_id ('prueba_examen') is not null
drop database prueba_examen;
go
create database prueba_examen
on(
name=examen_dat,
filename='C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\examen.mdf',
size=5,
filegrowth=5
)
log on(
name=examen_log,
filename='C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\examen.ldf',
size=3,
filegrowth=3
)
go
use prueba_examen
go

create table proveedor(
codigo char(5) primary key,
nombre varchar(20),
tlf char(9),
dir char(35),
);
go

create table producto(
codigo char(5) primary key,
nombre varchar(20),
composicion varchar(50) not null,
proveedor char (5) references proveedor(codigo)
on update no action
on delete no action
);
go

create table comercial(
dni char (9) primary key,
nombre varchar (25),
tlf char (9)
);
go

create table cliente(
cif char(9) primary key,
r_s varchar (20),
tlf char(9),
);
go

create table venta(
cliente char (9),
comercial char (9),
fecha date,
primary key (cliente, comercial),
foreign key (cliente) references cliente(cif),
);
go

