--calcular el total de operaciones de un operario
if exists(select * from sysobjects
			where name = 'contarOperacionesOperario')
	drop function dbo.contarOperacionesOperario;
go

create function contarOperacionesOperario (@operario char (40)) returns tinyint
as
begin
	return (
		select COUNT (*) from operacion
		where especialista = (select dni from operario where nombre = @operario)
	);
end
go
--dni y nombre de los operarios que en el dia de hoy han realizado mas operaciones
--que un operario determinado
if exists(select * from sysobjects
			where name = 'compararOperaciones')
	drop function dbo.compararOperaciones;
go

create function compararOperaciones (@operario char (40)) returns table 
as 
	return(
		select *
			from operario
			where dbo.contarOperacionesOperario(operario.nombre)>dbo.contarOperacionesOperario(@operario)
				and operario.tipo = 'Especialista');
go

select dbo.contarOperacionesOperario('Carlos');
go

select * from compararOperaciones ('Carlos');
go

