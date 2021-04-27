-- Nombre y Apellidos del profesor y fechas de contrato
select Nombre, Apellidos, fecha_i, fecha_f
from Profesores p
inner join contratos c on p.dni = c.dni
-- Nombre y Apellidos del profesor, Nombre del centro y fecha de contrato.
select p.Nombre, Apellidos, c.Nombre, fecha_i, fecha_f
from Profesores p
inner join contratos co on p.dni = co.dni
inner join Centros c on c.Código = co.Código