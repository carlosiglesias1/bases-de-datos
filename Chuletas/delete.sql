-- Listar ciclistas
select * from ciclistas
-- Insertar un nuevo ciclista
insert into ciclistas
values ('12344567A', 'Clara', 'Campos', 'NTT')
-- Borrar el ciclista que acabamos de crear
delete from ciclistas
where equipo='NTT'
-- Borrar las vueltas que empiecen en Barcelona y recorran mas de 4000km
select * from vueltas
insert into vueltas
values ('2021', 'Barcelona', '4-4-2021', 'Málaga', '5-5-2021', 4050)
delete from vueltas
where vueltas.Ciudad_de_salida='Barcelona' and vueltas.Km_totales > 4000