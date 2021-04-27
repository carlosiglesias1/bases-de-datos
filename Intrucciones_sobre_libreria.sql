-- Incrementar el tamaño del archivo primario en 5 MB e incrementar el factor de crecimiento en 1 MB
alter database Libreria
modify file (
name = libreriadat,
size = 15,
filegrowth = 6
)
-- Modificar el tamaño del campo Apellidos de Clientes aumentándole 5 caracteres
alter table Clientes
alter column Apellidos varchar (45)
-- Añadir restricción check en Sotck de Libros, no puede superar los 15 ejemplares
alter table Libros
add constraint CK_ST
check (Stock<=15)
-- Añadir restricción default al Precio de los Libros, que será de 30€
alter table Libros
add constraint DF_PC
default 30 for Precio
-- La fecha de los pedidos la ha de tomar del sistema
alter table Pedidos
add constraint DF_Fecha
default getdate() for fecha
-- Añadir Anaya y Rama como editoriales
insert into Editoriales
values ('1', 'Anaya', 'A/Monelos 201 Bajo', 'A Coruña', 'A Coruña', '15009', '606717171'),
('2', 'Rama', 'R/Outeiro 160 Bajo', 'A Coruña', 'A Coruña', '15008', '607121212')
-- Añadir 2 libros de Anaya y 1 de Rama
insert into Libros
values ('1', 'El ladrón', 'José Pérez', 25, 12, '1-1-2021', '1'),
('2', 'La Marcha', 'Benito López', 35, 5, '5-3-1995', '1'),
('3', 'Escondidos', 'Luís García', 15, 10, '7-6-2020', '2')
-- Listar título del libro, precio y stock y nombre de la editorial a la que pertenece
select Título, Precio, Stock, e.Nombre Editorial
from Libros l
inner join Editoriales e on l.Editorial=e.Cod_ed
-- Añadir 2 clientes
insert into Clientes
values ('1', '12345678A', 'Álvaro', 'Gómez', 'c/Barcelona', 'Betanzos', 'A Coruña', '15176', '505678934'),
('2', '87654321A', 'Juan', 'Eirea', 'a/Finisterre', 'A Coruña', 'A Coruña', '15009', '707123456')
-- Insertar un pedido para el cliente 1 de los libros 1 y 3
insert into Pedidos -- Aquí podría no especificar la fecha ya que tenemos un default, aunque habría que especificar a que columnas añadimos datos
values ('1', '9-11-2020', '1')
insert into Detalle_pedidos
values ('1', '1', 5),
('1', '3', 2)
-- Nombre y apeliidos del cliente, fecha del pedido, título del libro y ejemplares pedidos
select Nombre, Apellidos, Fecha, Título, Num_ej Ejemplares
from Clientes c
inner join Pedidos p on c.Cod_cli=p.Cod_cli
inner join Detalle_pedidos dp on p.Num_ped=dp.Num_ped
inner join Libros l on l.Cod_lib=dp.Cod_lib