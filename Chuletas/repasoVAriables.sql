--Guardar en variables locales, el precio m�ximo, 
--el m�nimo y el medio de los libros
--y luego listarlos
use Libreria;
go

DECLARE @maxPrice money, @minPrice money, @avgPrice money;
SELECT @maxPrice = MAX(precio)
FROM libro;
SELECT @minPrice = MIN(precio)
FROM libro;
SELECT @avgPrice = AVG(precio)
from libro;

SELECT @maxPrice as Maximo, @minPrice as minimo, @avgPrice as medio;
GO
--Guardar en una variable local una fecha y listar 
--el nº de todos los pedidos realizados con 
--posterioridad a la misma
use Libreria;
GO
DECLARE @limitDate DATE;
set @limitDate = CONVERT(date, '09-02-2000');

select num_pedido
from pedido
where fecha > @limitDate;
GO
--Guardar en 2 variables el nº de libros(titulos) 
--de Anaya y el precio medio de los mismos.
--Listar nombre de las editoriales de las que tengo
--mas libros que Anaya y cuyo precio medio supere 
--al de Anaya
use Libreria;
go
DECLARE @librosAnaya SMALLINT;
select @librosAnaya = COUNT(*)
from libro
where cod_ed = (select cod_ed
from editorial
where nombre = 'Anaya');
DECLARE @avgAnaya SMALLMONEY;
select @avgAnaya = AVG(precio)
from libro
WHERE cod_ed = (select cod_ed
from editorial
where nombre = 'Anaya');

select @librosAnaya as librosAnaya, @avgAnaya as precioMedio;
go
select *
from libro;
select *
from editorial;
--Guardar en una variable un nº y en otra el 
--precio medio de los libros.
--Listar titulo de los libros de precio superior a 
--la media de los que he vendido mas ejemplares que 
--el nº guardado, en los ultimos 7 dias
use Libreria;
go
DECLARE @totalLibros SMALLINT, @precioMedio SMALLMONEY;
set @totalLibros = 2;
SELECT @precioMedio = AVG(precio) from libro;

select l.titulo from libro l JOIN pedido_detalle det on det.cod_lib = l.cod_lib
        JOIN pedido p on det.num_pedido = p.num_pedido
    WHERE l.precio > @precioMedio and p.fecha >= GETDATE()-7
    GROUP by l.titulo
    HAVING SUM(det.num_ej)> @totalLibros;
GO
