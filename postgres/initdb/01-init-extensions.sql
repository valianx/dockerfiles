-- Se ejecuta UNA sola vez, en el primer arranque con el volumen vacío,
-- contra la base definida en POSTGRES_DB (por defecto: "app").
-- Si ya tenés datos y querés re-correrlo: docker compose down -v && up.

-- pgvector: búsqueda por similitud vectorial (embeddings, RAG, semantic search).
-- Soporta índices HNSW e IVFFlat sobre tipos vector / halfvec / sparsevec.
CREATE EXTENSION IF NOT EXISTS vector;

-- Utilidades que casi siempre vienen bien en dev:
CREATE EXTENSION IF NOT EXISTS pg_trgm;      -- búsqueda fuzzy / LIKE acelerado
CREATE EXTENSION IF NOT EXISTS pgcrypto;     -- gen_random_uuid(), hashing, etc.
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";  -- uuid_generate_v4()

-- Smoke test rápido de pgvector (no deja nada creado):
DO $$
BEGIN
  PERFORM '[1,2,3]'::vector <-> '[3,2,1]'::vector;
  RAISE NOTICE 'pgvector OK — extensión vector lista para usar';
END $$;
