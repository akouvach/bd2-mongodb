use mega;
/*
Clientes, Pedidos, Productos --> detalles_pedido
*/

SHOW VARIABLES LIKE 'optimizer_switch';
/* switch off optimizations */
SET optimizer_switch='index_merge=off';
SET optimizer_switch='index_merge_union=off';
SET optimizer_switch='index_merge_sort_union=off';
SET optimizer_switch='index_merge_intersection=off';
SET optimizer_switch='engine_condition_pushdown=off';
SET optimizer_switch='index_condition_pushdown=off';
SET optimizer_switch='mrr=off';
SET optimizer_switch='mrr_cost_based=off';
SET optimizer_switch='block_nested_loop=off';
SET optimizer_switch='materialization=off';
SET optimizer_switch='semijoin=off';
SET optimizer_switch='loosescan=off';
SET optimizer_switch='firstmatch=off';
SET optimizer_switch='duplicateweedout=off';
SET optimizer_switch='subquery_materialization_cost_based=off';
SET optimizer_switch='use_index_extensions=off';
SET optimizer_switch='condition_fanout_filter=off';
SET optimizer_switch='derived_merge=off';
SET optimizer_switch='skip_scan=off';
SET optimizer_switch='hash_join=off';
SET optimizer_switch='prefer_ordering_index=off';
SET optimizer_switch='derived_condition_pushdown=off';

/* switch on optimizations */
SET optimizer_switch='index_merge=on';
SET optimizer_switch='index_merge_union=on';
SET optimizer_switch='index_merge_sort_union=on';
SET optimizer_switch='index_merge_intersection=on';
SET optimizer_switch='engine_condition_pushdown=on';
SET optimizer_switch='index_condition_pushdown=on';
SET optimizer_switch='mrr=on';
SET optimizer_switch='mrr_cost_based=on';
SET optimizer_switch='block_nested_loop=on';
SET optimizer_switch='materialization=on';
SET optimizer_switch='semijoin=on';
SET optimizer_switch='loosescan=on';
SET optimizer_switch='firstmatch=on';
SET optimizer_switch='duplicateweedout=on';
SET optimizer_switch='subquery_materialization_cost_based=on';
SET optimizer_switch='use_index_extensions=on';
SET optimizer_switch='condition_fanout_filter=on';
SET optimizer_switch='derived_merge=on';
SET optimizer_switch='skip_scan=on';
SET optimizer_switch='hash_join=on';
SET optimizer_switch='prefer_ordering_index=on';
SET optimizer_switch='derived_condition_pushdown=on';

/* reset query cache */
SET GLOBAL innodb_buffer_pool_dump_now = ON;
SET GLOBAL innodb_buffer_pool_load_now = ON;
flush tables;


OPTIMIZE TABLE pedidos;
OPTIMIZE TABLE clientes;
OPTIMIZE TABLE productos;
OPTIMIZE TABLE detalles_pedido;

ANALYZE TABLE pedidos;
ANALYZE TABLE clientes;
ANALYZE TABLE productos;
ANALYZE TABLE detalles_pedido;


SHOW INDEX FROM pedidos;

SHOW TABLE STATUS;
SHOW ENGINE INNODB STATUS;



SHOW VARIABLES LIKE 'have_query_cache';
SHOW STATUS LIKE 'Qcache%';

Select SQL_NO_CACHE pedido_id from detalles_pedido; 
       
Select SQL_NO_CACHE * from detalles_pedido;


/* cantidad de registros por tabla */
select count(*) as cantReg from clientes;


select count(1) as cantReg from clientes;

select count(provincia) as cantReg from clientes;

select count(1) as cantReg from detalles_pedido; /* 114885 */

select count(cantidad) as cantReg from detalles_pedido; /* 114885 */




select count(tipo) as cantReg from clientes
union all
select count(id) as cantReg from clientes
union all
select count('pepe2_') as cantReg from clientes;

SELECT COUNT(DISTINCT provincia) as cantReg FROM clientes;

