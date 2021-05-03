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

exec updateInCaseSoldExemplars;