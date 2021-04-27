-- Incrementar el tama�o del archivo primario en 5 MB e incrementar el factor de crecimiento en 1 MB
alter database Libreria
modify file (
name = libreriadat,
size = 15,
filegrowth = 6
)
-- Modificar el tama�o del campo Apellidos de Clientes aument�ndole 5 caracteres
alter table Clientes
alter column Apellidos varchar (45)
-- A�adir restricci�n check en Sotck de Libros, no puede superar los 15 ejemplares
alter table Libros
add constraint CK_ST
check (Stock<=15)
-- A�adir restricci�n default al Precio de los Libros, que ser� de 30�
alter table Libros
add constraint DF_PC
default 30 for Precio
-- La fecha de los pedidos la ha de tomar del sistema
alter table Pedidos
add constraint DF_Fecha
default getdate() for fecha
-- A�adir Anaya y Rama como editoriales
insert into Editoriales
values ('1', 'Anaya', 'A/Monelos 201 Bajo', 'A Coru�a', 'A Coru�a', '15009', '606717171'),
('2', 'Rama', 'R/Outeiro 160 Bajo', 'A Coru�a', 'A Coru�a', '15008', '607121212')
-- A�adir 2 libros de Anaya y 1 de Rama
insert into Libros
values ('1', 'El ladr�n', 'Jos� P�rez', 25, 12, '1-1-2021', '1'),
('2', 'La Marcha', 'Benito L�pez', 35, 5, '5-3-1995', '1'),
('3', 'Escondidos', 'Lu�s Garc�a', 15, 10, '7-6-2020', '2')
-- Listar t�tulo del libro, precio y stock y nombre de la editorial a la que pertenece
select T�tulo, Precio, Stock, e.Nombre Editorial
from Libros l
inner join Editoriales e on l.Editorial=e.Cod_ed
-- A�adir 2 clientes
insert into Clientes
values ('1', '12345678A', '�lvaro', 'G�mez', 'c/Barcelona', 'Betanzos', 'A Coru�a', '15176', '505678934'),
('2', '87654321A', 'Juan', 'Eirea', 'a/Finisterre', 'A Coru�a', 'A Coru�a', '15009', '707123456')
-- Insertar un pedido para el cliente 1 de los libros 1 y 3
insert into Pedidos -- Aqu� podr�a no especificar la fecha ya que tenemos un default, aunque habr�a que especificar a que columnas a�adimos datos
values ('1', '9-11-2020', '1')
insert into Detalle_pedidos
values ('1', '1', 5),
('1', '3', 2)
-- Nombre y apeliidos del cliente, fecha del pedido, t�tulo del libro y ejemplares pedidos
select Nombre, Apellidos, Fecha, T�tulo, Num_ej Ejemplares
from Clientes c
inner join Pedidos p on c.Cod_cli=p.Cod_cli
inner join Detalle_pedidos dp on p.Num_ped=dp.Num_ped
inner join Libros l on l.Cod_lib=dp.Cod_lib