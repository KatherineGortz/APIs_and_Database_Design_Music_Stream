CREATE SCHEMA proyecto_spoti;
USE proyecto_spoti;

CREATE TABLE resultados_artistas_lastfm (
	Artista VARCHAR(100) PRIMARY KEY,
    Reproducciones VARCHAR (100),
    Oyentes INT,
    Biografía TEXT CHARACTER SET utf8mb4,
    Artistas_Similares VARCHAR(500)
);

CREATE TABLE pistas_spoti (
  artista VARCHAR(100),
  cancion VARCHAR(800),
  album VARCHAR(300),
  año INT,
  genero ENUM('pop','rock','electronic','metal'),
  spotify_id VARCHAR(200) PRIMARY KEY,
  popularidad INT
);

-----------------

SELECT DISTINCT ps.artista, ps.Artista 
FROM pistas_spoti ps 
LEFT JOIN resultados_artistas_lastfm ral 
ON ps.artista = ral.artista 
AND ps.Artista = ral.Artista 
WHERE ral.artista IS NULL;

SELECT artista
FROM (
    SELECT DISTINCT ps.artista
    FROM pistas_spoti ps
    LEFT JOIN resultados_artistas_lastfm ral 
    ON ps.artista = ral.Artista
    WHERE ral.Artista IS NULL
) AS subquery;

-- eliminamos artistas que no estan en last fm
DELETE FROM pistas_spoti
WHERE artista IN (
    SELECT artista
    FROM (
        SELECT DISTINCT ps.artista
        FROM pistas_spoti ps
        LEFT JOIN resultados_artistas_lastfm ral 
        ON ps.artista = ral.Artista
        WHERE ral.Artista IS NULL
    ) AS subquery
);

-- chequeamos que todos los artistas de last fm estan en la lista de spoty
SELECT DISTINCT ps.artista, ps.Artista 
FROM pistas_spoti ps 
LEFT JOIN resultados_artistas_lastfm ral 
ON ps.artista = ral.artista 
AND ps.Artista = ral.Artista 
WHERE ral.artista IS NULL;

-- agregamos el foreing key
ALTER TABLE pistas_spoti
ADD CONSTRAINT fk_artista
FOREIGN KEY (artista)
REFERENCES resultados_artistas_lastfm (Artista)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- cambiamos la columna reproducciones de var a bigint
ALTER TABLE resultados_artistas_lastfm
MODIFY COLUMN Reproducciones BIGINT;

-- ----------------------------------------------------
-- QUERIES RELEVANTES

-- 1. ¿Cuáles son los artistas más escuchados de cada género?
Select l.Artista, l.Reproducciones, s.genero 
From resultados_artistas_lastfm l
LEFT JOIN pistas_spoti s on s.artista=l.Artista
WHERE s.genero = 'pop' 
GROUP BY l.Artista
Order by Reproducciones DESC
limit 5;

Select l.Artista, l.Reproducciones, s.genero 
From resultados_artistas_lastfm l
LEFT JOIN pistas_spoti s on s.artista=l.Artista
WHERE s.genero = 'rock' 
GROUP BY l.Artista
Order by Reproducciones DESC
limit 5;

Select l.Artista, l.Reproducciones, s.genero 
From resultados_artistas_lastfm l
LEFT JOIN pistas_spoti s on s.artista=l.Artista
WHERE s.genero = 'metal' 
GROUP BY l.Artista
Order by Reproducciones DESC
limit 5;

Select l.Artista, l.Reproducciones, s.genero 
From resultados_artistas_lastfm l
LEFT JOIN pistas_spoti s on s.artista=l.Artista
WHERE s.genero = 'electronic' 
GROUP BY l.Artista
Order by Reproducciones DESC
limit 5;

-- 2. Número de álbumes por género y año. 
Select año, genero, COUNT(album) as cantidad
from pistas_spoti
GROUP BY año, genero
ORDER BY genero, año;

