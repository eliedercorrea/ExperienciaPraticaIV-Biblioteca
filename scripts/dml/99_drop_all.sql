-- 99_drop_all.sql
SET search_path TO biblioteca;
DROP TABLE IF EXISTS reservas      CASCADE;
DROP TABLE IF EXISTS emprestimos   CASCADE;
DROP TABLE IF EXISTS exemplares    CASCADE;
DROP TABLE IF EXISTS livros        CASCADE;
DROP TABLE IF EXISTS clientes      CASCADE;
DROP TABLE IF EXISTS categorias    CASCADE;
DROP TABLE IF EXISTS editoras      CASCADE;
DROP TABLE IF EXISTS autores       CASCADE;
