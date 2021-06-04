use master;
go

if (DB_ID('centroEnseñanza')) is not NULL
    drop DATABASE centroEnseñanza;
GO

CREATE DATABASE centroEnseñanza;

use centroEnseñanza;
GO

CREATE TABLE departamento
(
    nombre VARCHAR (25) primary key,
    presupuesto SMALLMONEY not NULL
);
GO

-- Create the table in the specified schema
CREATE TABLE profesor
(
    dni char (9) PRIMARY KEY,
    nombre VARCHAR (25),
    apellido VARCHAR (25),
    departamento VARCHAR (25) REFERENCES departamento (nombre),
);
GO

CREATE TABLE ciclo
(
    codigo VARCHAR (4) primary key,
    nombre VARCHAR (25),
    horas SMALLINT,
    tipo VARCHAR (8),
    departamento VARCHAR (25) REFERENCES departamento (nombre),
    CHECK (tipo in ('Medio', 'Superior')),
    CHECK (horas between 1500 and 2000)
);
go

CREATE TABLE curso
(
    ciclo VARCHAR (4) REFERENCES ciclo (codigo),
    numero TINYINT,
    PRIMARY KEY (ciclo, numero),
);
GO

CREATE TABLE materia
(
    codigo CHAR (4) primary key,
    nombre VARCHAR (25),
    horas SMALLINT,
);
GO

CREATE TABLE impartida
(
    ciclo VARCHAR (4),
    curso TINYINT,
    materia CHAR (4) REFERENCES materia (codigo),
    FOREIGN key (ciclo, curso) REFERENCES curso (ciclo, numero),
    PRIMARY KEY (ciclo, curso, materia),
);
GO

CREATE TABLE alumno
(
    dni CHAR (9) PRIMARY KEY,
    nombre VARCHAR (25),
    apellido VARCHAR (20),
    telefono CHAR (9),
);
go

CREATE TABLE matricula
(
    codigo char (9) primary key,
    almuno char (9) REFERENCES alumno (dni),
    fecha DATE default getdate(),
    anoAcademico char (5),
    ciclo VARCHAR (4),
    curso TINYINT,
    FOREIGN KEY (ciclo, curso) REFERENCES curso (ciclo, numero),
);
GO

CREATE table calificacion
(
    matricula CHAR (9) REFERENCES matricula (codigo),
    materia CHAR (4) REFERENCES materia (codigo),
    nota TINYINT,
    PRIMARY KEY (matricula, materia),
);