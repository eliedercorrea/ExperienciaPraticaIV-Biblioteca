-- 01_create_tables.sql
SET search_path TO biblioteca;

CREATE TABLE IF NOT EXISTS autores (
  id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(120) NOT NULL
);

CREATE TABLE IF NOT EXISTS editoras (
  id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS categorias (
  id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS clientes (
  id       BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nome     VARCHAR(120) NOT NULL,
  email    VARCHAR(180) NOT NULL UNIQUE,
  telefone VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS livros (
  id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  titulo         VARCHAR(200) NOT NULL,
  ano_publicacao INTEGER CHECK (ano_publicacao BETWEEN 1450 AND EXTRACT(YEAR FROM CURRENT_DATE)::INT),
  isbn           VARCHAR(20) UNIQUE,
  id_autor       BIGINT NOT NULL REFERENCES autores(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  id_editora     BIGINT NOT NULL REFERENCES editoras(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  id_categoria   BIGINT NOT NULL REFERENCES categorias(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS exemplares (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_livro     BIGINT NOT NULL REFERENCES livros(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  codigo_tombo VARCHAR(40) NOT NULL UNIQUE,
  status       VARCHAR(15) NOT NULL DEFAULT 'disponivel',
  CHECK (status IN ('disponivel','emprestado','reservado','manutencao'))
);

CREATE TABLE IF NOT EXISTS emprestimos (
  id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_exemplar     BIGINT NOT NULL REFERENCES exemplares(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  id_cliente      BIGINT NOT NULL REFERENCES clientes(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  data_emprestimo DATE NOT NULL DEFAULT CURRENT_DATE,
  data_prevista   DATE NOT NULL,
  data_devolucao  DATE,
  multa           NUMERIC(10,2) NOT NULL DEFAULT 0.00,
  CHECK (data_prevista >= data_emprestimo),
  CHECK (data_devolucao IS NULL OR data_devolucao >= data_emprestimo)
);

CREATE TABLE IF NOT EXISTS reservas (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  id_exemplar  BIGINT NOT NULL REFERENCES exemplares(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  id_cliente   BIGINT NOT NULL REFERENCES clientes(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  data_reserva DATE NOT NULL DEFAULT CURRENT_DATE,
  status       VARCHAR(15) NOT NULL DEFAULT 'ativa',
  CHECK (status IN ('ativa','cancelada','efetivada'))
);

CREATE INDEX IF NOT EXISTS idx_livros_titulo ON livros (titulo);
CREATE INDEX IF NOT EXISTS idx_emprestimos_cliente ON emprestimos (id_cliente);
CREATE INDEX IF NOT EXISTS idx_exemplares_status ON exemplares (status);
