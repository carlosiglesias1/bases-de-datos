use Libreria;

go

select li.Título, li.Precio, sum(det.Num_ej) 'Ejemplares vendidos'
from Libros li join Detalle_pedidos det on li.Cod_lib=det.Cod_lib
join Pedidos p on p.Num_ped=det.Num_ped
where li.Título like 'SQL %' and p.Fecha>=GETDATE()-5
group by li.Título, li.Precio
order by SUM(det.Num_ej);