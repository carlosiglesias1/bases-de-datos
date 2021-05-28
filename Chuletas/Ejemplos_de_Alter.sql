use Datos_Libros
alter table Libros
add constraint CK_Precio
check (Precio between 20 and 150)
go
alter table Libros
drop constraint CK_Precio
go
alter table Libros
add constraint DF_Precio
default 30 for Precio
go
alter table Libros
add Autor varchar(50)
go
alter table Libros
drop column Autor
go
alter table Libros
alter column Titulo varchar (60)