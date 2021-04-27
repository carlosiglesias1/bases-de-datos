/* Condicionales:

**IF
	IF Condición
		Sentecia
	ELSE
		Sentencia
Cuando hay más de 1 sentecia a ejecutar,
el bloque de sentencias se escribe entre
	BEGIN......END

	IF Condición
		BEGIN
			Sentencia 1
			Sentencia 2
			...
		END
	ELSE
		BEGIN
			...
		END
*/

if (select avg(precio) from Libros) > 50
	update Libros
		set Precio -= 5
else 
	select * from Libros

declare @medio money;
select @medio = avg(precio) from Libros;
if (@medio > 50)
begin
	update Libros
		set precio -= 5;
	end
else
	select * from Libros;
go

--Si hay más de 3 libros de anaya de precio > 50,
--reducirles el precio un 10% a los que superan 
--esa cifra
declare @counter int
select @counter = count(*) from Libros where Precio > 50 and Editorial = 3;

if (@counter > 3)
	begin
		update Libros
			set precio *= 0.9
			where Precio > 50 and Editorial = (select Cod_Ed
												from Editoriales
												where Nombre = 'Anaya');
		select * from Libros;
	end
else
	select * from Libros;

--Si el precio medio de los libros supera los 50€
--reducir un 10% y eliminar los que no se han vendido nunca
--y si supera los 30€, reducir un 5%

declare @avg smallmoney
select @avg = avg(precio) from Libros;

if (@avg > 50)
	begin
		update Libros
			set Precio *= 0.9;
		
		delete from Libros
			where Cod_lib not in (select Cod_lib
										from Detalle_pedidos);
	end
else
	begin
		if (@avg > 30)
			update Libros
				set Precio *=0.95;
		else
			select @avg as 'Precio medio';
	end

--Si el precio medio de los libros de anaya supera en más de 15€
--el precio de rama, reducir el precio de los libros de anaya un 10%
-- sino reducir un 5%

declare @precioAnaya smallmoney, @precioRama smallmoney;
select @precioAnaya = AVG(precio) from Libros where Editorial = (select Cod_ed
																	from Editoriales
																	where Nombre = 'Anaya');
select @precioRama = AVG(precio) from Libros where Editorial = (select Cod_ed
																	from Editoriales
																	where Nombre = 'Rama');

if (@precioAnaya - @precioRama = 15)
	update Libros
		set Precio *= 0.9
		where Editorial = (select cod_ed
							from Editoriales
							where Nombre = 'Anaya');
else
	update Libros
		set Precio *=0.95
		where Editorial = (select cod_ed
							from Editoriales
							where Nombre = 'Anaya');
select * from Libros;
select @precioAnaya as MediaAnaya, @precioRama as MediaRama;

--Listar titulo y una columna que visualice la palabra o la frase
-- precio alto cuando el precio alto cuando el precio esta por encima de 100€
--precio medio si está por encima de 50€ y precio bajo por debajo de 50€

select Título, 'Tipo'= case 
				when precio > 50 then 'Precio alto'
				when precio > 30 then 'Precio medio'
				else 'Precio bajo'
				end
from Libros;