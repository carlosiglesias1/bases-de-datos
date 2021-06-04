use camino_sdc
go

--A�adir restricci�n de dominio
alter table etapa 
	add constraint km_check check (km between 15 and 35);
go

--A�adir una columna
alter table peregrino
	add nacionalidad char (25);

--Eliminar una columna
alter table peregrino
	drop column nacionalidad;
go
--Cambiar tipo de dato (char -> varchar)
use camino_sdc
go
alter table peregrino
	alter column apellido varchar (65)
go