-- 3. a que albumes pertenecen las canciones mas populares
SELECT cancion, album , popularidad
FROM pistas_spoti 
WHERE (album, popularidad) IN (
        SELECT album, MAX(popularidad) AS max_popularidad
        FROM pistas_spoti
        GROUP BY album)
ORDER BY popularidad DESC
LIMIT 10;

-- 4. Cancion más popular de cada artista con limite de 10 artistas
SELECT artista, cancion, popularidad
FROM pistas_spoti 
WHERE (artista, popularidad) IN (
        SELECT artista, MAX(popularidad) AS max_popularidad
        FROM pistas_spoti
        GROUP BY artista)
ORDER BY popularidad DESC
LIMIT 10;

-- 5. Número de oyentes por género
SELECT ps.genero, SUM(ral.Oyentes) AS Total_Oyentes
FROM pistas_spoti ps
JOIN resultados_artistas_lastfm ral 
ON ps.artista = ral.Artista
WHERE ps.genero IN ('pop', 'rock', 'electronic', 'metal')
GROUP BY ps.genero
ORDER BY Total_Oyentes DESC;

-- 6. ¿Cuales son los artistas Similares de los 5 artistas con mas Numero de Reproducciones de cada genero?
Select l.Artista, l.Artistas_Similares, s.genero
From resultados_artistas_lastfm l
left join pistas_spoti s on s.artista =l.Artista
where genero = "pop"
Group by l.Artista
Order by Reproducciones Desc
limit 5;

Select l.Artista, l.Artistas_Similares, s.genero
From resultados_artistas_lastfm l
left join pistas_spoti s on s.artista =l.Artista
where genero = "rock"
Group by l.Artista
Order by Reproducciones Desc
limit 5;

Select l.Artista, l.Artistas_Similares, s.genero
From resultados_artistas_lastfm l
left join pistas_spoti s on s.artista =l.Artista
where genero = "metal"
Group by l.Artista
Order by Reproducciones Desc
limit 5;

Select l.Artista, l.Artistas_Similares, s.genero
From resultados_artistas_lastfm l
left join pistas_spoti s on s.artista =l.Artista
where genero = "electronic"
Group by l.Artista
Order by Reproducciones Desc
limit 5;

-- 7. ¿Cuales son las 5 canciones mas populares entre 2018 y 2022 de los generos que elegimos? 
Select cancion, artista, año, genero, popularidad
From pistas_spoti
Where genero = 'pop'
ORDER BY popularidad DESC
limit 5;

Select cancion, artista, año, genero, popularidad
From pistas_spoti
Where genero = 'electronic'
ORDER BY popularidad DESC
limit 5;

SELECT cancion, artista, año, genero, popularidad
FROM pistas_spoti p1
WHERE genero = 'rock'
  AND popularidad = (
    SELECT MAX(popularidad)
    FROM pistas_spoti p2
    WHERE p2.cancion = p1.cancion)
ORDER BY popularidad DESC
LIMIT 5;

Select cancion , artista, año, genero, popularidad
From pistas_spoti
Where genero = 'Metal'
ORDER BY popularidad DESC
limit 5;

-- 8. ¿Cuales son los 5 artistas con mas Oyentes por genero ?
Select l.Artista, l.Oyentes
From resultados_artistas_lastfm l
Left JOIN pistas_spoti s on s.artista=l.Artista
WHERE Genero = "pop"
GROUP BY l.Artista
Order by Oyentes DESC
limit 5;

Select l.Artista, l.Oyentes
From resultados_artistas_lastfm l
Left JOIN pistas_spoti s on s.artista=l.Artista
WHERE Genero = "rock"
GROUP BY l.Artista
Order by Oyentes DESC
limit 5;

Select l.Artista, l.Oyentes
From resultados_artistas_lastfm l
Left JOIN pistas_spoti s on s.artista=l.Artista
WHERE Genero = "metal"
GROUP BY l.Artista
Order by Oyentes DESC
limit 5;

