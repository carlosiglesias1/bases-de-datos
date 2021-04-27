-- listar proyectos
select * from proyectos
-- insertar nuevo proyecto
insert into Proyectos
values ('9', 'pulpo', 3600)
-- listar investigadores
select * from Investigadores
-- insertar un nuevo investigador
insert into Investigadores
values ('12345678A', 'Carlos', 'Pérez', '697562397', '9')
-- inserción de datos pero no en todas las columnas
insert into investigadores (DNI,Nombre,Apellidos, Codigo)
values ('12345678Z', 'Antón', 'López', '9')
--Borrar proyectos con presupuesto entre 100 y 2000€
select * from Proyectos
insert into Proyectos
values ('3', 'Prueba',1560)
delete from Proyectos
where proyectos.Presupuesto >= 100 and Proyectos.Presupuesto <= 2000
-- delete from proyectos
-- where presupuesto between 100 and 2000