update clientes set tipo = null where id = 2;


1 123 889
Select count(provincia) as totalRegistro, 'clientes' as nombre from clientes
union all
Select count(cantidad) as totalRegistro, 'detalles_pedido' as nombre from detalles_pedido
union all
Select count(fecha) as totalRegistro, 'pedidos' as nombre from pedidos
union all
Select count(nombre) as totalRegistro, 'productos' as nombre from productos
;


select count(1) as cant
from clientes c, pedidos p
where c.id = p.cliente_id;

/* Natural join */
select count(1) as cant
from pedidos p, detalles_pedido dp, clientes c, productos pr
where p.id = dp.pedido_id
and p.cliente_id = c.id
and dp.producto_id = pr.id;


/* Inner Join */
select count(1) as cant
from pedidos p inner join clientes c on (p.cliente_id = c.id)
inner join detalles_pedido dp on (p.id = dp.pedido_id)
inner join productos pr on (dp.producto_id = pr.id);


/* inner join */
Select * 
from clientes c inner join pedidos p on (c.id = p.cliente_id);

/*
sin fk ni indice : 85687
con fk e indice: 83112
*/




Select nombre
from clientes 
where email = 'manolanicolas@example.net'
and provincia = "Buenos Aires";

/* u$s 500 Carlo: por provincia  / Gabriel  / Johana  provincia */










/* outer join:  left right full  */

/* productos que no han sido pedido */
Select p.id, p.nombre, count(dp.producto_id) as cantPedidos
from productos p left join detalles_pedido dp on (p.id = dp.producto_id)
where dp.producto_id is null
group by p.id, p.nombre;

Select p.id, p.nombre, count(dp.producto_id) as cantPedidos
from productos p left join detalles_pedido dp on (p.id = dp.producto_id)
group by p.id, p.nombre
having count(dp.producto_id) = 0
limit 100;




Select count(nombre) as totalRegistro from productos
union all
Select count(3) as totalRegistro from productos
union all 
Select count('Afgf') as totalRegistro from productos
union all
Select count(*) as totalRegistro from productos;
















Select * from pedidos p inner join clientes c on (c.id = p.cliente_id)
where c.id = 5;

Select * from pedidos p inner join detalles_pedido dp on (p.id = dp.pedido_id)
where p.id = 5;

Select * from detalles_pedido 
where pedido_id = 4
and producto_id = 19;


Select * from pedidos p inner join detalles_pedido dp on (dp.pedido_id = p.id)
where p.id = 5;

Select p.*
from (select * from pedidos where id =5) p 
inner join 
(select * from detalles_pedido where pedido_id =5) dp 
on (p.id = dp.pedido_id);










select 'clientes' as det, count(1) as cant from clientes
union all 
select 'productos' as det, count(1) as cant from productos
union all 
select 'pedidos' as det, count(1) as cant from pedidos
union all 
select 'detalles_pedido' as det, count(1) as cant from detalles_pedido;

/* Detalle completo de pedidos */
Select dp.*, p.*, pr.*, c.*
from detalles_pedido dp
inner join pedidos p on p.id = dp.pedido_id
inner join clientes c on p.cliente_id = c.id
inner join productos pr on dp.producto_id = pr.id
limit 1000;

insert into detalles_pedido (pedido_id,producto_id,cantidad) 
values (100000,900,10);


Select * from pedidos where id = 100000;
select * from productos where id = 900;







































Select p.*, d.*
from pedidos p, detalles_pedido d
where p.id = d.pedido_id;

/* Detalle completo de pedidos para uno específico*/
Select p.*, d.*
from pedidos p, detalles_pedido d
where p.id = d.pedido_id
and d.pedido_id = 3509;










Select p.*, d.*
from pedidos p ignore index(Primary), 
	detalles_pedido d force index (Primary) /* le forzamos que utilice el indice primary en detalles_pedido e ignore el indice Primary en Pedidos */
where p.id = d.pedido_id
and d.pedido_id = 3509;


