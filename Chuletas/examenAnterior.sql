-- C�digo de cuenta, fecha de apertura y nombre del cliente, de las cuentas 
-- abiertas en el mes en curso por clientes de A Coru�a y Lugo cuyo nombre comience por 
-- C o D  y tenga en total 5 letras
select c.codigo, fecha, nombre
from Cuentas c
inner join Clientes cl on cl.Dni=c.Cliente
where MONTH(fecha)=MONTH(getdate()) and 
		YEAR(fecha)=YEAR(getdate()) and 
      Nombre like '[CD][A-Z][A-Z][A-Z][A-Z]' 
	  and Provincia in ('A Coru�a','Lugo')

-- N�mero de cuentas de clientes de A Coru�a, con un saldo superior a la media
select COUNT(*)
from Cuentas c
inner join Clientes cl on cl.Dni=c.Cliente
where Saldo > (select AVG(saldo) from Cuentas) 
and provincia='A Coru�a'

-- Dni de los  clientes de A Coru�a que tienen mas de 1 cuenta con un saldo superior a la media
select dni 
from Clientes c
inner join Cuentas cu on cu.Cliente=c.Dni
where Provincia='A Coru�a' 
	and Saldo > (select AVG(saldo) from Cuentas)
group by dni
having count(codigo)>1

-- Guardar en la tabla Top_3_Clientes, el dni, nombre y saldo total de los 3 clientes que tienen el 
-- saldo total mas alto (entre todas sus cuentas), en orden del que mas tiene al que menos tiene
select top 3 dni, nombre, SUM(saldo) 'Saldo Total' into Top_3_Clientes
from Clientes c
inner join Cuentas cu on cu.Cliente=c.Dni
group by Dni, Nombre
order by SUM(saldo) desc

-- Borrar  todas las cuentas que no han tenido ning�n movimiento en los �ltimos 1000 dias, incluyendo las que nunca han 
-- tenido ning�n movimiento.
delete Cuentas 
where Codigo not in (
	select distinct c.codigo 
	from Cuentas c
	inner join Movimientos m on m.Codigo=c.Codigo
	where m.Fecha>=GETDATE()-1000
	)

--�Cual fu� el ingreso m�ximo, el m�nimo y el medio del d�a de hoy?
select MAX(importe) 'M�ximo', MIN(importe) 'M�nimo', AVG(importe) 'Medio'
from Movimientos
where Fecha=CONVERT(date,getdate()) and Tipo='i'

-- Dni y nombre del cliente, n�mero de cuentas que tiene, saldo total de todas sus cuentas, de los que tienen un 
-- saldo total superior a 2000� y cuyo nombre comience por a, b o c
select dni, nombre, COUNT(codigo)'N�mero de cuentas', SUM(saldo)'Saldo total'
from Clientes c
inner join Cuentas cu on cu.Cliente=c.Dni
where Nombre like '[ABC]%'
group by Dni, nombre
having SUM(saldo)>2000

-- A todas las cuentas abiertas este mes, de clientes de A Coru�a y Lugo, que tengan un saldo por encima de la media, 
-- aumentarles el saldo en 100�
update Cuentas 
set Saldo=Saldo+100
from Cuentas c
inner join Clientes cl on cl.Dni=c.cliente
where MONTH(fecha)=MONTH(getdate()) and YEAR(fecha)=YEAR(getdate()) and 
      Provincia in ('A Coru�a','Lugo') and Saldo > (select AVG(saldo) from Cuentas)

-- Eliminar todos los ingresos del d�a de hoy, en la cuenta de c�digo 1, de importe inferior a 10�
delete Movimientos 
where Codigo=1 and 
Importe<10 and 
Fecha=CONVERT(date,getdate()) 
and Tipo='i'

-- A todas las cuentas que han tenido mas de 2 ingresos en el d�a de hoy, por un importe total superior a 
-- 1000�, aumentarles 100� en el saldo.
update Cuentas 
set Saldo=Saldo+100
where Codigo in (
select c.codigo
from Cuentas c
inner join Movimientos m on m.Codigo=c.Codigo
where m.Fecha=CONVERT(date,getdate()) and tipo='i'
group by c.codigo
having COUNT(numero)>2 and SUM(importe)>1000
)