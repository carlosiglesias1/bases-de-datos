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
