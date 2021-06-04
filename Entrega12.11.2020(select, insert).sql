--Listar nombre y apellidos del cliente, fecha de los pedidos, título del libro pedido y número de ejemplares pedidos
use Libreria;
go
select c.nombre, c.apellidos, p.fecha, l.titulo Libro, d.num_ej Ejemplares
from cliente c inner join pedido p on c.cod_cli=p.cod_cli
inner join pedido_detalle d on p.num_pedido=d.num_pedido
inner join libro l on l.cod_lib=d.cod_lib;

go
--Insertar un nuevo pedido para un cliente con 2 libros de 3 ejemplares cada uno

use Libreria
go
insert pedido (num_pedido,cod_cli)
values ('1','1');
insert pedido_detalle
values('1','1',3),
('1','2', 3);

go
--Insertar 2 libros nuevos en Libro
use Libreria
go
insert into libro
values ('4', 'Cómo aprobar Bases de Datos', 'Carlos Iglesias Gómez', 20, 5, getdate(),'1'),
('5', 'Diseño de Un 5 pelao', 'Fernando Wirtz Suárez', 25, 3, getdate(),'2');
select * from libro;
go

--Borrar todos los pedidos de fecha posterior al 1/12/2020
--Como tenemos el borrado en cascada, borrando en la tabla de pedidos también borramos en la tabla de detalles del pedido
use Libreria
go
delete from pedido
where fecha>='2020-12-1';
go

--Borrar de detalle de pedido uno de los libros del apartado 2
use Libreria
go
delete from pedido_detalle
where num_pedido='1' and cod_lib='2';
go

--Borrar todos los pedidos de un cliente posteriores al 15/11/2020
use Libreria
go
delete from pedido
where cod_cli='2' and fecha>='2020-11-15';
