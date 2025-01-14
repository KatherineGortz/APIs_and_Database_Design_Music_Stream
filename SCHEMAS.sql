CREATE SCHEMA proyecto_spoti;
USE proyecto_spoti;

CREATE TABLE resultados_artistas_lastfm (
	Artista VARCHAR(100) PRIMARY KEY,
    Reproducciones INT,
    Oyentes INT,
    Biografía TEXT,
    Artistas_Similares VARCHAR(500)
);

CREATE TABLE pistas_spoti (
  artista VARCHAR(100),
  cancion VARCHAR(100),
  album VARCHAR(100),
  año INT,
  genero ENUM('pop','rock','electronic','metal'),
  spotify_id VARCHAR(200) PRIMARY KEY,
  popularidad INT,
  FOREIGN KEY (artista) REFERENCES resultados_artistas_lastfm (Artista)
  );
  
ALTER TABLE resultados_artistas_lastfm
MODIFY COLUMN Reproducciones VARCHAR(200);