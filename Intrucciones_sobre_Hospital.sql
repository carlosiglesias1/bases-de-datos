-- Nombre de los pacientes ingresados por el médico 2 en los últimos 15 días.
select Nombre
from Pacientes p
inner join Ingresos i on p.num_historia = i.num_historia
where médico = 2 and f_ingreso >= getdate() - 15
-- Nombre y seguro de pacientes ingresados en traumatología y pediatría en el día de hoy
select p.Nombre, Seguro
from Pacientes p
inner join Ingresos i on p.num_historia = i.num_historia
inner join Servicios s on s.código = i.servicio
where f_ingreso = getdate() and s.nombre in ('Pediatría', 'Traumatología')
-- Comprobar que el nombre del servicio sea Traumatología, Pediatría o Oftalmología
alter table Servicios
add constraint CK_Nombre
check (Nombre in ('Pediatría', 'Traumatología', 'Oftalmología'))