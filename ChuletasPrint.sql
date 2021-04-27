print 'Hoy es '+ convert (char(25), getdate());


/*
*Si la media del precio de los libros supera los 60€
*imprimir por pantalla Media Alta, sino imprimir Media Baja.
*Usar print y raiserror.
*/
if (select AVG(precio) from Libros) > 60
	print 'Media Alta'
else
	print 'Media Baja';
go

if (select AVG(precio) from Libros) > 60
	raiserror ('Media Alta', 5, 1);
else
	raiserror ('Media Baja',5, 1);
go

select * from sysmessages
	where msglangid = '3082';
go

--calcular el total de ejemplares vendidos hoy
--visualizar 'no se ha vendido nada'
--o visualizar 'se han vendido n libros' siendo n el número de libros vendidos
declare @cuentaLibros int;
--Para ver esta cuenta, mirar la chuleta de funciones
select @cuentaLibros = dbo.cuentaLibros();

if @cuentaLibros is not null
	begin
		if @cuentaLibros > 1
			print 'Se han vendido '+ @cuentaLibros +' libros'
		else
			print 'Se ha vendido 1 libro'
	end
else
	print 'No se ha vendido nada';
go
