-- Listado de los ciclistas
use vuelta
go
select * from ciclistas
-- Nombre y Apellidos de los ciclistas
use vuelta
go
select Nombre, Apellidos from ciclistas
-- Nombre y Apellidos del ciclista y Nombre y Nacionalidad del equipo
use vuelta
go
select c.Nombre, Apellidos, e.Nombre, Nacionalidad
from ciclistas c
inner join equipos e on c.Equipo = e.nombre
-- Nombre, Apellidos, Equipo y Etapas que hizo cada ciclista con tiempos obtenidos.
use vuelta
go
select Nombre, Apellidos, Equipo, Año, Nº_etapa, Horas, Minutos, Segundos
from ciclistas c
inner join participa p on c.Dni = p.Dni