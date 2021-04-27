use Libreria;
GO

/**
	Título de los libros de los que se vendieron 
	más de 5 ejemplares este año
*/
select Título
from libros l
    join Detalle_pedidos dp on dp.Cod_lib = l.Cod_lib
    join pedidos p on p.Num_ped = dp.Num_ped
where year(fecha) = year(getdate())
GROUP by Título
having sum(num_ej)>5;
GO

/*
Nombre y apellidos de los clientes de A Coruña que
han realizado más de 2 pedidos hoy
*/

select c.nombre, c.apellidos
from Clientes c 
	join pedidos p on c.cod_cli = p.cod_cli
where fecha = convert(date, getdate()) and c.provincia = 'A Coruña'
group by nombre, apellidos
having count(num_ped)>2;
go

/*
Número de pedido, fecha, nombre y apellidos del cliente,
de todos los pedidos de este año que hayan superado los 200€,
en orden de mayor a menor gasto
*/

select p.num_ped, p.fecha, c.nombre, c.apellidos
from Pedidos p join Clientes c on p.Cod_cli = c.Cod_cli
	join Detalle_pedidos det on p.Num_ped = det.Num_ped
	join Libros l on l.Cod_lib = det.Cod_lib
where year(fecha) = year(getdate())
group by p.Num_ped, p.Fecha, c.Nombre, c.Apellidos
having sum(l.precio * det.num_ej)>200
order by sum(l.Precio * det.Num_ej)desc;
go

/*
Nombre de las editoriales de las que tengo más de 10 ejemplares
en stock y he vendido mas de 5 ejemplares en stock en el día de hoy
*/

select ed.nombre
from Editoriales ed 
	join Libros l on l.Editorial = ed.Cod_ed
	join Detalle_pedidos det on l.Cod_lib = det.Cod_lib
	join Pedidos p on p.Num_ped = det.Num_ped
where p.Fecha = CONVERT(date,getdate())
group by ed.Nombre
having count(l.Stock)>10 and sum(det.num_ej)>5;
go

/*
Precio máximo, mínimo y medio de todos los libros
*/

select max(l.precio), min(l.precio), avg(l.precio)
from Libros l;
go
/*
Nombre de cada editorial, precio máximo, mínimo y medio
*/

select ed.nombre, max(l.precio) 'Libro más caro', min (l.precio)'Libro más barato', avg(l.precio) 'Precio medio'
from Editoriales ed
	join Libros l on l.Editorial = ed.Cod_ed
group by ed.Nombre;
go