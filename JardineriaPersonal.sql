-- 1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.
select codigo_oficina, ciudad 
from oficina;

-- 2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España.
select ciudad, telefono
from oficina
where pais = 'España';

-- 3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.
select nombre, apellido1, apellido2, email
from empleado
where codigo_jefe = 7;

-- 4. Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.
select puesto, nombre, apellido1, apellido2, email
from empleado 
where puesto = 'Director General';

-- 5. Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.
select puesto, nombre, apellido1, apellido2
from empleado
where puesto != ('Representante Ventas');

-- 6. Devuelve un listado con el nombre de los todos los clientes españoles.
select nombre_cliente, pais
from cliente
where pais = 'Spain';

-- 7. Devuelve un listado con los distintos estados por los que puede pasar un pedido.
select distinct estado as Estados
from pedido;

-- 8. Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008. 
-- Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan repetidos. Resuelva la consulta:
-- Utilizando la función YEAR de MySQL.
-- Utilizando la función DATE_FORMAT de MySQL.
-- Sin utilizar ninguna de las funciones anteriores.
select codigo_cliente
from pago
where year (fecha_pago) = 2008
group by codigo_cliente;

select  codigo_cliente
from pago
where date_format(fecha_pago, '%Y') = '2008'
group by codigo_cliente;

select codigo_cliente
from pago
where fecha_pago >= '2008-01-01' and fecha_pago <= '2008-12-31'
group by codigo_cliente;

-- 9. Devuelve un listado con el código de pedido, código de cliente, 
-- fecha esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo.
select codigo_pedido, codigo_cliente,fecha_esperada,fecha_entrega
from pedido
where fecha_esperada < fecha_entrega;

-- 10. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de
-- entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.
-- Utilizando la función ADDDATE de MySQL.
-- Utilizando la función DATEDIFF de MySQL.
select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
from pedido
where fecha_entrega <= ADDDATE(fecha_esperada, -2);

select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
from pedido
where DATEDIFF(fecha_esperada, fecha_entrega) >= 2;

-- 11. Devuelve un listado de todos los pedidos que fueron rechazados en 2009.
select codigo_pedido, estado, fecha_pedido
from pedido
where year(fecha_pedido) = 2009
and estado = 'Rechazado';

-- 12. Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de cualquier año.
select * 
from pedido
where Month(fecha_entrega) = 01;

-- 13. Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. 
-- Ordene el resultado de mayor a menor.
select *
from pago
where year(fecha_pago) = 2008
and forma_pago = 'PayPal'
order by fecha_pago asc;

-- 14. Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en
-- cuenta que no deben aparecer formas de pago repetidas.
select distinct forma_pago
from pago;

-- 15. Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que
-- tienen más de 100 unidades en stock. El listado deberá estar ordenado por su precio de
-- venta, mostrando en primer lugar los de mayor precio.
select *
from producto
where gama = 'Ornamentales' 
and cantidad_en_stock > 100
order by precio_venta desc;

-- 16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo
-- representante de ventas tenga el código de empleado 11 o 30.
select *
from cliente
where ciudad = 'Madrid'
and codigo_empleado_rep_ventas in (11, 30);

-- Consultas multitabla (Composición interna)
-- Las consultas se deben resolver con INNER JOIN.

-- 1. Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.
select c.nombre_cliente, e.puesto, e.nombre, e.apellido1, e.apellido2
from cliente c 
inner join empleado e
where c.codigo_empleado_rep_ventas = e.codigo_empleado;

-- 2. Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus
-- representantes de ventas.
select distinct c.nombre_cliente, p.fecha_pago, Concat(e.nombre,' ',e.apellido1,' ', e.apellido2) as Representante_Ventas
from cliente c
inner join empleado e, pago p
where c.codigo_empleado_rep_ventas = e.codigo_empleado
and p.codigo_cliente = c.codigo_cliente;

-- Agus
select nombre_cliente,CONCAT(nombre, ' ',apellido1,' ',apellido2) 
as Rep_ventas from cliente 
inner join empleado on codigo_empleado_rep_ventas = codigo_empleado
where codigo_cliente in (select codigo_cliente from pago);

