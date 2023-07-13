-- CANDADO A
-- Posición: El candado A está ubicado en la posición calculada a partir del número obtenido en la/s siguiente/s consulta/s:
-- Teniendo el máximo de asistencias por partido, muestre cuantas veces se logró dicho máximo.

select count(*)
from estadisticas
where asistencias_por_partido = (
select max(asistencias_por_partido)
from estadisticas
);

-- Clave: La clave del candado A estará con formada por la/s siguientes consulta/s a la base de datos:
-- Muestre la suma total del peso de los jugadores, donde la conferencia sea Este y la posición sea
-- centro o esté comprendida en otras posiciones.

select sum(Peso)
from jugadores j, equipos e
where (j.Nombre_equipo = e.Nombre and e.Conferencia = 'East')
and j.Posicion like '%C%';


-- CANDADO B
-- Posición: El candado B está ubicado en la posición calculada a partir del número obtenido en la/s siguiente/s consulta/s:
-- Muestre la cantidad de jugadores que poseen más asistencias por partidos, que el numero de
-- jugadores que tiene el equipo Heat.

select count(*)  
from estadisticas
where asistencias_por_partido > (
select count(*) 
from jugadores 
where nombre_equipo = 'Heat');

-- Clave: La clave del candado B estará con formada por la/s siguientes consulta/s a la base de datos:
-- La clave será igual al conteo de partidos jugados durante las temporadas del año 1999.

select count(*)
from partidos
where temporada like '%99%';

-- CANDADO C
-- Posición: El candado C está ubicado en la posición calculada a partir del número obtenido en la/s siguiente/s consulta/s:
-- La posición del código será igual a la cantidad de jugadores que proceden de Michigan y forman
-- parte de equipos de la conferencia oeste.
-- Al resultado obtenido lo dividiremos por la cantidad de jugadores cuyo peso es mayor o igual a 195, y a eso le vamos a sumar 0.9945.

select count(*) / (select count(*) 
from jugadores
where peso >= 195) + 0.9945 as posicion  
from jugadores 
join equipos on jugadores.nombre_equipo = equipos.nombre 
where jugadores.procedencia = 'michigan' and equipos.conferencia = 'west';

-- Clave: La clave del candado C estará con formada por la/s siguientes consulta/s a la base de datos:
-- Para obtener el siguiente código deberás redondear hacia abajo el resultado que se devuelve de
-- sumar: el promedio de puntos por partido, el conteo de asistencias por partido, y la suma de
-- tapones por partido. Además, este resultado debe ser, donde la división sea central.

select round(avg(e.Puntos_por_partido) + count(e.Asistencias_por_partido) + sum(e.Tapones_por_partido)) as suma_total_candadoC
from estadisticas e
inner join jugadores j
on e.jugador = j.codigo
inner join equipos eq
on j.Nombre_equipo = eq.nombre
where eq.Division = 'Central';

-- CANDADO D
-- Posición: El candado D está ubicado en la posición calculada a partir del número obtenido en la/s siguiente/s consulta/s:
-- Muestre los tapones por partido del jugador Corey Maggette durante la temporada 00/01. Este
-- resultado debe ser redondeado. Nota: el resultado debe estar redondeado

select tapones_por_partido as posicion 
from estadisticas 
join jugadores on estadisticas.jugador = jugadores.codigo
where jugadores.nombre = 'corey maggette' and estadisticas.temporada = '00/01';

-- Clave: La clave del candado D estará con formada por la/s siguientes consulta/s a la base de datos:
-- Para obtener el siguiente código deberás redondear hacia abajo, la suma de puntos por partido
-- de todos los jugadores de procedencia argentina.

select floor(sum(puntos_por_partido)) 
from estadisticas
join jugadores on estadisticas.jugador = jugadores.codigo
where jugadores.procedencia = 'argentina';





