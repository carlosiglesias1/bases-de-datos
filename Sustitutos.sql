use master
go
create database sustitutos
go
use sustitutos
go
create table Profesores
(dni char(9) primary key,
Nombre char(30) not null,
Apellidos char(50) not null
)
create table Centros
(Código char(3) primary key,
Nombre char(40) NOT NULL UNIQUE,
)
create table contratos
(dni char(9),
Código char(3) references centros(código),
fecha_i date,
fecha_f date,
primary key (dni, código, fecha_i),
foreign key (dni) references profesores(dni),
--foreign key (código) references centros(código),
)