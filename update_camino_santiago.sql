-- Incrementar 5 km a todos los caminos
update caminos
set km = km + 5

-- Incrementar 5 km el camino franc�s
update etapas
set km = km + 5
where nombre = 'Frances'

-- A�adir en la tabla etapas una nueva etapa del camino Frances
insert into Etapas
values ('Frances', '3', 23, '2', '4')

-- A este �ltima etapa modificar el n�mero de km a 30

update Etapas
set km = 30
where Nombre = 'Frances' and N�mero = '3'


select * from Etapas