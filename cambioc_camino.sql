use camino_sdc
go

--Añadir restricción de dominio
alter table etapa 
	add constraint km_check check (km between 15 and 35);
go

--Añadir una columna
alter table peregrino
	add nacionalidad char (25);

--Eliminar una columna
alter table peregrino
	drop column nacionalidad;
go
--Cambiar tipo de dato de una clave primaria (numero => tinyint -> char -> tinyint), que yo ya había definido el campo numero como tinyint
use camino_sdc
go
alter table recorre							--Elimino la clave foránea a la que pertenece
	drop constraint FK__recorre__etapa;
go
alter table recorre							--Como también va a formar parte de la clave primaria, también la elimino
	drop constraint PK__recorre;
go
alter table etapa
	drop constraint PK__etapa;				--Elimino la clave primaria a la que pertenece
go
alter table etapa
	alter column numero char (10);			--Cambio el tipo de dato 
go
alter table etapa
	alter column numero tinyint not null;	--Cambio el tipo de dato (en recorre lo dejo estar como tinyint)
go
alter table etapa							--Devuelvo las claves primarias y foráneas
	add constraint  PK__etapa primary key clustered (nombre,numero);
go
alter table recorre
	add constraint FK__recorre__etapa foreign key (nombre, numero) references etapa(nombre, numero);
go
alter table recorre
	add constraint PK__recorre primary key (nombre, numero, carnet);