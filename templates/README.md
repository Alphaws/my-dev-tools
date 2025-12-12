# Projekt Sablonok

Ez a mappa "Docker-first" projekt indító sablonokat tartalmaz, amelyek előre be vannak állítva a `tools` mappában lévő Traefik infrastruktúrához (HTTPS, hálózat).

## Python (FastAPI)
Mappa: `python-fastapi`

**Használat:**
Use this template for Python API development.
1. Másold át a fájlokat az új projekted mappájába.
2. `docker compose up -d`
3. Elérhető: `https://fastapi-app.localhost` (vagy amit beállítasz a docker-compose-ban).

## PHP (General / Apache)
Mappa: `php-general`

**Használat:**
Use this template for PHP web apps.
1. Másold át a fájlokat.
2. `docker compose up -d`
3. Elérhető: `https://php-app.localhost`

## Frontend (Angular / Node)
Mappa: `frontend-angular`

**Használat:**
Use this template to containerize your frontend dev server.
1. Másold át a fájlokat a meglévő Angular/React projekted gyökerébe.
2. Módosítsd a `docker-compose.yml`-ben a portot (Angular: 4200, React: 3000, Vite: 5173).
3. `docker compose up -d`
