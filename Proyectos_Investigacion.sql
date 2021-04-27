use master
go
IF DB_ID ('Proyecto_Investigacion') IS NOT NULL
DROP DATABASE Proyecto_Investigacion;
GO
create database Proyecto_Investigacion
on
(name=Proyecto_Investigacion_dat,
filename='C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Proyecto_Investigacion.mdf',
size=10,
maxsize=unlimited,
filegrowth=5)
LOG ON
(name='Proyecto_Investigacion_log',
filename='C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Proyecto_Investigacion.ldf',
size=5 MB,
maxsize=unlimited,
filegrowth=5 MB)
go
Use Proyecto_Investigacion
go
Create Table Proyectos
(Codigo char(15),
Nombre char(30) not null unique,
Presupuesto money,
PRIMARY KEY (Codigo)
);
go
Create Table Investigadores
(DNI char(9),
Nombre char (20) not null,
Apellidos char (40) unique,
Codigo char(15),
PRIMARY KEY (DNI),
Foreign Key (Codigo) references Proyectos(Codigo)
on update cascade
on delete set null
);
Create Table Fases
(No_Secuencial char(15),
Fecha_inicio date,
Fecha_fin date,
Codigo char(15),
PRIMARY KEY (No_Secuencial, Codigo),
Foreign Key (Codigo) references Proyectos(Codigo)
on update cascade
on delete cascade
);