Select l.Artista, l.Oyentes
From resultados_artistas_lastfm l
Left JOIN pistas_spoti s on s.artista=l.Artista
WHERE Genero = "electronic"
GROUP BY l.Artista
Order by Oyentes DESC
limit 5;

-- 9. ¿Cuáles son los artistas con biografía más extensa? si pasa de 666 crea un link !
select Artista, CHAR_LENGTH(Biografía) as caracteres
from resultados_artistas_lastfm
order by caracteres DESC
limit 5;

-- 10 En que año se lanzaron mas albumes de nuestro 4 generos elegidos 
Select año, COUNT(DISTINCT album) as cantidad_albums
From pistas_spoti
GROUP BY año
ORDER BY cantidad_albums DESC;


-- 11. ¿Cuales son los 10 artistas que han lanzado más álbumes? para SPRINT REVIEW !!!!!!!!!!!!!!!!!!!!!!!!!!!!
SELECT artista, COUNT(DISTINCT album) as cantidad
from pistas_spoti
where genero = "pop"or genero =  "rock" or genero =  "metal" and cancion != album
GROUP BY artista
ORDER BY cantidad DESC
limit 10;

-- 12. Selecciona el album, el año de lanzamiento y cancion mas popular en cada año elegido.
SELECT  artista, album, cancion, año, popularidad
FROM pistas_spoti
where año = 2018 and cancion != album
order by popularidad DESC
limit 10;

SELECT  artista, album, cancion, año, popularidad
FROM pistas_spoti
where año = 2019 and cancion != album
order by popularidad DESC
limit 10;

SELECT  artista, album, cancion, año, popularidad
FROM pistas_spoti
where año = 2020 and cancion != album
order by popularidad DESC
limit 10;

SELECT  artista, album, cancion, año, popularidad
FROM pistas_spoti
where año = 2021 and cancion != album  
order by popularidad DESC
limit 10;

SELECT  artista, album, cancion, año, popularidad
FROM pistas_spoti
where año = 2022 and cancion != album and album != "SOS" 
order by popularidad DESC
limit 10;

-- 13. ¿Cuántas canciones hay por género? PEDIMOS CON LIMITE - NO SE PUEDE !!
-- 14. ¿Cuál es el género con más canciones? PEDIMOS CON LIMITE - NO SE PUEDE !!
-- 15. ¿Qué artistas tienen canciones en colaboración con otros artistas? -- NO TENEMOS COMO SABERLO O CAPAZ CON FEAT

-- 16. ¿Cuáles son las tres canciones más populares en total por género?
Select artista, cancion 
From pistas_spoti
WHERE genero = 'pop' 
Order by popularidad DESC
limit 3;

Select artista, cancion 
From pistas_spoti
WHERE genero = 'rock' 
Order by popularidad DESC
limit 3;

Select artista, cancion 
From pistas_spoti
WHERE genero = 'metal' 
Order by popularidad DESC
limit 3;

Select artista, cancion 
From pistas_spoti
WHERE genero = 'electronic' 
Order by popularidad DESC
limit 3;

-- 17. Los 50 artistas con mas reproducciones y sus respectivos generos
SELECT SUM(l.Reproducciones) AS cantidad_reproducciones, l.Artista, s.genero
FROM resultados_artistas_lastfm l
JOIN pistas_spoti s ON l.Artista = s.artista 
GROUP BY l.Artista, s.genero
ORDER BY cantidad_reproducciones DESC
LIMIT 50;

-- -----------------------------------------------------
-- -----------------------------------------------------
-- -----------------------------------------------------
-- -----------------------------------------------------

-- CONSULTAS QUE HICIMOS NOSOTRAS
USE proyecto_spoti;

Select * 
from pistas_spoti;

Select * 
from resultados_artistas_lastfm;

