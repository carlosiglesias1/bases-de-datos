use camino_sdc;
go

INSERT into camino values('Joder', 100);
select * from camino;
go

INSERT into localidad VALUES ('BARC', 'Barcelona', 'Cataluña');
SELECT * from localidad;
GO

INSERT into localidad VALUES ('LLEID', 'Lleida', 'Cataluña');
SELECT * from localidad;
GO

INSERT into etapa VALUES('Joder', 1, 15, 'BARC', 'LLEID');

SELECT * from etapa;

select e.nombre, e.numero, e.km, l.nombre AS 'Ciudad de Salida', u.nombre as 'Ciudad llegada'
FROM etapa e inner JOIN localidad l ON e.ciudad_salida = l.cod_loc
JOIN localidad u on e.ciudad_llegada = u.cod_loc;
go


