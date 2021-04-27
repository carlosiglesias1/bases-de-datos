--guardar en pedidos_mes nombre y apellidos del cliente, numero de pedido y fecha e importe total de los pedidos
use Libreria;
select nombre, Apellidos, p.Num_ped, fecha, sum(precio*num_ej) 'Total' into Pedidos_mes
from Clientes c 
	join Pedidos p on c.Cod_cli = p.Cod_cli
	join Detalle_pedidos det on p.Num_ped = det.Num_ped
	join Libros l on l.Cod_lib = det.Cod_lib
where month(fecha) = MONTH(getdate())
	and year(fecha) = year(getdate())
group by Nombre, Apellidos, p.Num_ped, Fecha;
go