-- 1. ¿Cuales son los 5 artistas mas escuchados (Numero de reproducciones)? 
-- el genero esta asignado  a las canciones no a los artistas
Select l.Artista, l.Reproducciones, s.genero 
From resultados_artistas_lastfm l
LEFT JOIN pistas_spoti s on s.artista=l.Artista
GROUP BY l.Artista
Order by Reproducciones DESC
limit 5;

-- CUales son los artistas que estan en mas de un genero. son 183 artistas
Select artista, COUNT(DISTINCT genero) as cantidad
From pistas_spoti
GROUP BY artista
HAVING cantidad = 2
ORDER BY cantidad DESC;

-- 5 artistas mas escuchados (Numero de reproducciones) de Rock
Select l.Artista, l.Reproducciones, s.genero 
From resultados_artistas_lastfm l
LEFT JOIN pistas_spoti s on s.artista=l.Artista
WHERE s.genero = 'rock' 
GROUP BY l.Artista
Order by Reproducciones DESC
limit 5;

-- 2. ¿Cuales son las 5 canciones mas populares entre 2018 y 2022 de los generos que elegimos? 
Select cancion, artista, año, genero, popularidad
From pistas_spoti
Where genero = 'pop'
ORDER BY popularidad DESC
limit 5;

Select cancion, artista, año, genero, popularidad
From pistas_spoti
Where genero = 'electronic'
ORDER BY popularidad DESC
limit 5;

SELECT cancion, artista, año, genero, popularidad
FROM pistas_spoti p1
WHERE genero = 'rock'
  AND popularidad = (
    SELECT MAX(popularidad)
    FROM pistas_spoti p2
    WHERE p2.cancion = p1.cancion)
ORDER BY popularidad DESC
LIMIT 5;

Select cancion , artista, año, genero, popularidad
From pistas_spoti
Where genero = 'Metal'
ORDER BY popularidad DESC
limit 5;

-- 3. ¿En qué año se lanzaron más álbumes entre 2018 y 2022 de los generos que elegimos?
Select año, COUNT(DISTINCT album) as cantidad_albums
From pistas_spoti
GROUP BY año
ORDER BY cantidad_albums DESC;

-- 4 ¿Cuál es la canción peor valorada (popularidad) entre 2018 y 2022 de los generos que elegimos?
Select cancion, artista, genero, popularidad
From pistas_spoti
ORDER BY popularidad ASC
LIMIT 1;

-- 5. ¿Cuál es la canción mejor valorada (popularidad) entre 2018 y 2022 de los generos que elegimos?
Select cancion, artista, genero, popularidad
From pistas_spoti
ORDER BY popularidad desc
LIMIT 1;

-- 6. ¿Que genero elegido tiene mas canciones populares en el año 2018?
Select genero, AVG(popularidad) as Popularidad, año
FROM pistas_spoti
Where año =2018
GROUP BY genero
ORDER BY Popularidad DESC;

Select genero, AVG(popularidad) as Popularidad, año
FROM pistas_spoti
Where año =2019
GROUP BY genero
ORDER BY Popularidad DESC;

Select genero, AVG(popularidad) as Popularidad, año
FROM pistas_spoti
Where año =2020
GROUP BY genero
ORDER BY Popularidad DESC;

Select genero, AVG(popularidad) as Popularidad, año
FROM pistas_spoti
Where año =2021
GROUP BY genero
ORDER BY Popularidad DESC;

Select genero, AVG(popularidad) as Popularidad, año
FROM pistas_spoti
Where año =2022
GROUP BY genero
ORDER BY Popularidad DESC;

-- 7. ¿Cuales son los 5 artistas con mas Oyentes por genero ?
Select l.Artista, l.Oyentes
From resultados_artistas_lastfm l
Left JOIN pistas_spoti s on s.artista=l.Artista
WHERE Genero = "pop"
GROUP BY l.Artista
Order by Oyentes DESC
limit 5;

