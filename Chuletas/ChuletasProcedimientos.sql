/*

	create proc nombre (@parametros tipo_dato)
	as
		//cuerpo procedimiento
	go

	Para ejecutarlo
		exec nombre [valores parametros]
*/

--procedimiento para incrementar el precio de los libros un 5%
use Libreria;
go
if exists(select * from sysobjects
			where name = 'subirPrecio')
	drop proc dbo.subirPrecio;
go

create proc subirPrecio
as 
	update libros
		set precio *= 1.05
go

exec subirPrecio;
go
--rutina que compruebe si el precio medio de una editorial 
--esta por encima de la media de todos los libros
--en caso afirmativo, reduzca un 10% los precios de todos los libros
--de esa editorial
if exists(select * from sysobjects
			where name = 'comprobarPreciosEdis')
	drop proc dbo.comprobarPreciosEdis;
go

create proc comprobarPreciosEdis (@Cod_ed char (3))
as
	declare @avgEditorial smallmoney;
	select @avgEditorial = avg(precio) from Libros where Editorial = @Cod_ed;
	if @avgEditorial > (select AVG(precio) from Libros)
		update Libros
			set precio *= 0.9
				where Editorial = @Cod_ed
go

exec comprobarPreciosEdis[2];
go
--Rutina que permita modificar los precios de los
--libros de una editorial
if exists (select * from sysobjects
			where name = 'modificarPrecios')
		drop proc modificarPrecios;
go

create proc modificarPrecios (@Cod_ed char (3), @opcion char (4), @cantidad money)
as
	if @opcion = 'stup'
		update Libros
			set Precio += @cantidad
			where Editorial = @Cod_ed
	else if @opcion = 'stdown'
		update Libros
			set Precio -= @cantidad
			where Editorial = @Cod_ed
	else
		print 'Algo ha ido mal'
go

exec modificarPrecios 2, stup, 5;
go

--reducir el precio de los libros en funcion del total  de ejemplares vendidos
--en los ultimos 30 dias
--Si se vendieron mas de 30 ejemplares, en un 2%
--mas de 20, un 5%
-- los demas un 10%
if exists (select * from sysobjects
			where name = 'updateInCaseSoldExemplars')
		drop proc updateInCaseSoldExemplars;
go

create proc updateInCaseSoldExemplars
as
	declare @totalVendidosMes int;
	select @totalVendidosMes = dbo.librosMes();
	update Libros
		set Precio *= case
			when @totalVendidosMes > 30 then 0.98
			when @totalVendidosMes between 20 and 30 then 0.95
			else 0.9   
		end
go

select dbo.librosMes();
go
exec updateInCaseSoldExemplars;
go
--Reducir el precio de los libros de sql en funcion de la editorial
--si son de Anaya en un 10%
--de Rama en un 5%
--los demas no modificarlos
if exists(select * from sysobjects
			where name = 'getNameEd')
	drop function dbo.getNameEd;
go
create function getNameEd (@codEd char (3)) returns char (31)
as
begin
	return (select top 1 nombre from Editoriales where Cod_ed = @codEd)
end
go

if exists(select * from sysobjects
			where name = 'updateinCaseEd')
	drop proc dbo.updateinCaseEd;
go
create proc updateinCaseEd 
as
	update Libros
		set Precio *= case
			when (select dbo.getNameEd(Editorial))='Anaya' then 0.9
			when (select dbo.getNameEd(Editorial))= 'Rama' then 0.95
			else 1
		end
		where Titulo like ('%SQL%');
go

exec updateinCaseEd;
go
--Mientras el precio minimo de los libros de una editorial no baje de 10�
--reducir el precio de sus libros en un 2%, si despues de la 1� interacci�n 
--el precio medio baja de 25�, que pare
if exists(select * from sysobjects
			where name = 'dropPriceEd')
	drop proc dbo.dropPriceEd;
go

create proc dropPriceEd (@Editorial char (30))
as
	declare @codEd char (3)
	select @codEd = cod_ed from Editoriales where Nombre = 'Anaya';
	while (select MIN(Precio) from Libros where Editorial = @codEd) > 10
	begin
		update Libros
			set Precio *= 0.98;
		if((select AVG(Precio) from Libros where Editorial = @codEd)<25)
			break;
	end
go

exec dropPriceEd 'Anaya';
go

select * from Libros where Editorial = (select cod_ed from Editoriales where Nombre = 'Anaya');
go
--Procedimiento que cree la tabla mejores_clientes con el dni, nombre y apellidos de los 10
--mejores clientes del mes
if exists(select * from sysobjects
			where name = 'getBestClients')
	drop proc dbo.getBestClients;
go

create proc getBestClients 
as
	if exists (select * from sysobjects
					where name = 'Mejores_Clientes')
		drop table Mejores_Clientes
	select top 10 c.dni, c.nombre, c.apellidos into Mejores_Clientes
		from Clientes c join 
		Pedidos p on p.Cod_cli = c.Cod_cli
		join Detalle_pedidos det on p.Num_ped = det.Num_ped
		join Libros l on l.Cod_lib = det.Cod_lib
		where MONTH(p.fecha) = MONTH(getdate()) and YEAR(p.fecha) = YEAR(getdate())
		group by c.DNI, c.Nombre, c.Apellidos
		order by SUM(l.Precio * det.Num_ej)	
go

exec getBestClients;
go
