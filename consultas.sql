use mega;
SET optimizer_switch='index_merge=off';

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

/* Detalle completo de pedidos para uno específico*/
Select p.*, d.*
from pedidos p, detalles_pedido d
where p.id = d.pedido_id
and d.pedido_id = 3509;

Select p.*, d.*
from pedidos p ignore index(Primary), detalles_pedido d force index (Primary) /* le forzamos que utilice el indice primary en detalles_pedido e ignore el indice Primary en Pedidos */
where p.id = d.pedido_id
and d.pedido_id = 3509;


Select p.*, d.*
from pedidos p use index(Primary), detalles_pedido d /* le sugerimos que utilice el index primary) */
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

/* cantidad y monto por tipo para la provincia Buenos Aires*/
Select c.provincia, c.tipo, sum(d.cantidad * pr.precio) as totalPedido
from  detalles_pedido d, pedidos p , productos pr, clientes c 
where p.id = d.pedido_id
and d.producto_id = pr.id
and p.cliente_id = c.id
and c.provincia = "Buenos Aires"
group by c.provincia, c.tipo;

