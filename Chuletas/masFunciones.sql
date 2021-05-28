--Función que devuelva el total ingresado por una 
--editorial entre 2 fechas
if exists(select * from sysobjects
			where name = 'totalEditorial')
	drop function dbo.totalEditorial;
go

create function totalEditorial (@editorial char (40), @fecha1 date, @fecha2 date) returns money
as
begin
	return(
		select SUM(det.Num_ej*l.precio)
			from Detalle_pedidos det
				join Libros l on l.Cod_lib = det.Cod_lib
				join Pedidos p on p.Num_ped = det.Num_ped
				join Editoriales ed on l.Editorial = ed.Cod_ed 
			where (p.Fecha between @fecha1 and @fecha2) and (ed.Nombre = @editorial)
	);
end
go

select dbo.totalEditorial('Anaya', GETDATE(), getdate());
go

--nombre, apellidos, numero del pedido, fecha, e importe
--de todos los pedidos del mes en curso
if exists (select * from sysobjects
			where name = 'getPedidosMes')
	drop function dbo.getPedidosMes;
go

create function getPedidosMes () returns table
as
	return (
		select cli.nombre, cli.apellidos, p.num_Ped, p.fecha, SUM(det.num_ej*l.precio) as 'Importe pedido'
			from Clientes cli join 
				Pedidos p on p.Cod_cli = cli.Cod_cli
				join Detalle_pedidos det on p.Num_ped = det.Num_ped
				join Libros l on l.Cod_lib = det.Cod_lib
			where month(p.Fecha) = MONTH(getdate()) and YEAR(p.Fecha) = YEAR(getdate())
			group by cli.Nombre, cli.Apellidos, p.Num_ped, p.Fecha);
go

select * from dbo.getPedidosMes();
go

--funcion que calcula el precio medio de los libros
create function media () returns money
as
	begin
		return(select AVG(precio) from Libros);
	end
go
--Funcion que liste los titulos de los libros que superan la media
create function mayorQueMedia ()  returns table
as
		return 
		(
			select Título 
			from Libros
				where Precio > dbo.media() 	
		);
go

select * from dbo.mayorQueMedia();
go

--Editoriales de las que he tenido más ingresos en el dia de hoy que una concreta
if exists (select * from sysobjects
			where name = 'comprobarIngresosMayores')
	drop function dbo.comprobarIngresosMayores;
go 
create function comprobarIngresosMayores (@editorial char (40)) returns table
as
	return
		(
			select ed.nombre as 'Editorial'
				from Editoriales ed
				where dbo.totalEditorial(ed.Nombre, GETDATE(), getdate()) > dbo.totalEditorial (@editorial, GETDATE(),getdate())
		);
go

select * from comprobarIngresosMayores('Rama');
go

select dbo.totalEditorial('Rama', getdate(),getdate());
go