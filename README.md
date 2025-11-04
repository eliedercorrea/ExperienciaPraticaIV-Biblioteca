# Experiência Prática IV — Biblioteca (PostgreSQL + PGAdmin)

Projeto organizado **conforme o PDF** (Sprints 1–4) com mini‑mundo **Biblioteca**.

## Como executar no PGAdmin
1. Crie um banco (ex.: `epiv_biblioteca`) e abra a **Query Tool**.
2. Rode, nessa ordem:
   - `scripts/ddl/00_create_schema.sql`
   - `scripts/ddl/01_create_tables.sql`
   - `scripts/dml/10_insert_iniciais.sql`
3. Valide com `scripts/dml/20_selects.sql` (8 consultas) e `scripts/dml/21_selects_avancados.sql` (15 consultas).
4. Sprint 3 (em transação):
   ```sql
   BEGIN;
   \i scripts/dml/30_updates.sql
   \i scripts/dml/40_deletes.sql
   -- Rode os SELECTs de conferência (docs/Evidencias-PGAdmin.md)
   ROLLBACK; -- ou COMMIT;
   ```
5. `scripts/dml/50_restores.sql` repovoa dados; `scripts/dml/99_drop_all.sql` limpa o schema.

## Estrutura
```
scripts/
  ddl/  (schema e tabelas)
  dml/  (inserts, selects, updates, deletes…)
docs/
  Sprint1-Relatorio.md
  Sprint3-Relatorio.md
  Apresentacao-Projeto.md
  Evidencias-PGAdmin.md
  PGAdmin-prints/  (coloque aqui as imagens)
```

## Publicação (Sprint 4)
- Crie um repositório **público** vazio no GitHub.
- **Upload files**: envie **todo o conteúdo desta pasta** (não a pasta mãe).
- Suba os prints em `docs/PGAdmin-prints/` e confira o `docs/Evidencias-PGAdmin.md`.

*Atualizado em 2025-11-04.*
