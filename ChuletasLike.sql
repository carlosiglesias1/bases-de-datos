/*
Busca personas cuyo numero de telefono empiece por 415
*/
-- Uses AdventureWorks  
-- Uses AdventureWorks  

SELECT p.FirstName, p.LastName, ph.PhoneNumber
FROM Person.PersonPhone AS ph
    INNER JOIN Person.Person AS p
    ON ph.BusinessEntityID = p.BusinessEntityID
WHERE ph.PhoneNumber LIKE '415%'
ORDER by p.LastName;  
GO

/*
Capsula de escape, para poder buscar el símbolo %
*/
USE tempdb;  
GO
IF EXISTS(SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'mytbl2')  
   DROP TABLE mytbl2;  
GO
USE tempdb;  
GO
CREATE TABLE mytbl2
(
    c1 sysname
);  
GO
INSERT mytbl2
VALUES
    ('Discount is 10-15% off'),
    ('Discount is .10-.15 off');  
GO
SELECT c1
FROM mytbl2
WHERE c1 LIKE '%10-15!% off%' ESCAPE '!';  
GO

/*
Busca las entidades que empiecen por C o por S, y acaben en heryl, o sea Cheryl y Sheryl
*/
-- Uses AdventureWorks  

SELECT BusinessEntityID, FirstName, LastName
FROM Person.Person
WHERE FirstName LIKE '[CS]heryl';  
GO


/*
Busca los empleados que el primer y el tercer numero sean 6 y 2
3 primeros dígitos válidos:
    612%    642%    672%
    622%    652%    682%
    632%    662%    692%
*/
-- Uses AdventureWorks  
  
SELECT FirstName, LastName, Phone  
FROM DimEmployee  
WHERE phone LIKE '6_2%'  
ORDER by LastName;