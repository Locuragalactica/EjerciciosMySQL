-- 1. Mostrar el nombre de todos los jugadores ordenados alfabéticamente.
select nombre 
from jugadores
order by nombre asc;

-- 2. Mostrar el nombre de los jugadores que sean pivots (‘C’) y que pesen más de 200 libras, ordenados por nombre alfabéticamente.
select nombre, posicion
from jugadores 
where posicion = 'C'
and peso > 200
order by nombre asc;

-- 3. Mostrar el nombre de todos los equipos ordenados alfabéticamente.
select nombre
from equipos
order by nombre asc;

-- 4. Mostrar el nombre de los equipos del este (East).
select nombre, conferencia
from equipos 
where conferencia = 'East';

-- 5. Mostrar los equipos donde su ciudad empieza con la letra ‘c’, ordenados por nombre.
select nombre, ciudad
from equipos
where ciudad like 'C%'
order by nombre asc;

-- 6. Mostrar todos los jugadores y su equipo ordenados por nombre del equipo.
select j.nombre , e.nombre
from jugadores j, equipos e 
order by e.nombre asc;

-- 7. Mostrar todos los jugadores del equipo “Raptors” ordenados por nombre.
select j.nombre, e.nombre
from jugadores j, equipos e
where e.nombre = 'Raptors'
order by j.nombre asc;

-- 8. Mostrar los puntos por partido del jugador ‘Pau Gasol’.
select nombre, Puntos_por_partido
from jugadores, estadisticas
where codigo = jugador
and nombre = 'Pau Gasol';

-- 9. Mostrar los puntos por partido del jugador ‘Pau Gasol’ en la temporada ’04/05′.
select nombre, Puntos_por_partido, temporada
from jugadores, estadisticas
where codigo = jugador
and nombre = 'Pau Gasol'
and temporada = '04/05';

-- 10. Mostrar el número de puntos de cada jugador en toda su carrera.
select nombre, Round(Sum(Puntos_por_partido)) as Puntos_en_Carrera
from jugadores, estadisticas
where codigo = jugador
group by nombre;

-- 11. Mostrar el número de jugadores de cada equipo.
select count(j.Nombre_equipo) as Cant_Jugadores, e.nombre 
from jugadores j, equipos e
where j.Nombre_equipo = e.nombre
group by e.nombre;

-- 12. Mostrar el jugador que más puntos ha realizado en toda su carrera.
select j.nombre, round(SUM(e.Puntos_por_partido))
from jugadores j, estadisticas e
where j.codigo = e.jugador
group by e.jugador
order by ROUND(SUM(puntos_por_partido)) desc limit 1;

-- 13. Mostrar el nombre del equipo, conferencia y división del jugador más alto de la NBA.
select nombre_equipo, conferencia, division, altura 
from equipos e, jugadores j 
where e.nombre=j.nombre_equipo 
and altura=(select MAX(altura) from jugadores);

-- 14. Mostrar la media de puntos en partidos de los equipos de la división Pacific.
select avg(puntos) as Promedio_Puntos_Pacific
from (select puntos_local As puntos
from partidos
inner join equipos on partidos.equipo_local = equipos.nombre
    WHERE equipos.division = 'Pacific'
    UNION ALL
    SELECT puntos_visitante AS puntos
    FROM partidos
    INNER JOIN equipos ON partidos.equipo_visitante = equipos.nombre
    WHERE equipos.division = 'Pacific'
) AS subconsulta;

-- 15. Mostrar el partido o partidos (equipo_local, equipo_visitante y diferencia) con mayor diferencia de puntos.
SELECT codigo, equipo_local, equipo_visitante, ABS(puntos_local - puntos_visitante) AS diferencia
FROM partidos
ORDER BY diferencia DESC
LIMIT 9;

-- 17. Mostrar los puntos de cada equipo en los partidos, tanto de local como de visitante.
SELECT equipo, sum(puntos) FROM
(SELECT equipo_local as equipo, sum(puntos_local) as puntos 
FROM partidos 
WHERE equipo_local in (SELECT nombre FROM equipos) GROUP BY equipo_local 
union
SELECT equipo_visitante as equipo, sum(puntos_visitante) as puntos 
FROM partidos 
WHERE equipo_visitante in (SELECT nombre FROM equipos) GROUP BY equipo_visitante) t GROUP BY equipo;

-- 18. Mostrar quien gana en cada partido (codigo, equipo_local, equipo_visitante, equipo_ganador), en caso de empate sera null.
select codigo, equipo_local, puntos_local, puntos_visitante, equipo_visitante,
case
when puntos_local > puntos_visitante then equipo_local
when puntos_visitante > puntos_local then equipo_visitante
else null
end as equipo_ganador
from partidos;

