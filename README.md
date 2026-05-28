# dockerfiles — catálogo de herramientas para levantar en local

Un lugar **centralizado** para tomar una herramienta y levantarla rápido. Cada
carpeta es un servicio autocontenido con su `docker-compose`: entrás, `docker
compose up -d`, y lo tenés andando.

> ⚠️ **Solo para desarrollo local y POCs.** Nada de esto está pensado para
> producción. Las credenciales son triviales a propósito (`postgres`, `1234`,
> `1346`…), no hay TLS, ni hardening, ni gestión de secretos. Es un *playground*.

## Filosofía

- **Grab & go**: una herramienta por carpeta, lista en un comando. Sin pasos previos
  (no hay que crear redes ni volúmenes a mano).
- **Datos en volúmenes nombrados de Docker**, nunca en el repo. El repo se mantiene
  limpio; los datos persisten entre reinicios y se borran a propósito con `down -v`.
- **Versiones pineadas** a la última estable, con healthchecks y logging acotado.
- **Sin seguridad**: es local. Si algún día va a un entorno compartido, hay que
  endurecer todo (creds, red, TLS).

## Cómo usar

```bash
cd <herramienta>          # ej: cd postgres
docker compose up -d      # levantar en background
docker compose logs -f    # ver logs
docker compose ps         # estado / healthcheck
docker compose down       # parar (conserva los datos)
docker compose down -v    # parar y BORRAR los datos del volumen
```

## Servicios disponibles

| Carpeta | Imagen | Puertos | Acceso / UI | Credenciales dev |
|---|---|---|---|---|
| **postgres** | `pgvector/pgvector:pg18` (PostgreSQL 18.4 + pgvector 0.8.x) | 5432 | `psql` / cualquier cliente | `postgres` / `postgres`, db `app` |
| **valkey** | `valkey/valkey:9.1.0` (reemplazo de Redis) | 6379 | `valkey-cli`, clientes Redis | sin auth |
| **redis** | `redis:latest` | 6379 | `redis-cli` | — |
| **mysql** | `mysql` + `adminer` | 3306, 8082 | Adminer → http://localhost:8082 | `admin` / `1346` (root `1346`) |
| **mongodb** | `mongo` + `mongo-express` | 27017, 8081 | Mongo Express → http://localhost:8081 | `root` / `1346` |
| **rabbitmq** | `rabbitmq:4.3-management` | 5672, 15672 | Management → http://localhost:15672 | `admin` / `1234` |
| **kafka** | `confluentinc/cp-kafka:7.3.0` + Zookeeper | 9092 | broker AMQP/Kafka | — |
| **n8n** | `n8nio/n8n:latest` | 5678 | http://localhost:5678 | (setup en primer arranque) |
| **keycloak** | `keycloak:legacy` + Postgres | 8080 | http://localhost:8080 | ver compose |
| **konga** | `kong` + `konga` + Postgres | 1337, 8001, 8000 | Konga → http://localhost:1337 | ver compose |
| **jenkins** | `jenkins/jenkins:lts-jdk21` | 8080, 50000 | http://localhost:8080 | (unlock en primer arranque) |
| **appsmith** | `appsmith/appsmith-ce` | 80, 443 | http://localhost | (setup en primer arranque) |

> **Ojo con los puertos repetidos.** Varios servicios usan el mismo puerto
> (`6379` valkey/redis, `8080` jenkins/keycloak, etc.). Como la idea es levantar
> **una** herramienta a la vez, no suele molestar — pero si necesitás dos juntas,
> cambiá el puerto del host en el `docker-compose` correspondiente.

## Postgres + AI (pgvector)

La imagen `pgvector/pgvector:pg18` trae **PostgreSQL 18** con la extensión
**pgvector** ya compilada (búsqueda por similitud vectorial: embeddings, RAG,
semantic search; índices HNSW e IVFFlat). En el primer arranque, `postgres/initdb/`
activa solo las extensiones (`vector`, `pg_trgm`, `pgcrypto`, `uuid-ossp`).

```bash
cd postgres && docker compose up -d
# Conexión: postgresql://postgres:postgres@localhost:5432/app
docker compose exec postgres psql -U postgres -d app -c "SELECT '[1,2,3]'::vector;"
```

Las credenciales y el puerto se overridean en `postgres/.env` (ya viene con valores
dummy de dev).

## Notas

- Cada carpeta corre de forma independiente; no comparten red por defecto.
- Los compose nuevos (postgres, valkey, rabbitmq) usan volúmenes nombrados y
  healthchecks. Los más viejos (kafka, keycloak, konga, jenkins, appsmith) siguen
  como estaban — se irán modernizando con el mismo criterio.
