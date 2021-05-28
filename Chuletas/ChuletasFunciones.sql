if exists(select * from sysobjects
			where name = 'cuentaLibros')
	drop function dbo.cuentaLibros;
go

create function cuentaLibros () returns tinyint
as
begin
	return(
		select SUM(det.Num_ej)
			from Detalle_pedidos det
				join Pedidos p on p.Num_ped = det.Num_ped 
			where p.Fecha = GETDATE()
	);
end
go

select dbo.cuentaLibros()

if exists(select * from sysobjects
			where name = 'totalIngresos')
	drop function totalIngresos;
go

create function totalIngresos () returns money
as
begin
	return (
		select SUM(det.num_ej*l.precio) from Detalle_pedidos det
			join Pedidos p on p.Num_ped = det.Num_ped
			join Libros l on l.Cod_lib = det.Cod_lib
			where p.Fecha = GETDATE()
	)
end
go

select dbo.totalIngresos() as Total_Ingresos;
go

--Función que devuelva el total de ejemplares vendidos en el mes en curso
if exists (select * from sysobjects
				where name = 'librosMes')
	drop function librosMes;
go

create function librosMes () returns tinyint
as
	begin
		declare @sumEjemplares tinyint
		select @sumEjemplares = SUM(num_ej) from Detalle_pedidos det
				join Pedidos p on p.Num_ped = det.Num_ped
			where MONTH(p.fecha) = MONTH(getdate()) and year(p.Fecha) = year(GETDATE())
		
		declare @return tinyint
		if (@sumEjemplares is null)
			set @return = 0
		else
			set @return = @sumEjemplares
		return @return
end;
go

select dbo.librosMes() as 'Libros vendidos en todo el mes';
go
