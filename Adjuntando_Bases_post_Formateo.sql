use master;
go

create database Libreria on 
	(filename = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Libreria.mdf'),
	(filename = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Libreria_log.ldf')
	for attach;
go

create database Proyectos on 
	(filename = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Proyectos.mdf'),
	(filename = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Proyectos_log.ldf')
	for attach;