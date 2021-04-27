-- Poner a todos los clientes el CP 15000
update Clientes
set CP = 15000
-- Poner a todos los clientes de A Coruña el código 15009
update Clientes
set CP = 15009
where Provincia = 'A Coruña'
-- A todos los libros de la editorial 1 subirles el precio 1€
update Libros
set Precio = Precio + 1
where Editorial = 1
-- A todos los libros de la editorial 1 subirles un 10% el precio
update Libros
set Precio = Precio * 1.1
where Editorial = 1
-- Cambiar el código de la editorial 1 por el 3
update Editoriales
set Cod_ed = '3'
where Cod_ed = '1'
-- Listar los clientes de A Coruña
select  * from clientes
where Provincia = 'A Coruña'
-- Listar los títulos de los libros de la editorial Anaya
select Título, Nombre
from libros l
inner join Editoriales e on l.editorial = e.cod_ed
where Nombre = 'Anaya'
-- Listar Título, Nombre de la editorial, Fecha del pedido, Num_ejemplares de todos los libros pedidos despues del 1-1-2020
select Título, Nombre, Fecha, Num_ej
from Libros l
inner join Editoriales e on l.Editorial = e.cod_ed
inner join Detalle_pedidos dp on l.cod_lib = dp.cod_lib
inner join Pedidos p on p.num_ped = dp.num_ped
where Fecha > '1-1-2020'
-- Título de todos los libros vendidos este mes.
select distinct Título
from Libros l
inner join Detalle_Pedidos dp on dp.cod_lib=l.cod_lib
inner join Pedidos p on p.num_ped=dp.num_ped
where month(Fecha) = month(getdate()) and year(Fecha) = year(getdate())
-- Nombre y apellidos de todos los clientes de A Coruña que han realizado algún pedido este año
select distinct Nombre, Apellidos
from Clientes c
inner join Pedidos p on p.cod_cli=c.cod_cli
where year(getdate()) = year (fecha) and Provincia = 'A Coruña'
-- Título de todos los libros comprados por clientes gallegos este año
select distinct Título
from Libros l
inner join Detalle_pedidos dp on dp.cod_lib = l.cod_lib
inner join Pedidos p on p.num_ped = dp.num_ped
inner join Clientes c on p.cod_cli = c.cod_cli
where year(fecha) = year(getdate()) and Provincia in ('A Coruña', 'Lugo', 'Ourense', 'Pontevedra')
-- Nombre, Apellidos y teléfono de los clientes que no son gallegos
select distinct Nombre, Apellidos, Teléfono
from Clientes
where Provincia not in ('A Coruña', 'Pontevedra', 'Lugo', 'Ourense')
-- Ventas de los últimos 15 días: Nombre y Apellidos del cliente, Título y Nombre de la editorial
select distinct c.Nombre, Apellidos, Título, e.Nombre Editorial
from Clientes c
inner join Pedidos p on p.cod_cli = c.cod_cli
inner join Detalle_Pedidos dp on dp.num_ped = p.num_ped
inner join Libros l on l.cod_lib = dp.cod_lib
inner join Editoriales e on e.cod_ed = l.editorial
where fecha>getdate()-15
-- Recucir el precio en 5€ a todos los libros de los que tengo un stock superior a 10 y con un precio entre 15 y 35€
update Libros
set Precio = Precio - 5
where Stock > 10 and Precio between 15 and 35
-- Listar Título de todos los libros de Anaya y Rama de los que tengo un stock por debajo de 5 unidades
select Título
from Libros l
inner join Editoriales e on l.editorial = e.cod_ed
where Nombre in ('Anaya', 'Rama') and Stock < 5
-- Nombre y Apellidos de los clientes que hayan hecho algún pedido en 2018, 2019 o 2020.
select distinct Nombre, Apellidos
from Clientes c
inner join Pedidos p on p.cod_cli = c.cod_cli
where year(fecha) in ('2018', '2019', '2020')