-- 3. Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de 
-- sus representantes de ventas.
select c.nombre_cliente, Concat(e.nombre,' ',e.apellido1,' ', e.apellido2) as Representante_Ventas
from cliente c
inner join empleado e on c.codigo_empleado_rep_ventas = e.codigo_empleado
where c.codigo_cliente not in (
select codigo_cliente
from pago);

-- Agus
select nombre_cliente,CONCAT(nombre, ' ',apellido1,' ',apellido2) 
as Rep_ventas from cliente 
inner join empleado on codigo_empleado_rep_ventas = codigo_empleado
where codigo_cliente not in (select codigo_cliente from pago);

-- 4. Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes
-- junto con la ciudad de la oficina a la que pertenece el representante.
select c.codigo_cliente, c.nombre_cliente, CONCAT(e.nombre, ' ',e.apellido1,' ',e.apellido2) AS Rep_ventas, o.ciudad AS oficina_rep
from cliente c
inner join empleado e
on c.codigo_empleado_rep_ventas = e.codigo_empleado
inner join oficina o
on o.codigo_oficina = e.codigo_oficina;

-- 5. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus
-- representantes junto con la ciudad de la oficina a la que pertenece el representante.
select c.nombre_cliente, Concat(e.nombre,' ',e.apellido1,' ', e.apellido2) as Representante_Ventas, o.ciudad
from cliente c
inner join empleado e 
on c.codigo_empleado_rep_ventas = e.codigo_empleado
inner join oficina o
on o.codigo_oficina = e.codigo_oficina
where c.codigo_cliente not in (
select distinct codigo_cliente
from pago);

-- 6. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.
select c.ciudad, o.linea_direccion1, o.linea_direccion2
from oficina o
inner join empleado e
on o.codigo_oficina = e.codigo_oficina
inner join cliente c
on c.codigo_empleado_rep_ventas = e.codigo_empleado
where  c.ciudad like 'Fuenlabrada';

-- 7. Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad
-- de la oficina a la que pertenece el representante.
select c.codigo_cliente, c.nombre_cliente, CONCAT(e.nombre, ' ',e.apellido1,' ',e.apellido2) AS Rep_ventas, o.ciudad AS oficina_rep
from cliente c
inner join empleado e
on c.codigo_empleado_rep_ventas = e.codigo_empleado
inner join oficina o
on o.codigo_oficina = e.codigo_oficina;

-- 8. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.
select e.codigo_empleado, concat(e.nombre,' ', e.apellido1, ' ', e.apellido2) as Empleado, e.codigo_jefe, concat(j.nombre, ' ' , j.apellido1, ' ', j.apellido2) as Jefe
from empleado e
inner join empleado j
on j.codigo_empleado = e.codigo_jefe;

-- 9. Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.
select c.nombre_cliente, p.fecha_esperada, p.fecha_entrega
from pedido p
inner join cliente c
on p.codigo_cliente = c.codigo_cliente
where fecha_entrega > fecha_esperada; 

-- 10. Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.
select c.nombre_cliente, group_concat(distinct g.gama separator ', ') as Gamas_Producto
from cliente c
inner join pedido p
on c.codigo_cliente = p.codigo_cliente
inner join detalle_pedido dp
on p.codigo_pedido = dp.codigo_pedido
inner join producto pr
on dp.codigo_producto = pr.codigo_producto
inner join gama_producto g
on g.gama = pr.gama
group by c.nombre_cliente;

-- Consultas multitabla (Composición externa)
-- Resuelva todas las consultas utilizando las cláusulas LEFT JOIN, RIGHT JOIN, JOIN.

-- 1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
select c.codigo_cliente, c.nombre_cliente
from cliente c
left join pago p
on c.codigo_cliente = p.codigo_cliente
where not exists (select * from pago p where c.codigo_cliente = p.codigo_cliente);

-- 2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.
select c.codigo_cliente, c.nombre_cliente
from cliente c
left join pedido p
on c.codigo_cliente = p.codigo_cliente
where not exists (select * from pedido p where c.codigo_cliente = p.codigo_cliente);

