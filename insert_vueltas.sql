-- Insertar un nuevo Ciclista
select * from ciclistas
insert into ciclistas
values ('12345678J', 'Martín', 'Roxo', 'Vodafone')
-- Insertar un nuevo Equipo solo con Nombre
select * from equipos
insert into equipos (Nombre)
values ('NTT')
-- Insertar una nueva vuelta
select * from vueltas
insert into vueltas
values ('2020', 'A Coruña', '1-1-2020', 'Murcia', '5-3-2020', 4659)