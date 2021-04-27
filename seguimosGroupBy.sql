--Título del libro más vendido del mes
use Libreria;
go
select top 1 li.Título
from Libros li join Detalle_pedidos det on det.Cod_lib=li.Cod_lib
join Pedidos p on p.Num_ped=det.Num_ped
where MONTH(p.Fecha)=MONTH(getdate()) and YEAR(p.Fecha)=YEAR(getdate())
group by li.Título
order by sum(Num_ej) desc;
go

--Título que generó más ingresos este año

select top 1 li.Título
from Libros li join Detalle_pedidos det on det.Cod_lib=li.Cod_lib
join Pedidos p on p.Num_ped=det.Num_ped
where YEAR(p.Fecha)=year(getdate())
group by li.Título
order by SUM(det.Num_ej*li.Precio)desc;
go
