--1)Matrícula, marca, modelo, teléfono del propietario, de --los coches de clientes gallegos 
--que han entrado en taller en el día de hoy

select Matrícula, marca, modelo, Teléfono
from Clientes c
    inner join Coches ch on c.DNI = ch.Dueño
    inner join Entradas e on ch.Matrícula = e.Coche
where Fecha = GETDATE() and Provincia in ('A Coruña','Ourense','Pontevedra','Lugo')

--2)Código y nombre del recambio mas utilizado en los --últimos 60 días

select top 1
    Código, Nombre
from Recambios r
    inner join Piezas_Usadas p on r.Código = p.Recambio
    inner join Operaciones op on p.Número = op.Número
    inner join Entradas e on op.Número = e.Número
where Fecha > GETDATE() -60
group by Nombre, Código, Cantidad
order by sum(Cantidad) desc

--3)Reducir un 10% el precio a todos los recambios que no --se hayan utilizado nunca y cuyo precio sea superior a la --media

declare @media_up smallint
select @media_up = AVG(Precio)
from Recambios
delete Recambios
where Código in (select Código
from Recambios r
    inner join Piezas_Usadas p on r.Código = p.Recambio
where Precio > @media_up
group by Código, Precio
having (Cantidad = null))

--4)Reducir el importe de aquellos coches que mas han --venido este año al taller
--Si han venido mas de 5 veces, un 10%
-- Más de 3 veces, un 5%
-- Los demás, nada	

declare @m5 smallint
select @m5 = COUNT(Coche)
from Entradas

if (select COUNT(Coche)
from Entradas) > 5
update Entradas
set Importe = Importe * 0.90
where @m5 > 5 and YEAR(Fecha) = YEAR(GETDATE())

if (select COUNT(Coche)
from Entradas) > 5
update Entradas
set Importe = Importe * 0.95
where @m5 > 3 and YEAR(Fecha) = YEAR(GETDATE())

if (select COUNT(Coche)
from Entradas) > 5
update Entradas
set Importe = Importe * 1
where @m5 > 0 and YEAR(Fecha) = YEAR(GETDATE())

--5)Guardar en la tabla Operaciones_año, el nombre y --teléfono de cada cliente, matrícula del coche, 
--fecha de entrada, importe de todas las entradas del año --en curso en orden por la fecha

select Nombre, Teléfono, Matrícula, Fecha, Importe
into Operaciones_año
from Clientes c
    inner join Coches ch on c.DNI = ch.Dueño
    inner join Entradas e on ch.Matrícula = e.Coche
where year(Fecha) = year(GETDATE())
group by Nombre, Teléfono, Matrícula, Fecha, Importe
order by Fecha asc
select *
from Operaciones_año

--6)Eliminar todos los recambios que no se hayan utilizado --nunca y que tengan un precio superior a la media

declare @media_del smallint
select @media_del = AVG(Precio)
from Recambios
delete Recambios
where Código in (select Código
from Recambios r
    inner join Piezas_Usadas p on r.Código = p.Recambio
where Precio > @media_del
group by Código, Precio
having (Cantidad = null))

--7)Listar nombre y teléfono del cliente, matrícula del --coche en orden descendente del nº de entradas, 
--de cada coche,  en este año

select Nombre, Teléfono, Matrícula
from Clientes c
    inner join Coches ch on ch.Dueño = c.DNI
    inner join Entradas e on e.Coche = ch.Matrícula
where year(Fecha) = year(GETDATE())
group by Nombre, Teléfono, Matrícula
order by COUNT(Número) desc

--8)Rutina que liste la matrícula de los coches que han --entrado en el taller entre 2 fechas( preguntar si la --rutina existe )
--Ejecútala

if exists(select *
from sysobjects
where name='lista_matricula')
drop function listar_matricula
go
create function listar_matricula(@fecha1 date, @fecha2 date)
returns table
as
	return(
		select Matrícula 'Entrado'
from Coches ch
    inner join Entradas e on ch.Matrícula = e.Coche
where Fecha > @fecha1 and Fecha < @fecha2
	)
go
select *
from listar_matricula('5/05/2021','30/05/2021')
--9)Incorporar a la base de datos, la siguiente --restricción:
--Comprobar que cuando registro una operación, el aprendiz --y el especialista de la misma, son realmente de ese tipo
go
create trigger comprobar_persona
on operaciones after update
as
	if ((select Tipo
    from Operarios
    where DNI in (select Aprendiz
    from inserted)) != 'Aprendiz')
    and
    ((select Tipo
    from Operarios
    where DNI in (select Especialista
    from inserted)) != 'Especialista')
	begin
    raiserror('FALLO EN LA DECLARACION DEL TIPO DE OPERARIOS',16,1)
    rollback
end
go


--10)Rutina que incremente el precio de los recambios --utilizados en alguna operación de este año, 
--en la cantidad que le indiquemos, 
--mientras el valor total de los stocks no supere los 3000€

create proc saldo_mod
    @inc smallint
as
while(select SUM(Precio * Stock)
from Recambios) > 3000
	begin
    update Recambios
		set Precio = Precio * (@inc/100)
		where Código in(select Código
    from Recambios r
        inner join Piezas_Usadas p on r.Código = p.Recambio
        inner join Operaciones op on p.Número = op.Número
        inner join Entradas e on op.Número = e.Número
    where YEAR(Fecha) = YEAR(GETDATE())
						)
end
go
