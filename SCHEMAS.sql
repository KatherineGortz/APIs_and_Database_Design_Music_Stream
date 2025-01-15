CREATE TABLE resultados_artistas_lastfm (
	id_artista INT AUTO_INCREMENT PRIMARY KEY,
	Artista VARCHAR(100),
    Reproducciones VARCHAR (100),
    Oyentes INT,
    Biografía TEXT,
    Artistas_Similares VARCHAR(500)
);
CREATE TABLE pistas_spoti (
  id_pista INT AUTO_INCREMENT PRIMARY KEY,
  id_artista INT,
  artista VARCHAR(100),
  cancion VARCHAR(300),
  album VARCHAR(300),
  año INT,
  genero ENUM('pop','rock','electronic','metal'),
  spotify_id VARCHAR(200) UNIQUE,
  popularidad INT,
  FOREIGN KEY (id_artista) REFERENCES resultados_artistas_lastfm (id_artista)
  );
  
SELECT * FROM resultados_artistas_lastfm
WHERE Artista= 'LISA';

SELECT * FROM resultados_artistas_lastfm
WHERE Artista= 'Juelz';
