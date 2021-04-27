--T�tulo del libro m�s vendido del mes
use Libreria;
go
select top 1 li.T�tulo
from Libros li join Detalle_pedidos det on det.Cod_lib=li.Cod_lib
join Pedidos p on p.Num_ped=det.Num_ped
where MONTH(p.Fecha)=MONTH(getdate()) and YEAR(p.Fecha)=YEAR(getdate())
group by li.T�tulo
order by sum(Num_ej) desc;
go

--T�tulo que gener� m�s ingresos este a�o

select top 1 li.T�tulo
from Libros li join Detalle_pedidos det on det.Cod_lib=li.Cod_lib
join Pedidos p on p.Num_ped=det.Num_ped
where YEAR(p.Fecha)=year(getdate())
group by li.T�tulo
order by SUM(det.Num_ej*li.Precio)desc;
go
