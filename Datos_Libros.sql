-- BD Datos_Libros
-- Tabla Libros: c�digo, titulo, n�ejemplares y precio
use master
create database Datos_Libros
go
use Datos_Libros
create table Libros (
Codigo tinyint identity(1,1),
Titulo char(40),
NEjemplares tinyint,
Precio smallmoney default 30,
Primary Key (Codigo),
CHECK (Precio between 10 and 150)
);