-- Nombre de los pacientes ingresados por el m�dico 2 en los �ltimos 15 d�as.
select Nombre
from Pacientes p
inner join Ingresos i on p.num_historia = i.num_historia
where m�dico = 2 and f_ingreso >= getdate() - 15
-- Nombre y seguro de pacientes ingresados en traumatolog�a y pediatr�a en el d�a de hoy
select p.Nombre, Seguro
from Pacientes p
inner join Ingresos i on p.num_historia = i.num_historia
inner join Servicios s on s.c�digo = i.servicio
where f_ingreso = getdate() and s.nombre in ('Pediatr�a', 'Traumatolog�a')
-- Comprobar que el nombre del servicio sea Traumatolog�a, Pediatr�a o Oftalmolog�a
alter table Servicios
add constraint CK_Nombre
check (Nombre in ('Pediatr�a', 'Traumatolog�a', 'Oftalmolog�a'))