
--Nombre y apellidos de los investigadores de la base de datos "Proyectos"--
use Proyectos;
go
select nombre, apellidos
from dbo.inv;
go

--Todos los datos de la tabla proyectos -> "Todos los campos/columnas de la tabla 'pro'"
use Proyectos;
go
select *
from dbo.pro;
go

--Nombre y apellidos del investigador y nombre del proyecto en el que trabaja--
use Proyectos;
go
select i.nombre, i.apellidos, p.nombre
from dbo.inv i join dbo.pro p on i.pro=p.cod_pro;
go

--Nombre y fases de un proyecto, con fecha de inicio y fin
use Proyectos;
go
select p.nombre, f.num_fase, f.fecha_ini, f.fecha_fin
from dbo.pro p join dbo.fase f on p.cod_pro=f.cod_pro;
go
