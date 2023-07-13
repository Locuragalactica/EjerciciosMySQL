-- 1. Mostrar el nombre de todos los pokemon.
select nombre 
from pokemon;

-- 2. Mostrar los pokemon que pesen menos de 10k.
select nombre 
from pokemon
where peso < 10;

-- 3. Mostrar los pokemon de tipo agua.
select nombre, numero_pokedex
from pokemon
where numero_pokedex in (select numero_pokedex from pokemon_tipo where id_tipo = (
select id_tipo from tipo where nombre like 'agua'));

-- 4. Mostrar los pokemon de tipo agua, fuego o tierra ordenados por tipo.
select p.nombre, t.nombre as tipo
from pokemon as p
join pokemon_tipo as pt on p.numero_pokedex = pt.numero_pokedex
join tipo as t on pt.id_tipo = t.id_tipo
where t.nombre in ('agua', 'fuego', 'tierra')
order by t.nombre;

-- 5. Mostrar los pokemon que son de tipo fuego y volador.
select p.nombre, t.nombre as tipo
from pokemon as p
join pokemon_tipo as pt on p.numero_pokedex = pt.numero_pokedex
join tipo as t on pt.id_tipo = t.id_tipo
where t.nombre in ('fuego', 'volador');

-- 6. Mostrar los pokemon con una estadística base de ps mayor que 200.
select p.nombre, eb.ps as Estadistica_Base
from pokemon p
join estadisticas_base eb 
on p.numero_pokedex = eb.numero_pokedex
where eb.ps > 200;

-- 7. Mostrar los datos (nombre, peso, altura) de la prevolución de Arbok.
select * 
from pokemon
where nombre like 'Arbok';

-- 8. Mostrar aquellos pokemon que evolucionan por intercambio.
select p.nombre, p.numero_pokedex, te.id_tipo_evolucion, te.tipo_evolucion
from pokemon p
join pokemon_forma_evolucion pfe on p.numero_pokedex = pfe.numero_pokedex
join forma_evolucion fe on pfe.id_forma_evolucion = fe.id_forma_evolucion
join tipo_evolucion te on fe.tipo_evolucion = te.id_tipo_evolucion
where te.tipo_evolucion like 'intercambio';

-- 9. Mostrar el nombre del movimiento con más prioridad.
select nombre, prioridad
from movimiento
order by prioridad desc limit 1;

-- 10. Mostrar el pokemon más pesado.
select nombre, peso
from pokemon
order by peso desc limit 1;

-- 11. Mostrar el nombre y tipo del ataque con más potencia.
select m.nombre, ta.tipo, m.potencia
from movimiento m 
join tipo t on m.id_tipo = t.id_tipo
join tipo_ataque ta on t.id_tipo_ataque = ta.id_tipo_ataque
order by potencia desc limit 1;

-- 12. Mostrar el número de movimientos de cada tipo.
select count(m.id_movimiento) as Cantidad_Movimientos, t.nombre
from movimiento m
join tipo t on m.id_tipo = t.id_tipo
group by t.id_tipo;

-- 13. Mostrar todos los movimientos que puedan envenenar.
select nombre, descripcion
from movimiento
where descripcion like '%env%';

-- 14. Mostrar todos los movimientos que causan daño, ordenados alfabéticamente por nombre.
select nombre, descripcion
from movimiento
where descripcion like '%daño%'
order by nombre asc;

-- 15. Mostrar todos los movimientos que aprende pikachu.
select p.nombre, m.nombre, m.descripcion
from pokemon p
join pokemon_tipo pt on p.numero_pokedex = pt.numero_pokedex
join tipo t on pt.id_tipo = t.id_tipo
join movimiento m on t.id_tipo = m.id_tipo
where p.nombre like 'Pikachu';

-- 16. Mostrar todos los movimientos que aprende pikachu por MT (tipo de aprendizaje).
select p.nombre, m.nombre, m.descripcion, tfa.tipo_aprendizaje, fa.id_forma_aprendizaje
from pokemon p
join pokemon_movimiento_forma pmf on p.numero_pokedex = pmf.numero_pokedex
join movimiento m on pmf.id_movimiento = m.id_movimiento
join forma_aprendizaje fa on pmf.id_forma_aprendizaje = fa.id_forma_aprendizaje
join tipo_forma_aprendizaje tfa on fa.id_tipo_aprendizaje = tfa.id_tipo_aprendizaje
where tfa.tipo_aprendizaje like 'MT'
and p.nombre like 'Pikachu';

-- 17. Mostrar todos los movimientos de tipo normal que aprende pikachu por nivel.
select p.nombre, m.nombre, m.descripcion, tfa.tipo_aprendizaje, t.nombre as Tipo_Movimiento
from pokemon p
join pokemon_movimiento_forma pmf on p.numero_pokedex = pmf.numero_pokedex
join movimiento m on pmf.id_movimiento = m.id_movimiento
join forma_aprendizaje fa on pmf.id_forma_aprendizaje = fa.id_forma_aprendizaje
join tipo_forma_aprendizaje tfa on fa.id_tipo_aprendizaje = tfa.id_tipo_aprendizaje
join tipo t on m.id_tipo = t.id_tipo
where tfa.tipo_aprendizaje like 'Nivel'
and p.nombre like 'Pikachu'
and t.nombre like 'Normal';

-- 18. Mostrar todos los movimientos de efecto secundario cuya probabilidad sea mayor al 30%.
select m.nombre, mes.probabilidad
from movimiento m
join movimiento_efecto_secundario mes on m.id_movimiento = mes.id_movimiento
where mes.probabilidad>=30;

-- 19. Mostrar todos los pokemon que evolucionan por piedra.
select p.numero_pokedex, p.nombre, te.tipo_evolucion
from pokemon p
join pokemon_forma_evolucion pfe on p.numero_pokedex = pfe.numero_pokedex
join forma_evolucion fe on pfe.id_forma_evolucion = fe.id_forma_evolucion
join tipo_evolucion te on fe.tipo_evolucion = te.id_tipo_evolucion
where te.tipo_evolucion like 'Piedra';

-- 20. Mostrar todos los pokemon que no pueden evolucionar.
select p.nombre, pfe.id_forma_evolucion
from pokemon p
left join pokemon_forma_evolucion pfe on p.numero_pokedex = pfe.numero_pokedex
where pfe.numero_pokedex is null;

-- 21. Mostrar la cantidad de los pokemon de cada tipo.
select count(pt.numero_pokedex) as Cantidad_Pokemones, t.nombre
from pokemon_tipo pt
join tipo t on pt.id_tipo = t.id_tipo
group by t.nombre;