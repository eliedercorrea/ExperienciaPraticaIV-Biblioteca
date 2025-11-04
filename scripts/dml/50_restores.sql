-- 50_restores.sql
SET search_path TO biblioteca;

INSERT INTO reservas (id_exemplar, id_cliente, data_reserva, status)
SELECT ex.id, cli.id, CURRENT_DATE - INTERVAL '100 day', 'cancelada'
  FROM exemplares ex, clientes cli
 WHERE ex.codigo_tombo = 'DC001' AND cli.email='carla.dias@example.com'
 LIMIT 1;
