use master;
go

if db_id (N'Taller') is not null
	drop database Taller;
go

create database Taller;
go

use Taller;
go

create table cliente (
	dni char (9) primary key,
	nombre char (25) not null,
	telefono char (9) not null,
	check (dni like ('[0-9][0-9][0-9][0-9][-9][0-9][0-9][0-9][a-z]')),
	check (telefono like ('[0-9][0-9][0-9][0-9][-9][0-9][0-9][0-9][0-9]')),
);
go

create table vehiculo (
	matricula char (7) primary key,
	marca char (25) not null,
	modelo char (25) not null,
	propietario char (9) references cliente(dni)
	on delete no action
	on update no action
	not null,
	check (modelo in ('Audi','Mercedes','BMW')),
);
go

create table entrada (
	numero int primary key,
	fecha date,
	hora time default datepart(hour,getdate()),
	motivo char (50),
	coche char (7) references vehiculo(matricula)
	on delete no action
	on update no action,
);
go

create table operario (
	dni char (9) primary key,
	nombre char (25),
	telefono char (9),
	tipo char (12),
	check (telefono like ('[0-9][0-9][0-9][0-9][-9][0-9][0-9][0-9][0-9]')),
	check (tipo in ('Especialista','Aprendiz')),
);
go

create table operacion (
	numero int references entrada(numero),
	orden smallint,
	descripcion char (50) not null,
	especialista char (9) references operario(dni)
	on delete no action
	on update no action
	not null,
	aprendiz char (9) references operario(dni)
	on delete no action
	on update no action
	not null,
	primary key (numero,orden),
);
go

create table recambio (
	codigo char (11) primary key,
	nombre char (25) not null,
	precio smallmoney not null,
	stock smallint not null,
	check (stock between 1 and 10),
);
go

create table usado (
	recambio char (11) references recambio(codigo),
	numero int references entrada(numero),
	orden smallint not null,
	cantidad smallint default 1,
	primary key (recambio,numero,orden),
	foreign key (orden) references operacion(orden),
);
go

alter table operario
	add constraint ck_dni check (dni like ('[0-9][0-9][0-9][0-9][-9][0-9][0-9][0-9][a-z]'));
go

alter table entrada
	add constraint df_date default getdate() for fecha;