-- 3. Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que
-- no han realizado ningún pedido.
select c.codigo_cliente, c.nombre_cliente
from cliente c
left join pago p
on c.codigo_cliente = p.codigo_cliente
left join pedido pd
on c.codigo_cliente = pd.codigo_cliente
where not exists (select * from pago p, pedido pd 
				  where c.codigo_cliente = p.codigo_cliente 
                  and c.codigo_cliente = pd.codigo_cliente);
                  
-- 4. Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.
select e.nombre, o.codigo_oficina
from empleado e
left join oficina o
on e.codigo_oficina = o.codigo_oficina
where not exists ( select * from oficina o where e.codigo_oficina = o.codigo_oficina);

-- 5. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.
select *
from empleado e
left join cliente c
on e.codigo_empleado = c.codigo_empleado_rep_ventas
where not exists ( select * from cliente c where e.codigo_empleado = c.codigo_empleado_rep_ventas);

-- 6. Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los
-- que no tienen un cliente asociado.
select e.nombre, o.codigo_oficina, c.nombre_cliente
from empleado e
left join oficina o 
on e.codigo_oficina = o.codigo_oficina
left join cliente c 
on e.codigo_empleado = c.codigo_empleado_rep_ventas
where o.codigo_oficina is null 
and c.codigo_empleado_rep_ventas is null;

-- 7. Devuelve un listado de los productos que nunca han aparecido en un pedido.
select *
from producto p
left join detalle_pedido dp
on p.codigo_producto = dp.codigo_producto
where not exists (select * from detalle_pedido where p.codigo_producto = dp.codigo_producto);

-- 8. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los
-- representantes de ventas de algún cliente que haya realizado la compra de algún producto
-- de la gama Frutales.

-- 9. Devuelve un listado con los clientes que han realizado algún pedido, pero no han realizado ningún pago.

-- 10. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de su jefe asociado.

-- Consultas resumen
-- 1. ¿Cuántos empleados hay en la compañía?
select count(*) as Cantidad_Empleados
from empleado;

-- 2. ¿Cuántos clientes tiene cada país?
select count(codigo_cliente) as Cantidad_Clientes, pais
from cliente
group by pais;

-- 3. ¿Cuál fue el pago medio en 2009?
select avg(total) as Pago_Medio_2009
from pago
where fecha_pago like '%2009%';

-- 4. ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el número de pedidos.
select count(codigo_pedido) as Cantidad_pedidos, estado
from pedido
group by estado
order by Cantidad_pedidos desc;

-- 5. Calcula el precio de venta del producto más caro y más barato en una misma consulta.
select max(precio_venta) as Precio_Max, min(precio_venta) as Precio_Min
from producto;

-- 6. Calcula el número de clientes que tiene la empresa.
select count(*) as Cantidad_Clientes
from cliente;

-- 7. ¿Cuántos clientes tiene la ciudad de Madrid?
select count(*) as Cantidad_Clientes, ciudad
from cliente 
where ciudad = 'Madrid';

-- 8. ¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?
select count(codigo_cliente) as Cantidad_Clientes, ciudad
from cliente
where ciudad like 'M%'
group by ciudad;

-- 9. Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende cada uno.
select e.nombre, count(c.codigo_empleado_rep_ventas) as Cantidad_Clientes
from empleado e
inner join cliente c
on e.codigo_empleado = c.codigo_empleado_rep_ventas
group by c.codigo_empleado_rep_ventas;

-- 10. Calcula el número de clientes que no tiene asignado representante de ventas.
select count(c.codigo_cliente) as Cantidad_Clientes
from empleado e
inner join cliente c
on e.codigo_empleado = c.codigo_empleado_rep_ventas
where e.codigo_empleado != c.codigo_empleado_rep_ventas;

-- 11. Calcula la fecha del primer y último pago realizado por cada uno de los clientes. El listado
-- deberá mostrar el nombre y los apellidos de cada cliente.
select c.nombre_contacto, c.apellido_contacto, min(p.fecha_pago) as Primer_Pago, max(p.fecha_pago) as Ultimo_Pago
from cliente c
inner join pago p
on c.codigo_cliente = p.codigo_cliente
group by c.codigo_cliente;

