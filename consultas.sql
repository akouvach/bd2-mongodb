use mega;
/* cantidad de registros por tabla */
select 'clientes' as det, count(1) as cant from clientes
union all 
select 'productos' as det, count(1) as cant from productos
union all 
select 'pedidos' as det, count(1) as cant from pedidos
union all 
select 'detalles_pedido' as det, count(1) as cant from detalles_pedido;

/* Detalle completo de pedidos */
Select p.*, d.*
from pedidos p, detalles_pedido d
where p.id = d.pedido_id;
/*order by d.producto_id;*/

/* Detalle completo de pedidos con las descripciones de clientes y productos con natural join */
Select p.*, d.*, pr.*, c.*
from pedidos p, detalles_pedido d, productos pr, clientes c
where p.id = d.pedido_id
and d.producto_id = pr.id
and p.cliente_id = c.id;

/* Detalle completo de pedidos con las descripciones de clientes y productos con inner join*/
Select p.*, d.*, pr.*, c.*
from pedidos p inner join detalles_pedido d on (p.id = d.pedido_id)
inner join productos pr on (d.producto_id = pr.id) 
inner join clientes c on (p.cliente_id = c.id);




Select p.id, count(d.pedido_id) as cantProd
from pedidos p, detalles_pedido d
where p.id = d.pedido_id
group by p.id