Select p.*, d.*
from pedidos p use index(Primary), 
	detalles_pedido d /* le sugerimos que utilice el index primary) */
where p.id = d.pedido_id
and p.id = 3509;

Select p.*, d.*
from pedidos p, detalles_pedido d
where p.id = 3509 and d.pedido_id = 3509;


/* Detalle completo de pedidos con las descripciones de clientes y productos con natural join */










Select p.*, d.*, pr.*, c.*
from pedidos p, detalles_pedido d, productos pr, clientes c
where p.id = d.pedido_id
and d.producto_id = pr.id
and p.cliente_id = c.id
and d.pedido_id = 3509;

/* Detalle completo de pedidos con las descripciones de clientes y productos con inner join*/



















Select p.*, d.*, pr.*, c.*
from pedidos p inner join detalles_pedido d on (p.id = d.pedido_id)
inner join productos pr on (d.producto_id = pr.id) 
inner join clientes c on (p.cliente_id = c.id)
where d.pedido_id = 3509;


/* Detalle completo de pedidos con las descripciones de clientes y productos con inner join - prefiltrado*/
Select d.*, p.*, pr.*, c.*
from (Select * from detalles_pedido where pedido_id = 3509) d inner join pedidos p on (p.id = d.pedido_id)
inner join productos pr on (d.producto_id = pr.id) 
inner join clientes c on (p.cliente_id = c.id);

/* Detalle completo de pedidos con las descripciones de clientes y productos con inner join - prefiltrado - con orden preestablecido*/
Select straight_join d.*, p.*, pr.*, c.*
from (Select * from detalles_pedido where pedido_id = 3509) d inner join pedidos p on (p.id = d.pedido_id)
inner join productos pr on (d.producto_id = pr.id) 
inner join clientes c on (p.cliente_id = c.id);

/* cantidad de productos por pedido */
Select p.id, count(d.pedido_id) as cantProd
from pedidos p, detalles_pedido d
where p.id = d.pedido_id
group by p.id;

/* importe por pedido */



















Select p.id, sum(d.cantidad * pr.precio) as totalPedido
from  detalles_pedido d, pedidos p, productos pr
where p.id = d.pedido_id
and d.producto_id = pr.id
group by p.id;


/* cantidad y monto por provincia y tipo*/





















Select c.provincia, c.tipo, sum(d.cantidad * pr.precio) as totalPedido
from  detalles_pedido d, pedidos p, productos pr, clientes c
where p.id = d.pedido_id
and d.producto_id = pr.id
and p.cliente_id = c.id
group by c.provincia, c.tipo
having totalPedido >100000000;

/* cantidad y monto por provincia y tipo para un conjunto de pedidos*/

























Select c.provincia, c.tipo, sum(d.cantidad * pr.precio) as totalPedido
from  detalles_pedido d, pedidos p, productos pr, clientes c
where p.id = d.pedido_id
and d.producto_id = pr.id
and p.cliente_id = c.id
and p.id in (3504,1,4454,676,8787,9898,2323)
group by c.provincia, c.tipo;

/* cantidad y monto por tipo para la provincia Buenos Aires*/













Select c.provincia, c.tipo, sum(d.cantidad * pr.precio) as totalPedido
from  detalles_pedido d, pedidos p , productos pr, clientes c ignore index(idx_clientes_prov)
where p.id = d.pedido_id
and d.producto_id = pr.id
and p.cliente_id = c.id
and c.provincia = "Buenos Aires"
group by c.provincia, c.tipo;

Select *
from clientes c
where provincia = 'Catamarca'
and tipo='C'
and c.email = 'azucena68@example.org';


/* cantidad y monto por tipo para la provincia Buenos Aires*/













Select c.provincia, c.tipo, sum(d.cantidad * pr.precio) as totalPedido
from  detalles_pedido d, pedidos p , productos pr, clientes c 
where p.id = d.pedido_id
and d.producto_id = pr.id
and p.cliente_id = c.id
and c.provincia = "Buenos Aires"
group by c.provincia, c.tipo;


