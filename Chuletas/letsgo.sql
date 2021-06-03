use Taller;
go
--1)Matricula, marca, modelo, telefono del propietario, de 
--los coches de clientes gallegos
--que han entrado en taller en el dia de hoy
select c.matricula, c.marca, c.modelo, cli.telefono as 'Teléfono del propietario'
	from Cliente cli inner join Coche c on cli.dni = c.dueño
	inner join Entrada e on e.coche = c.matricula
	where cli.provincia in ('A Coruña', 'Pontevedra','Lugo', 'Ourense')
		and fecha = convert(date,GETDATE());
go

--2)Codigo y nombre del recambio mas utilizado en los 
--ultimos 60 dias
select top 1 r.codigo, r.nombre
	from Recambio r inner join PiezasUsadas p on r.codigo = p.recambio
		inner join Operaciones op on p.ordenOperacion = p.ordenOperacion
		inner join Entrada e on e.numero = op.numero
	where e.fecha >= getdate()-60
	group by r.codigo, r.nombre
	order by SUM (p.cantidad) desc
go

--3)Reducir un 10% el precio a todos los recambios que no 
--se hayan utilizado nunca y cuyo precio sea superior a la 
--media
update Recambio
	set precio *= 0.9
	where precio > (select AVG (precio) from Recambio)
		and codigo not in (select distinct codigo from PiezasUsadas);
go

--4)Reducir el importe de aquellos coches que mas han 
--venido este año al taller
--Si han venido mas de 5 veces, un 10%
-- Mas de 3 veces, un 5%
-- Los demas, nada
update Entrada
	set importe *= case
		when coche in (select distinct COUNT(coche) from Entrada 
							group by coche 
							having COUNT(coche)> 5) then 0.9
		when coche in (select distinct COUNT(coche) from Entrada 
							group by coche 
							having COUNT(coche)> 3) then 0.95
		else 1
	end
	where year(fecha) = year(GETDATE())
go

--5)Guardar en la tabla Operaciones_año, el nombre y 
--telefono de cada cliente, matricula del coche,
--fecha de entrada, importe de todas las entradas del año 
--en curso en orden por la fecha

select cli.nombre, cli.telefono, c.matricula, e.fecha, e.importe into Operaciones_año
	from Cliente cli join Coche c on cli.dni = c.dueño
		join Entrada e on e.coche = c.matricula
	where year(e.fecha) = YEAR(getdate())
	order by e.fecha desc;
go

select * from Operaciones_año;
go
--6)Eliminar todos los recambios que no se hayan utilizado 
--nunca y que tengan un precio superior a la media
delete from Recambio
	where codigo not in (select distinct recambio from PiezasUsadas)
		and precio > (select avg(precio) from Recambio);
go

--7)Listar nombre y tel�fono del cliente, matr�cula del 
--coche en orden descendente del n� de entradas,
--de cada coche, en este a�o
select cli.nombre, cli.telefono, c.matricula
	from Cliente cli join Coche c on c.dueño = cli.dni
	join Entrada e on e.coche = c.matricula
	where year(e.fecha) = YEAR(getdate())
	group by cli.nombre, cli.telefono, c.matricula
	order by COUNT(e.coche) desc
go

--8)Rutina que liste la matricula de los coches que han 
--entrado en el taller entre 2 fechas( preguntar si la 
--rutina existe )
--Ejecutala
if exists (select * from sysobjects where name = 'listarMatriculas')
	drop proc listarMatriculas;
go
create proc listarMatriculas @fechaInicio date, @fechaFin date
	as
		select distinct coche
			from Entrada
			where fecha between @fechaInicio and @fechaFin;
go

exec listarMatriculas '2000-02-09', '2022-05-09';
go

--9)Incorporar a la base de datos, la siguiente 
--restriccion:
--Comprobar que cuando registro una operacion, el aprendiz 
--y el especialista de la misma, son realmente de ese tipo
if exists (select * from sysobjects where name = 'checkOperarios')
	drop trigger checkOperarios
go
create trigger checkOperarios on Operaciones after insert, delete, update
as
	if not exists (select dni from Operario where dni = (select operario from inserted) and tipo = 'Operario')
		begin
			print ('Aprendiz introducido incorrectamente');
			rollback
		end
	if not exists (select dni from Operario where dni = (select especialista from inserted) and tipo = 'Especialista')
		begin
			print ('Especialista introducido incorrectamente');
			rollback
		end
go
--10)Rutina que incremente el precio de los recambios 
--utilizados en alguna operacion de este año,
--en la cantidad que le indiquemos,
--mientras el valor total de los stocks no supere los 3000€
if exists (select * from sysobjects where name = 'updateRecambiosAño')
	drop proc updateRecambiosAño;
go
create proc updateRecambiosAño @cantidad smallint
as
	while (select SUM(precio) from Recambio) < 3000
	begin
		update Recambio
			set precio += @cantidad
			where codigo in (select recambio from PiezasUsadas);
	end
go

exec updateRecambiosAño 12;

select * from PiezasUsadas;
select * from Recambio;
go
--Desencadenador que actualice el stock de un libro 
--cada vez que se vende
use Libreria;
if exists (select * from sysobjects where name = 'updateStock')
	drop trigger updateStock;
go
create trigger updateStock on Detalle_pedidos after insert
as	
	if(select stock from Libros where Cod_lib = (select Cod_lib from inserted))>(select Num_ej from inserted)
		update Libros
			set Stock -= (select num_ej from inserted)
			where Cod_lib = (select Cod_lib from inserted)
	else
		begin
			raiserror('No hai suficientes Libros', 16, 1);
			rollback
		end;
go

--Desencadenador que actualice el stock en caso 
--de anulacion de 1 libro de 1 pedido
if exists (select * from sysobjects where name = 'checkDeleted')
	drop trigger checkDeleted;
go
create trigger checkDeleted on Detalle_Pedidos after delete
as
	update Libros
		set Stock += (select num_ej from deleted)
			where Cod_lib = (select Cod_lib from deleted)
go

select * from Libros;
go
delete from Detalle_pedidos;
go
select * from Libros;
go
--Desencadenador que actualice el stock en caso 
--de modificar el numero de jemplares pedidos de 
--un libro
if exists (select * from sysobjects 
	where name = 'checkUpdatePedido')
	drop trigger checkUpdatePedido;
go
create trigger checkUpdatePedido 
on Detalle_Pedidos after update
as
	if(select stock from Libros 
		where Cod_lib = (select Cod_lib from inserted))
		+(select num_ej from deleted)>=
		(select num_ej from inserted)
		update Libros
			set Stock = Stock
				+(select num_ej from deleted)
				-(select num_ej from inserted)
			where Cod_lib = (select Cod_lib from inserted)
	else 
		raiserror('No hay stock',16,1);
go

insert into Detalle_pedidos
	values ('001', '035', 2);
go
update Detalle_pedidos
	set Num_ej =Num_ej - 1
	where Cod_lib = '035';
go
select * from Detalle_pedidos;
go
select * from Libros;
go
--Desencadenador que calcule la columna total de 
--cada pedido
if exists (select * from sysobjects where name = 'totalPedido')
	drop trigger totalPedido;
go
create trigger totalPedido on Detalle_Pedidos after insert, update, delete
as
	update pedidos
	set total=total+((select num_ej from inserted)*
		(select precio from libros where cod_lib=
				(select cod_lib from inserted)))
	where num_ped=(select num_ped from inserted)
go

delete from Detalle_pedidos
	where Cod_lib = '032'
go
insert into Detalle_pedidos
	values ('001', '032', 2)
go
select * from Pedidos;
go
select total from Pedidos;
go