# proyecto-da-promo-47-modulo-2-team-1


# Limitaciones:
# Ranking Mundial Oficial:

Spotify no ofrece un endpoint directo para obtener rankings oficiales (como los de las playlists "Top Global").
Puedes simularlo ordenando las canciones por su atributo de popularidad.
Playlists Curadas:

Si necesitas el top oficial, deberías analizar playlists públicas como "Top Hits of 2019" o "Global Top 50". Esto requiere usar el endpoint de playlists para buscar y analizar las canciones dentro de esas listas.
Restricciones Regionales:

La popularidad puede variar entre regiones. Si tienes acceso global (market="from_token"), el atributo popularity refleja un promedio global.
Este código te permitirá aproximarte bastante a un top mundial basado en los datos disponibles de la API de Spotify.