-- 12. Calcula el número de productos diferentes que hay en cada uno de los pedidos.
select count(codigo_producto) as Cantidad_Productos, codigo_pedido as Pedidos
from detalle_pedido 
group by codigo_pedido;

-- 13. Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de los pedidos.
select sum(cantidad) as Cantidad_Productos, codigo_pedido as Pedidos
from detalle_pedido 
group by codigo_pedido;

-- 14. Devuelve un listado de los 20 productos más vendidos y el número total de unidades que
-- se han vendido de cada uno. El listado deberá estar ordenado por el número total de unidades vendidas.
select sum(dp.cantidad) as Cantidad_Unidades, dp.codigo_producto, p.nombre
from detalle_pedido dp
inner join producto p
on dp.codigo_producto = p.codigo_producto
group by dp.codigo_producto 
order by Cantidad_Unidades desc limit 20;

-- 15. La facturación que ha tenido la empresa en toda la historia, indicando la base imponible, el
-- IVA y el total facturado. La base imponible se calcula sumando el coste del producto por el
-- número de unidades vendidas de la tabla detalle_pedido. El IVA es el 21 % de la base
-- imponible, y el total la suma de los dos campos anteriores.
select sum(precio_unidad * Cantidad) as BaseImponible,
       sum(precio_unidad * Cantidad * 0.21) as IVA,
       sum(precio_unidad * Cantidad) + sum(precio_unidad * Cantidad * 0.21) as TotalFacturado
from detalle_pedido;

-- 16. La misma información que en la pregunta anterior, pero agrupada por código de producto.
select sum(dp.precio_unidad * Cantidad) as BaseImponible,
       sum(dp.precio_unidad * Cantidad * 0.21) as IVA,
       sum(dp.precio_unidad * Cantidad) + sum(precio_unidad * Cantidad * 0.21) as TotalFacturado,
       p.nombre
from detalle_pedido dp
inner join producto p
on dp.codigo_producto = p.codigo_producto
group by dp.codigo_producto;

-- 17. La misma información que en la pregunta anterior, pero agrupada por código de producto filtrada por los códigos que empiecen por OR.
select sum(dp.precio_unidad * Cantidad) as BaseImponible,
       sum(dp.precio_unidad * Cantidad * 0.21) as IVA,
       sum(dp.precio_unidad * Cantidad) + sum(precio_unidad * Cantidad * 0.21) as TotalFacturado,
       p.nombre,
       dp.codigo_producto
from detalle_pedido dp
inner join producto p
on dp.codigo_producto = p.codigo_producto
where dp.codigo_producto like 'OR%'
group by dp.codigo_producto;

-- 18. Lista las ventas totales de los productos que hayan facturado más de 3000 euros. Se
-- mostrará el nombre, unidades vendidas, total facturado y total facturado con impuestos (21% IVA)
select  p.nombre as Producto, sum(dp.cantidad) as Cantidad, dp.codigo_producto,
	   sum(dp.precio_unidad * Cantidad) as BaseImponible,
       sum(dp.precio_unidad * Cantidad * 0.21) as IVA,
       sum(dp.precio_unidad * Cantidad) + sum(precio_unidad * Cantidad * 0.21) as TotalFacturado
from detalle_pedido dp
inner join producto p
on dp.codigo_producto = p.codigo_producto
group by dp.codigo_producto
having sum(dp.precio_unidad * Cantidad)>3000;       

-- Subconsultas con operadores básicos de comparación

-- 1. Devuelve el nombre del cliente con mayor límite de crédito.
select nombre_cliente, limite_credito
from cliente
order by limite_credito desc limit 1;

-- 2. Devuelve el nombre del producto que tenga el precio de venta más caro.
select nombre, precio_venta
from producto
order by precio_venta desc limit 1;

