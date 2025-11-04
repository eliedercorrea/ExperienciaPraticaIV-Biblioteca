-- 21_selects_avancados.sql
SET search_path TO biblioteca;

-- 1) Empréstimos em aberto com dias de atraso e multa estimada
SELECT cli.nome, ex.codigo_tombo, li.titulo,
       emp.data_prevista,
       GREATEST(0, CURRENT_DATE - emp.data_prevista) AS dias_em_atraso,
       GREATEST(0, CURRENT_DATE - emp.data_prevista) * 1.50 AS multa_estimativa
FROM emprestimos emp
JOIN clientes   cli ON cli.id = emp.id_cliente
JOIN exemplares ex  ON ex.id  = emp.id_exemplar
JOIN livros     li  ON li.id  = ex.id_livro
WHERE emp.data_devolucao IS NULL
ORDER BY dias_em_atraso DESC, emp.data_prevista;

-- 2) Ocupação por livro (emprestados/total)
SELECT li.titulo,
       COUNT(ex.id)                                                   AS total_exemplares,
       SUM(CASE WHEN ex.status='emprestado' THEN 1 ELSE 0 END)       AS emprestados,
       ROUND( (100.0 * SUM(CASE WHEN ex.status='emprestado' THEN 1 ELSE 0 END)) / NULLIF(COUNT(ex.id),0), 2) AS taxa_ocupacao_pct
FROM livros li
LEFT JOIN exemplares ex ON ex.id_livro = li.id
GROUP BY li.titulo
ORDER BY taxa_ocupacao_pct DESC NULLS LAST, li.titulo;

-- 3) Livros nunca emprestados
SELECT li.titulo
FROM livros li
WHERE NOT EXISTS (
  SELECT 1
  FROM exemplares ex
  WHERE ex.id_livro = li.id
    AND EXISTS (SELECT 1 FROM emprestimos emp WHERE emp.id_exemplar = ex.id)
)
ORDER BY li.titulo;

-- 4) Ranking de autores por quantidade de livros
SELECT a.nome AS autor, COUNT(l.id) AS qtd_livros
FROM autores a
LEFT JOIN livros l ON l.id_autor = a.id
GROUP BY a.nome
ORDER BY qtd_livros DESC, autor;

-- 5) Ranking de autores por quantidade de empréstimos
SELECT a.nome AS autor, COUNT(emp.id) AS qtd_emprestimos
FROM autores a
LEFT JOIN livros l      ON l.id_autor = a.id
LEFT JOIN exemplares ex ON ex.id_livro = l.id
LEFT JOIN emprestimos emp ON emp.id_exemplar = ex.id
GROUP BY a.nome
ORDER BY qtd_emprestimos DESC, autor;

-- 6) Top 5 clientes por empréstimos nos últimos 90 dias
SELECT cli.nome, COUNT(emp.id) AS qtd_90d
FROM clientes cli
LEFT JOIN emprestimos emp ON emp.id_cliente = cli.id
                         AND emp.data_emprestimo >= CURRENT_DATE - INTERVAL '90 day'
GROUP BY cli.nome
ORDER BY qtd_90d DESC, cli.nome
LIMIT 5;

-- 7) Tempo médio (em dias) de devolução de empréstimos concluídos
SELECT ROUND(AVG(emp.data_devolucao - emp.data_emprestimo), 2) AS media_dias
FROM emprestimos emp
WHERE emp.data_devolucao IS NOT NULL;

-- 8) Tempo médio de empréstimo por categoria
SELECT c.nome AS categoria,
       ROUND(AVG(emp.data_devolucao - emp.data_emprestimo), 2) AS media_dias
FROM emprestimos emp
JOIN exemplares ex ON ex.id = emp.id_exemplar
JOIN livros li     ON li.id = ex.id_livro
JOIN categorias c  ON c.id  = li.id_categoria
WHERE emp.data_devolucao IS NOT NULL
GROUP BY c.nome
ORDER BY media_dias DESC;

-- 9) Reservas ativas com posição na fila
WITH r AS (
  SELECT r.*,
         ROW_NUMBER() OVER (PARTITION BY r.id_exemplar ORDER BY r.data_reserva) AS pos_fila
  FROM reservas r
  WHERE r.status = 'ativa'
)
SELECT r.id, cli.nome, ex.codigo_tombo, r.data_reserva, r.pos_fila
FROM r
JOIN clientes   cli ON cli.id = r.id_cliente
JOIN exemplares ex  ON ex.id  = r.id_exemplar
ORDER BY ex.codigo_tombo, r.pos_fila;

-- 10) Multa total por mês
SELECT TO_CHAR(date_trunc('month', emp.data_devolucao), 'YYYY-MM') AS mes,
       SUM(emp.multa) AS total_multas
FROM emprestimos emp
WHERE emp.data_devolucao IS NOT NULL
GROUP BY mes
ORDER BY mes;

-- 11) Catálogo por editora (nº de títulos)
SELECT e.nome AS editora, COUNT(l.id) AS qtd_titulos
FROM editoras e
LEFT JOIN livros l ON l.id_editora = e.id
GROUP BY e.nome
ORDER BY qtd_titulos DESC, editora;

-- 12) Busca por termo em título/autor
SELECT li.titulo, a.nome AS autor
FROM livros li
JOIN autores a ON a.id = li.id_autor
WHERE li.titulo ILIKE '%tronos%' OR a.nome ILIKE '%martin%'
ORDER BY a.nome, li.titulo;

-- 13) Distribuição do status dos exemplares
SELECT ex.status, COUNT(*) AS qtd
FROM exemplares ex
GROUP BY ex.status
ORDER BY qtd DESC, ex.status;

-- 14) Top categorias por nº de empréstimos (ranking)
WITH base AS (
  SELECT c.nome AS categoria, COUNT(emp.id) AS qtd
  FROM categorias c
  JOIN livros li     ON li.id_categoria = c.id
  JOIN exemplares ex ON ex.id_livro = li.id
  LEFT JOIN emprestimos emp ON emp.id_exemplar = ex.id
  GROUP BY c.nome
)
SELECT categoria, qtd,
       DENSE_RANK() OVER (ORDER BY qtd DESC) AS posicao
FROM base
ORDER BY posicao, categoria;

-- 15) Próximos vencimentos (7 dias)
SELECT cli.nome, li.titulo, emp.data_prevista
FROM emprestimos emp
JOIN clientes   cli ON cli.id = emp.id_cliente
JOIN exemplares ex  ON ex.id  = emp.id_exemplar
JOIN livros     li  ON li.id  = ex.id_livro
WHERE emp.data_devolucao IS NULL
  AND emp.data_prevista BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '7 day'
ORDER BY emp.data_prevista, cli.nome;
