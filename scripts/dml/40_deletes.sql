-- 40_deletes.sql
SET search_path TO biblioteca;

DELETE FROM reservas
 WHERE status = 'cancelada'
   AND data_reserva < (CURRENT_DATE - INTERVAL '90 day');

DELETE FROM clientes c
 WHERE NOT EXISTS (SELECT 1 FROM emprestimos e WHERE e.id_cliente = c.id)
   AND NOT EXISTS (SELECT 1 FROM reservas r WHERE r.id_cliente = c.id);

DELETE FROM exemplares ex
 WHERE ex.status='manutencao'
   AND NOT EXISTS (SELECT 1 FROM emprestimos e WHERE e.id_exemplar = ex.id);