-- 3. Devuelve el nombre del producto del que se han vendido más unidades. (Tenga en cuenta
-- que tendrá que calcular cuál es el número total de unidades que se han vendido de cada
-- producto a partir de los datos de la tabla detalle_pedido. Una vez que sepa cuál es el código
-- del producto, puede obtener su nombre fácilmente.)
select sum(dp.cantidad) as Cantidad_Unidades, dp.codigo_producto, p.nombre
from detalle_pedido dp
inner join producto p
on dp.codigo_producto = p.codigo_producto
group by dp.codigo_producto 
order by Cantidad_Unidades desc limit 1;

-- 4. Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar INNER JOIN).
select nombre_cliente, limite_credito, ( select coalesce(sum(total), 0) from pago where codigo_cliente = cliente.codigo_cliente) as TotalPagos
from Cliente
where limite_credito > (
    select coalesce(SUM(total), 0)
    from Pago
    where codigo_cliente = cliente.codigo_cliente );
    
-- 5. Devuelve el producto que más unidades tiene en stock.
select nombre, cantidad_en_stock
from producto
order by cantidad_en_stock desc limit 1;

-- 6. Devuelve el producto que menos unidades tiene en stock.
select nombre, cantidad_en_stock
from producto
order by cantidad_en_stock asc limit 1;

-- 7. Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto Soria.
select concat(e.nombre,' ',e.apellido1, ' ', e.apellido2) as Nombre_Empleado, e.email, concat(j.nombre,' ', j.apellido1) as Nombre_Jefe
from empleado e
inner join empleado j
on j.codigo_empleado = e.codigo_jefe
where j.nombre ='Alberto' and j.apellido1='Soria';

-- Subconsultas con ALL y ANY
-- 1. Devuelve el nombre del cliente con mayor límite de crédito.
select nombre_cliente, limite_credito
from cliente
where limite_credito >= all (
    select limite_credito
    from cliente); 
    
-- 2. Devuelve el nombre del producto que tenga el precio de venta más caro.
select nombre, precio_venta
from producto
where precio_venta >= all (
    select precio_venta
    from producto);
    
-- 3. Devuelve el producto que menos unidades tiene en stock.
select nombre, cantidad_en_stock
from producto
where cantidad_en_stock <= all (
    select cantidad_en_stock
    from producto);

-- Subconsultas con IN y NOT IN
-- 1. Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún cliente.
select concat(nombre,' ', apellido1,' ', apellido2) as Nombre_Empleado, puesto
from empleado
where codigo_empleado not in (
    select distinct codigo_empleado_rep_ventas
    from cliente);
    
-- 2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
select nombre_cliente
from cliente
where codigo_cliente not in (
    select distinct codigo_cliente
    from pago);
    
-- 3. Devuelve un listado que muestre solamente los clientes que sí han realizado un pago.
select nombre_cliente
from cliente
where codigo_cliente  in (
    select distinct codigo_cliente
    from pago);
    
-- 4. Devuelve un listado de los productos que nunca han aparecido en un pedido.
select *
from producto
where codigo_producto not in (
    select distinct codigo_producto
    from detalle_pedido);
    
-- 5. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante de ventas de ningún cliente.
select concat(nombre,' ', apellido1,' ', apellido2) as Nombre_Empleado, puesto, telefono
from empleado, oficina
where codigo_empleado not in (
    select distinct codigo_empleado_rep_ventas
    from cliente);
    
-- Subconsultas con EXISTS y NOT EXISTS
-- 1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
select *
from cliente c
where not exists (
    select *
    from pago p
    where p.codigo_cliente = c.codigo_cliente); 
    
-- 2. Devuelve un listado que muestre solamente los clientes que sí han realizado ningún pago.
select *
from cliente c
where exists (select * from pago p where p.codigo_cliente = c.codigo_cliente);

-- 3. Devuelve un listado de los productos que nunca han aparecido en un pedido.
select * 
from producto pr
where not exists (select * from detalle_pedido dp where pr.codigo_producto = dp.codigo_producto);

-- 4. Devuelve un listado de los productos que han aparecido en un pedido alguna vez.
select * 
from producto pr
where exists (select * from detalle_pedido dp where pr.codigo_producto = dp.codigo_producto);



