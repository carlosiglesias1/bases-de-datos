USE master;
GO
IF DB_ID ('Libreria') IS NOT NULL
DROP DATABASE Libreria;
GO
CREATE DATABASE Libreria
ON
( NAME = libreriadat,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\libreriadat.mdf',
    SIZE = 10,
    MAXSIZE = unlimited,
    FILEGROWTH = 5 )
LOG ON
( NAME = librerialog,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\librerialog.ldf',
    SIZE = 5MB,
    MAXSIZE = unlimited,
    FILEGROWTH = 5MB ) ;
GO
use Libreria
GO
Create Table Editoriales (
Cod_ed varchar (3) primary key,
Nombre varchar (30) not null,
Direccion varchar (40) not null,
Localidad varchar (30) not null,
Provincia varchar (30) not null,
CP char (5) not null,
Telefono char(9) not null
);
Create Table Libros (
Cod_lib char (3) primary key,
Titulo varchar (40) not null,
Autor varchar (30) not null,
Precio smallmoney not null,
Stock tinyint not null,
Fecha_Edicion date not null,
Editorial varchar (3) references Editoriales(Cod_ed)
on update cascade
);
Create Table Clientes (
Cod_cli varchar (3) primary key,
DNI char (9) unique not null,
Nombre varchar (30) not null,
Apellidos varchar(40) not null,
Direccion varchar (40) not null,
Localidad varchar (30) not null,
Provincia varchar (30) not null,
CP char (5) not null,
Telefono char(9) not null
);
Create Table Pedidos (
Num_ped char (3) primary key,
Fecha date not null,
Cod_cli varchar (3) references Clientes(Cod_cli)
on update cascade
);
Create Table Detalle_pedidos (
Num_ped char (3),
Cod_lib char(3),
Num_ej tinyint not  null,
Primary Key (Num_ped, Cod_lib),
Foreign Key (Num_ped) references Pedidos (Num_ped)
on delete cascade
on update cascade,
Foreign Key (Cod_lib) references Libros (Cod_lib)
on update cascade
);