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

SELECT DISTINCT ps.artista, ps.Artista 
FROM pistas_spoti ps 
LEFT JOIN resultados_artistas_lastfm ral 
ON ps.artista = ral.artista 
AND ps.Artista = ral.Artista 
WHERE ral.artista IS NULL;

ALTER TABLE pistas_spoti
ADD CONSTRAINT fk_artista
FOREIGN KEY (artista)
REFERENCES resultados_artistas_lastfm (Artista)
ON DELETE CASCADE
ON UPDATE CASCADE;

SELECT * FROM pistas_spoti;

SELECT * FROM resultados_artistas_lastfm
ORDER BY Reproducciones DESC;

ALTER TABLE resultados_artistas_lastfm
MODIFY COLUMN Reproducciones BIGINT;