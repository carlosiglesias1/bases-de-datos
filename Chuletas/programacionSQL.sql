/* Condicionales:

**IF
	IF Condici�n
		Sentecia
	ELSE
		Sentencia
Cuando hay m�s de 1 sentecia a ejecutar,
el bloque de sentencias se escribe entre
	BEGIN......END

	IF Condici�n
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

--Si hay m�s de 3 libros de anaya de precio > 50,
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

--Si el precio medio de los libros supera los 50�
--reducir un 10% y eliminar los que no se han vendido nunca
--y si supera los 30�, reducir un 5%

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

--Si el precio medio de los libros de anaya supera en m�s de 15�
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
-- precio alto cuando el precio alto cuando el precio esta por encima de 100�
--precio medio si est� por encima de 50� y precio bajo por debajo de 50�

select Titulo, 'Tipo'= case 
				when precio > 50 then 'Precio alto'
				when precio > 30 then 'Precio medio'
				else 'Precio bajo'
				end
from Libros;


--listar nombre y apellidos de los clientes y la columna categoria que mostrara
--1 si el cliente ha gastado m�s de 600� en los �ltimos 30 d�as,
--2 si el gasto estubo entre 150 y 300
--3 por debajo de esa cifra
select nombre, apellidos, SUM(l.Precio*det.Num_ej) as 'precio total'
	from Clientes c join Pedidos p on p.Cod_cli = c.Cod_cli
	join Detalle_pedidos det on det.Num_ped = p.Num_ped
	join Libros l on det.Cod_lib = l.Cod_lib
group by Nombre, Apellidos;
go
select nombre, apellidos, 'categoria' = case
							when SUM(precio *num_ej) > 300 then '1'
							when SUM(precio * num_ej) >= 150 then '2'
							else '3'
							end
from Clientes c join Pedidos p on p.Cod_cli = c.Cod_cli
	join Detalle_pedidos det on det.Num_ped = p.Num_ped
	join Libros l on det.Cod_lib = l.Cod_lib
where p.Fecha >= GETDATE()-30
group by Nombre, Apellidos;
go
--Rebajar el precio de los libros
--Si son de Anaya en un 10%
--Si son de Rama en un 8%, los dem�s en nun 5%
update Libros
	set Precio = case
		when nombre = 'Anaya' then Precio * 0.9
		when nombre = 'Rama' then Precio * 0.92
		else Precio *0.95
		end
	from Libros l join Editoriales ed on ed.Cod_ed = l.Editorial; 
go
--modificar el c�digo postal de los clientes.
--Si son de A Coru�a ponerles 15001,
--de pontevedra 36001,
--de Lugo 27001, de ourense 32001, al resto null
update Clientes
	set CP = case 
		when Provincia = 'A Coru�a' then '15001'
		when Provincia = 'Pontevedra' then '36001'
		when Provincia = 'Lugo' then '27001'
		when Provincia = 'Ourense' then '32001'
		else 'null'
	end;
go

--Reducir el precio de los libros de Anaya de
--precio superior a la media
--Si tengo mas de 15 ejemplares en stock, en un 10%
--si tengo entre 10 y 15 en un 8%
--Los dem�s no modificarlos
declare @avgprecio money;
select @avgprecio = AVG(precio) from Libros;

update Libros
	 set Precio *= case 
		when Stock > 15 then 0.9
		when Stock > 10 and Stock < 15 then 0.92
		else 1
	end
	where Editorial = (select cod_ed
							from Editoriales
							where Nombre = 'Anaya') and Precio> @avgprecio;
go

--Nombre de las editoriales cuyo precio medio supera los 50�
select nombre 
	from Editoriales ed join Libros l on l.Editorial = ed.Cod_ed
	group by ed.Nombre
	having SUM(l.precio)>50
go

--reducir el precio de los libros vendidos en los ultimos 100 d�as
--si se vendieron �s de 10 ejemplares, un 10%
--si se vendieron m�s de 5 ejemplares, un 5%
update Libros
	set Precio *= case
		when (select SUM(num_ej) from Detalle_pedidos group by Cod_lib) > 10 then 0.9
		when (select SUM(num_ej) from Detalle_pedidos group by Cod_lib) between 5 and 10 then 0.95
		else 1
	end
	from Libros l join Detalle_pedidos det on l.Cod_lib = det.Cod_lib
		join Pedidos p on det.Num_ped = p.Num_ped
	where p.Fecha >= GETDATE()-100;