Select l.Artista, l.Oyentes
From resultados_artistas_lastfm l
Left JOIN pistas_spoti s on s.artista=l.Artista
WHERE Genero = "rock"
GROUP BY l.Artista
Order by Oyentes DESC
limit 5;

Select l.Artista, l.Oyentes
From resultados_artistas_lastfm l
Left JOIN pistas_spoti s on s.artista=l.Artista
WHERE Genero = "metal"
GROUP BY l.Artista
Order by Oyentes DESC
limit 5;

Select l.Artista, l.Oyentes
From resultados_artistas_lastfm l
Left JOIN pistas_spoti s on s.artista=l.Artista
WHERE Genero = "electronic"
GROUP BY l.Artista
Order by Oyentes DESC
limit 5;

-- 8. ¿Cuales son los artistas Similares de los 5 artistas con mas Numero de Oyentes de cada genero?
Select l.Artista, l.Artistas_Similares, s.genero
From resultados_artistas_lastfm l
left join pistas_spoti s on s.artista =l.Artista
where genero = "pop"
Group by l.Artista
Order by Oyentes Desc
limit 5;

Select l.Artista, l.Artistas_Similares, s.genero
From resultados_artistas_lastfm l
left join pistas_spoti s on s.artista =l.Artista
where genero = "rock"
Group by l.Artista
Order by Oyentes Desc
limit 5;

Select l.Artista, l.Artistas_Similares, s.genero
From resultados_artistas_lastfm l
left join pistas_spoti s on s.artista =l.Artista
where genero = "metal"
Group by l.Artista
Order by Oyentes Desc
limit 5;

Select l.Artista, l.Artistas_Similares, s.genero
From resultados_artistas_lastfm l
left join pistas_spoti s on s.artista =l.Artista
where genero = "electronic"
Group by l.Artista
Order by Oyentes Desc
limit 5;

-- 9. ¿Cuales son los artistas Similares de los 5 artistas con mas Numero de Reproducciones de cada genero?
Select l.Artista, l.Artistas_Similares, s.genero
From resultados_artistas_lastfm l
left join pistas_spoti s on s.artista =l.Artista
where genero = "pop"
Group by l.Artista
Order by Reproducciones Desc
limit 5;

Select l.Artista, l.Artistas_Similares, s.genero
From resultados_artistas_lastfm l
left join pistas_spoti s on s.artista =l.Artista
where genero = "rock"
Group by l.Artista
Order by Reproducciones Desc
limit 5;

Select l.Artista, l.Artistas_Similares, s.genero
From resultados_artistas_lastfm l
left join pistas_spoti s on s.artista =l.Artista
where genero = "metal"
Group by l.Artista
Order by Reproducciones Desc
limit 5;

Select l.Artista, l.Artistas_Similares, s.genero
From resultados_artistas_lastfm l
left join pistas_spoti s on s.artista =l.Artista
where genero = "electronic"
Group by l.Artista
Order by Reproducciones Desc
limit 5;

-- 10. ¿Cuales son los 50 artistas que se repiten mas en nuestra lista? 
SELECT COUNT(artista) as cantidad, artista
FROM pistas_spoti
GROUP BY artista
ORDER BY cantidad DESC 
LIMIT 50;

-- 11 Cuantos artistas distintos hay por cada genero?
Select genero, COUNT(Distinct artista)
from pistas_spoti
GROUP BY genero;

-- 12 ¿Cuantos oyentes en total tiene cada género? SORPRESA

SELECT ps.genero, SUM(ral.Oyentes) AS Total_Oyentes
FROM pistas_spoti ps
JOIN resultados_artistas_lastfm ral 
ON ps.artista = ral.Artista
WHERE ps.genero IN ('pop', 'rock', 'electronic', 'metal')
GROUP BY ps.genero
ORDER BY Total_Oyentes DESC;

-- 13 biogrfias de los 5 artistas con mas oyentes
Select Artista, Biografía, Oyentes
From resultados_artistas_lastfm 
GROUP BY Artista
Order by Oyentes Desc
limit 5;