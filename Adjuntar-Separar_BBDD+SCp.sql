/*Comenzamos con el ejercicio de Adjuntar o Separar una Base de datos*/
use master;
go

/*Empezamos separando la base de datos*/

exec sp_detach_db 'camino_sdc', 'true';

/*Con esto separaremos la base de datos del camino de santiago del motor de bases de datos*/

/*Ahora adjuntaremos la bbdd de nuevo, con lo cual volverá a estar conectada con el motor de bases de datos*/

create database camino_sdc on
	(filename = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\camino_sdc.mdf'),
	(filename = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\camino_sdc_log.ldf')
	for attach;
go

/*Ahora crearemos una copia de seguridad de la base de datos del camino de santiago*/

/*Primero deberemos crear un archivo o "dispositivo" para almacenar nuestra copia de seguridad*/
exec sp_addumpdevice 'disk', 'copia_camino_sdc', 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\Backup\copia_camino.bak';
go
/*Una vez creado el dispositivo lógico, almacenamos en el la copia de seguridad*/
use camino_sdc
go
backup database camino_sdc
	to copia_camino_sdc;
go
/*Para hacer una copia de seguridad del registro de transacciones 
tendremos que cambiar el modelo de recuperación*/

--Miramos si tenemos el modo de recuperación en "completo"
select name, recovery_model_desc
	from sys.databases
	where name='camino_sdc';
go
--Lo cambiamos a "completo"
use master;
alter database camino_sdc set recovery full;
go

backup log camino_sdc 
	to copia_camino_sdc;
go

/*Procedemos a restaurar a base de datos a partir de la copia de seguridad*/

/*Ponemos la base de datos en modo usuario unico*/
use master;
go
alter database camino_sdc set single_user with rollback immediate;
go

/*realizamos la copia de final de registro*/
backup log camino_sdc to copia_camino_sdc
with norecovery;
go

/*ahora restauro la primera copia completa*/
restore database camino_sdc
	from copia_camino_sdc
	with file=1,
		norecovery;
go

/*Ahora aplico los archivos de log*/

restore log camino_sdc
	from copia_camino_sdc
	with file=2,
		norecovery;
go

restore log camino_sdc
	from copia_camino_sdc
	with file=3,
		recovery;
go
--Restauro la base de datos en multiusuario
alter database camino_sdc
	set multi_user;
go

/*AHORA VEREMOS COMO AUTOMATIZAR ESTE PROCESO*/
