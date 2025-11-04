-- 10_insert_iniciais.sql
SET search_path TO biblioteca;

INSERT INTO autores (nome) VALUES 
('J. K. Rowling'),
('George R. R. Martin'),
('Machado de Assis'),
('Clarice Lispector')
ON CONFLICT DO NOTHING;

INSERT INTO editoras (nome) VALUES 
('Rocco'),
('Leya'),
('Companhia das Letras'),
('Record')
ON CONFLICT DO NOTHING;

INSERT INTO categorias (nome) VALUES
('Fantasia'),
('Clássico'),
('Romance'),
('Conto')
ON CONFLICT DO NOTHING;

INSERT INTO clientes (nome, email, telefone) VALUES
('Ana Souza', 'ana.souza@example.com', '(11) 90000-0001'),
('Bruno Lima', 'bruno.lima@example.com', '(21) 90000-0002'),
('Carla Dias', 'carla.dias@example.com', '(31) 90000-0003'),
('Diego Alves', 'diego.alves@example.com', '(41) 90000-0004')
ON CONFLICT DO NOTHING;

INSERT INTO livros (titulo, ano_publicacao, isbn, id_autor, id_editora, id_categoria)
SELECT 'Harry Potter e a Pedra Filosofal', 1997, '978-8532511010', a.id, e.id, c.id
FROM autores a, editoras e, categorias c
WHERE a.nome='J. K. Rowling' AND e.nome='Rocco' AND c.nome='Fantasia'
ON CONFLICT DO NOTHING;

INSERT INTO livros (titulo, ano_publicacao, isbn, id_autor, id_editora, id_categoria)
SELECT 'A Guerra dos Tronos', 1996, '978-8556510789', a.id, e.id, c.id
FROM autores a, editoras e, categorias c
WHERE a.nome='George R. R. Martin' AND e.nome='Leya' AND c.nome='Fantasia'
ON CONFLICT DO NOTHING;

INSERT INTO livros (titulo, ano_publicacao, isbn, id_autor, id_editora, id_categoria)
SELECT 'Dom Casmurro', 1899, '978-8535910667', a.id, e.id, c.id
FROM autores a, editoras e, categorias c
WHERE a.nome='Machado de Assis' AND e.nome='Companhia das Letras' AND c.nome='Clássico'
ON CONFLICT DO NOTHING;

INSERT INTO livros (titulo, ano_publicacao, isbn, id_autor, id_editora, id_categoria)
SELECT 'Laços de Família', 1960, '978-8501031565', a.id, e.id, c.id
FROM autores a, editoras e, categorias c
WHERE a.nome='Clarice Lispector' AND e.nome='Rocco' AND c.nome='Conto'
ON CONFLICT DO NOTHING;

INSERT INTO exemplares (id_livro, codigo_tombo, status)
SELECT l.id, 'HP001', 'disponivel' FROM livros l WHERE l.titulo='Harry Potter e a Pedra Filosofal';
INSERT INTO exemplares (id_livro, codigo_tombo, status)
SELECT l.id, 'HP002', 'disponivel' FROM livros l WHERE l.titulo='Harry Potter e a Pedra Filosofal';

INSERT INTO exemplares (id_livro, codigo_tombo, status)
SELECT l.id, 'GOT001', 'disponivel' FROM livros l WHERE l.titulo='A Guerra dos Tronos';

INSERT INTO exemplares (id_livro, codigo_tombo, status)
SELECT l.id, 'DC001', 'disponivel' FROM livros l WHERE l.titulo='Dom Casmurro';

INSERT INTO exemplares (id_livro, codigo_tombo, status)
SELECT l.id, 'LF001', 'disponivel' FROM livros l WHERE l.titulo='Laços de Família';

INSERT INTO emprestimos (id_exemplar, id_cliente, data_emprestimo, data_prevista, data_devolucao, multa)
SELECT e.id, c.id, CURRENT_DATE, CURRENT_DATE + INTERVAL '7 day', NULL, 0
FROM exemplares e
JOIN livros l ON l.id = e.id_livro
JOIN clientes c ON c.email='ana.souza@example.com'
WHERE e.codigo_tombo='HP001';

INSERT INTO emprestimos (id_exemplar, id_cliente, data_emprestimo, data_prevista, data_devolucao, multa)
SELECT e.id, c.id, CURRENT_DATE - INTERVAL '20 day', CURRENT_DATE - INTERVAL '10 day', CURRENT_DATE - INTERVAL '5 day', 5.00
FROM exemplares e
JOIN clientes c ON c.email='bruno.lima@example.com'
WHERE e.codigo_tombo='GOT001';

UPDATE exemplares SET status='emprestado' WHERE codigo_tombo='HP001';
