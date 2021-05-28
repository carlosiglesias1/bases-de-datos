use Banco;
go

/*1.C�digo de cuenta, fecha de apertura y nombre del cliente, de las cuentas abiertas en el mes en curso por clientes 
de A Coru�a y Lugo cuyo nombre comience por C o D  y tenga en total 5 letras*/

select c.codigo, c.fecha, c.cliente, cli.nombre
	from Cuentas c join Clientes cli on c.Cliente = cli.Dni
	where year(c.Fecha) = year(getdate()) and MONTH(c.Fecha) = MONTH(getdate())
	and cli.Provincia in ('A Coru�a', 'Lugo') and len(cli.Nombre)<6 and (cli.Nombre like ('C%') or cli.Nombre like ('D%'));
go

/*2.N�mero de cuentas de clientes de A Coru�a, con un saldo superior a la media*/
declare @avgSaldo int;
select @avgSaldo = AVG(c.saldo) from Cuentas c;
go
select c.codigo
	from Cuentas c join Clientes cli on c.Cliente = cli.Dni
	where cli.Provincia = 'A Coru�a' and c.Saldo > @avgSaldo;
go

/*3.Dni de los  clientes de A Coru�a que tienen mas de 1 cuenta con un saldo superior a la media?*/
select cli.dni
	from Clientes cli join Cuentas c on cli.Dni = c.Cliente;
go

/*4.Guardar en la tabla Top_3_Clientes, el dni, nombre y saldo total de los 3 clientes que tienen el saldo total mas alto (entre todas sus cuentas), 
en orden del que mas tiene al que menos tiene*/
select top 3 SUM(c.saldo) as 'Saldo total', cli.nombre, cli.Dni into Top_3_Clientes
	from Clientes cli join Cuentas c on c.Cliente = cli.Dni
	group by cli.Nombre, cli.Dni
	order by SUM(c.saldo);
go

/*5.Borrar  todas las cuentas que no han tenido ning�n movimiento en los �ltimos 1000 dias, incluyendo las que nunca han tenido ning�n movimiento.*/

/*6.�Cual fu� el ingreso m�ximo, el m�nimo y el medio del d�a de hoy?*/
select top 1 m.importe as 'm�ximo', AVG(m.importe) as 'medio' 
	from Movimientos m
	where m.Tipo = 'i' and m.Fecha = GETDATE()
	group by m.Importe;
go

/*7.Dni y nombre del cliente, n�mero de cuentas que tiene, saldo total de todas sus cuentas, de los que tienen un saldo total superior a 
2000� y cuyo nombre comience por a, b o c*/
select cli.dni, cli.nombre, count(c.codigo) as Cuentas, sum(c.saldo) as Saldo_Total
	from Clientes cli join Cuentas c on c.Cliente = cli.Dni
	where cli.Nombre like ('A%') or cli.Nombre like ('B%') or cli.Nombre like ('C%')
	group by cli.Dni, cli.Nombre
	having SUM(c.saldo)>2000;
go

/*
8.A todas las cuentas abiertas este mes, de clientes de A Coru�a y Lugo, que tengan un saldo por encima de la media, aumentarles el saldo en 100�
*/
update Cuentas
	set Saldo = Saldo + 100
	from Cuentas join Clientes on Cuentas.Cliente = Clientes.Dni 
	where Saldo > (select avg(saldo)
					from Cuentas)
		and Provincia in ('A Coru�a', 'Lugo');
go
--Comprobamos--
select * from Cuentas c join Clientes cli on c.Cliente = cli.Dni
	where cli.Provincia in ('A Coru�a', 'Lugo')
		and c.Saldo > (select avg(saldo)
							from Cuentas);
go

/*
9.Eliminar todos los ingresos del d�a de hoy, en la cuenta de c�digo 1, de importe inferior a 10�
*/
delete from Movimientos
 where codigo = 1 and Importe < 10;
 go
 select * from Movimientos;
 go

 /*
 10.A todas las cuentas que han tenido mas de 2 ingresos en el d�a de hoy, por un importe total superior a 1000�, aumentarles 100� en el saldo.
 */
 select * from Cuentas;
 update Cuentas
	set Saldo += 100
	from Cuentas c join Movimientos m on c.codigo = m.codigo
	where (select count(codigo)
					from Movimientos
					where Tipo = 'i' and Fecha = GETDATE()) > 2;