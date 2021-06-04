use prueba_examen
go
create table repartidor(
dni char (9) primary key,
nombre varchar (25),
tlf char (9),
);
go

--comprobar que el teléfono no es null
use prueba_examen
go
alter table  cliente
add constraint ck_tlf check (tlf is not null);
go

--crear la clave ajena comercial en la tabla de ventas
use prueba_examen
go
alter table venta
add constraint fk_comercial foreign key (comercial) references comercial(dni);
go

--hacer que el nombre de los proveedores no sea nulo
use prueba_examen
go
alter table proveedor
alter column nombre varchar (20) not null;
go

--introducir datos
use prueba_examen
go
insert into cliente
values ('12343412M','Seoane e Hijos S.A','981832456');
go

--actualizar datos
use  prueba_examen
go
update cliente
set r_s = 'Mi polla en tu boca';
go

--select
select * from cliente;
go

