-- 30_updates.sql
SET search_path TO biblioteca;

UPDATE clientes
   SET telefone='(11) 95555-1234'
 WHERE email='ana.souza@example.com';

UPDATE exemplares ex
   SET status = 'reservado'
  FROM reservas r
 WHERE r.id_exemplar = ex.id
   AND ex.codigo_tombo = 'DC001'
   AND r.status = 'ativa';

UPDATE emprestimos emp
   SET multa = GREATEST(0, (CURRENT_DATE - emp.data_prevista)) * 1.50
 WHERE emp.data_devolucao IS NULL
   AND CURRENT_DATE > emp.data_prevista;
