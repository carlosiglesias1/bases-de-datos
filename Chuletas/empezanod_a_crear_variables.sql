use Libreria
go
declare @media money
select @media=avg(Precio) from Libros
select @media

select Titulo
from Libros
where Precio > @media;
go

declare @num smallint;
set @num = 3;
select titulo
from Libros
where Stock > @num;
go

--guardar en variables locales el precio m�ximo, m�nimo y medio de los libros y luego listarlos

declare @max smallmoney
declare @min smallmoney
declare @avg smallmoney
select @max = max(precio) from Libros
select @min = min(precio) from Libros
select @avg = AVG(precio) from Libros
select @max as Maximo, @min as Minimo, @avg as Media;
go

--guardar en un a variable local una fecha y listar el n� de todos los pedidos 
--realizados con posterioridad a la misma
declare @mydate date
set @mydate = '2020-09-20'
select num_ped
from Pedidos
where Fecha > @mydate;
go


--guardar en 2 variables el n� de libros
-- de Anaya y el precio medio de los mismos.
--Listar nombre de las editoriales de las que tengo mas libros que 
--Anaya y cuyo precio medio supere al de Anaya
declare @libros smallint, @price smallmoney
select @libros = COUNT(*) from Libros l join Editoriales e on l.Editorial = e.Cod_ed 
			where e.Nombre = 'Anaya';
select @libros
select * from Libros;
select * from Editoriales
select @price = avg(precio) from Libros l join Editoriales e on l.Editorial = e.Cod_ed
			where e.Nombre = 'Anaya';
select @price

select e.Nombre
	from Editoriales e join Libros l on e.Cod_ed = l.Editorial 
	group by e.Nombre
	having COUNT(l.Cod_lib) > @libros and AVG(l.precio) > @price;

--Guardar en una variable un n� y en otra el precio
--medio de los libros.
--Listar titulo de los libros de precio superior a la media de los que he 
--vendido mas ejemplares que el n� guardado, en los �ltimos 7 dias
declare @dat smallint, @p_medio money
set @dat = 2
select @p_medio = avg (precio) from Libros
select Titulo
from Libros l
	inner  join Detalle_pedidos dp on l.Cod_lib = dp.Cod_lib
	inner join Pedidos p on p.Num_ped = dp.Num_ped
	where Precio > @p_medio and Fecha >= GETDATE()-7
	group by Titulo
	having sum(num_ej)>@dat;
go

