USE master;
GO
IF DB_ID ('Hospital') IS NOT NULL
DROP DATABASE Hospital
GO
CREATE DATABASE Hospital
ON
(NAME = Hospitaldat,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Hospitaldat.mdf',
SIZE = 10,
MAXSIZE = unlimited,
FILEGROWTH = 5 )
LOG ON
( NAME = Hospitallog,
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Hospitallog.ldf',
SIZE = 5MB,
MAXSIZE = unlimited,
FILEGROWTH = 5MB ) ;
GO
use Hospital
GO
create table Servicios(
 código char(2) primary key,
 nombre varchar(20) not null,
 camas tinyint not null
)
go
create table Médicos(
 num_colegiado char(5) primary key,
 nombre varchar(50) not null,
 Teléfono char(9) not null,
 servicio char(2),
 foreign key (servicio) references Servicios (código)
 on delete no action
 on update cascade
)
go
create table Pacientes(
 num_historia char(10) primary key,
 nombre varchar(50) not null,
 teléfono char(9) not null,
 seguro char(15),
 fecha_nac date not null
)
go
create table Ingresos(
 num_historia char(10),
 num_ingreso char(2),
 diagnóstico varchar(100),
 f_ingreso date not null,
 f_alta date,
 servicio char(2),
 médico char(5),
 primary key(num_historia,num_ingreso),
 foreign key (num_historia) references Pacientes(num_historia)
 on delete no action
 on update no action,
 foreign key (servicio) references Servicios(código)
 on delete no action
 on update cascade,
 foreign key (médico) references Médicos(num_colegiado)
 on delete no action
 on update no action
)
go
create table Medicamentos(
 num_registro char(10) primary key,
 nombre varchar(30) not null,
 composición varchar(300) not null
)
go
create table Prescriben(
 médico char(5),
 paciente char(10),
 medicamento char(10),
 fecha date,
 dosis varchar(50),
 primary key (médico,paciente,medicamento,fecha),
 foreign key (médico) references Médicos(num_colegiado)
 on delete no action
 on update no action,
 foreign key (paciente) references Pacientes(num_historia)
 on delete no action
 on update no action,
 foreign key (medicamento) references Medicamentos(num_registro)
 on delete no action
 on update no action
)