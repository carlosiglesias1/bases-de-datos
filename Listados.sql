-- listar todo de los peregrinos
use Camino_santiago
go
select * from peregrinos
-- listar carnet y teléfono de los peregrinos
use Camino_santiago
go
select carnet,Teléfono from peregrinos
-- listar nombre de las localidades
use Camino_santiago
go
select Nombre from Localidades
-- listar todo sobre caminos
use Camino_santiago
go
select * from Caminos
--Nombre y apellidos del peregrino, Etapa y fecha en la que las hizo.
use Camino_santiago
go
select p.Nombre, Apellidos, r.Nombre, Número, Fecha
from recorren r
inner join peregrinos p on r.carnet = p.carnet