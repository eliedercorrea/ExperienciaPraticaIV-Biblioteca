-- 20_selects.sql
SET search_path TO biblioteca;

-- 1
SELECT id, titulo, ano_publicacao FROM livros ORDER BY titulo ASC;

-- 2
SELECT id, titulo, ano_publicacao FROM livros ORDER BY ano_publicacao ASC LIMIT 3;

-- 3
SELECT l.titulo, l.ano_publicacao, c.nome AS categoria
FROM livros l
JOIN categorias c ON c.id = l.id_categoria
WHERE c.nome = 'Fantasia' AND l.ano_publicacao > 1990
ORDER BY l.ano_publicacao DESC;

-- 4
SELECT cli.nome, cli.email, ex.codigo_tombo, li.titulo, emp.data_prevista
FROM emprestimos emp
JOIN clientes cli    ON cli.id = emp.id_cliente
JOIN exemplares ex   ON ex.id  = emp.id_exemplar
JOIN livros li       ON li.id  = ex.id_livro
WHERE emp.data_devolucao IS NULL
ORDER BY emp.data_prevista;

-- 5
SELECT li.titulo, COUNT(ex.id) AS qtd_exemplares
FROM livros li
LEFT JOIN exemplares ex ON ex.id_livro = li.id
GROUP BY li.titulo
ORDER BY qtd_exemplares DESC, li.titulo;

-- 6
SELECT cli.nome, li.titulo, emp.data_prevista, emp.data_devolucao, emp.multa
FROM emprestimos emp
JOIN clientes cli ON cli.id = emp.id_cliente
JOIN exemplares ex ON ex.id = emp.id_exemplar
JOIN livros li ON li.id = ex.id_livro
WHERE emp.data_devolucao IS NOT NULL AND emp.data_devolucao > emp.data_prevista;

-- 7
SELECT li.titulo, a.nome AS autor, e.nome AS editora, c.nome AS categoria
FROM livros li
JOIN autores a   ON a.id = li.id_autor
JOIN editoras e  ON e.id = li.id_editora
JOIN categorias c ON c.id = li.id_categoria
ORDER BY autor, li.titulo;

-- 8
SELECT id, titulo FROM livros WHERE titulo ILIKE '%casmurro%';
