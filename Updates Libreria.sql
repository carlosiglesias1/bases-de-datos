-- Poner a todos los clientes el CP 15000
update Clientes
set CP = 15000
-- Poner a todos los clientes de A Coru�a el c�digo 15009
update Clientes
set CP = 15009
where Provincia = 'A Coru�a'
-- A todos los libros de la editorial 1 subirles el precio 1�
update Libros
set Precio = Precio + 1
where Editorial = 1
-- A todos los libros de la editorial 1 subirles un 10% el precio
update Libros
set Precio = Precio * 1.1
where Editorial = 1
-- Cambiar el c�digo de la editorial 1 por el 3
update Editoriales
set Cod_ed = '3'
where Cod_ed = '1'
-- Listar los clientes de A Coru�a
select  * from clientes
where Provincia = 'A Coru�a'
-- Listar los t�tulos de los libros de la editorial Anaya
select T�tulo, Nombre
from libros l
inner join Editoriales e on l.editorial = e.cod_ed
where Nombre = 'Anaya'
-- Listar T�tulo, Nombre de la editorial, Fecha del pedido, Num_ejemplares de todos los libros pedidos despues del 1-1-2020
select T�tulo, Nombre, Fecha, Num_ej
from Libros l
inner join Editoriales e on l.Editorial = e.cod_ed
inner join Detalle_pedidos dp on l.cod_lib = dp.cod_lib
inner join Pedidos p on p.num_ped = dp.num_ped
where Fecha > '1-1-2020'
-- T�tulo de todos los libros vendidos este mes.
select distinct T�tulo
from Libros l
inner join Detalle_Pedidos dp on dp.cod_lib=l.cod_lib
inner join Pedidos p on p.num_ped=dp.num_ped
where month(Fecha) = month(getdate()) and year(Fecha) = year(getdate())
-- Nombre y apellidos de todos los clientes de A Coru�a que han realizado alg�n pedido este a�o
select distinct Nombre, Apellidos
from Clientes c
inner join Pedidos p on p.cod_cli=c.cod_cli
where year(getdate()) = year (fecha) and Provincia = 'A Coru�a'
-- T�tulo de todos los libros comprados por clientes gallegos este a�o
select distinct T�tulo
from Libros l
inner join Detalle_pedidos dp on dp.cod_lib = l.cod_lib
inner join Pedidos p on p.num_ped = dp.num_ped
inner join Clientes c on p.cod_cli = c.cod_cli
where year(fecha) = year(getdate()) and Provincia in ('A Coru�a', 'Lugo', 'Ourense', 'Pontevedra')
-- Nombre, Apellidos y tel�fono de los clientes que no son gallegos
select distinct Nombre, Apellidos, Tel�fono
from Clientes
where Provincia not in ('A Coru�a', 'Pontevedra', 'Lugo', 'Ourense')
-- Ventas de los �ltimos 15 d�as: Nombre y Apellidos del cliente, T�tulo y Nombre de la editorial
select distinct c.Nombre, Apellidos, T�tulo, e.Nombre Editorial
from Clientes c
inner join Pedidos p on p.cod_cli = c.cod_cli
inner join Detalle_Pedidos dp on dp.num_ped = p.num_ped
inner join Libros l on l.cod_lib = dp.cod_lib
inner join Editoriales e on e.cod_ed = l.editorial
where fecha>getdate()-15
-- Recucir el precio en 5� a todos los libros de los que tengo un stock superior a 10 y con un precio entre 15 y 35�
update Libros
set Precio = Precio - 5
where Stock > 10 and Precio between 15 and 35
-- Listar T�tulo de todos los libros de Anaya y Rama de los que tengo un stock por debajo de 5 unidades
select T�tulo
from Libros l
inner join Editoriales e on l.editorial = e.cod_ed
where Nombre in ('Anaya', 'Rama') and Stock < 5
-- Nombre y Apellidos de los clientes que hayan hecho alg�n pedido en 2018, 2019 o 2020.
select distinct Nombre, Apellidos
from Clientes c
inner join Pedidos p on p.cod_cli = c.cod_cli
where year(fecha) in ('2018', '2019', '2020')