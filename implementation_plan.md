# Projekt Sablonok (Templates)

A cél, hogy a fejlesztőnek ne kelljen nulláról írnia a `Dockerfile` és `docker-compose.yml` fájlokat minden új projektnél. Ezek a sablonok már illeszkednek a `tools`-ban lévő Traefik infrastruktúrához.

## Mappaszerkezet (`tools/templates/`)

### 1. `python-fastapi/`
Modern Python API fejlesztéshez.
- **Dockerfile**: Python 3.11, `requirements.txt`, uvicorn.
- **docker-compose.yml**: Traefik címkékkel (`fastapi-app.localhost`), hot-reload beállítással.

### 2. `php-general/` (vagy Laravel)
Általános PHP fejlesztéshez (Apache vagy FPM).
- **Dockerfile**: PHP 8.2, Composer, szükséges kiterjesztések (mysqli, pdo).
- **docker-compose.yml**: Traefik címkék (`php-app.localhost`), volume mapping a kódhoz.

### 3. `frontend-angular/`
Frontend fejlesztéshez.
- **Fejlesztési mód**: Node.js konténer, ami futtatja az `ng serve`-t.
- **Traefik**: Mivel az `ng serve` websocketet használ a hot-reloadhoz, erre figyelni kell a címkéknél.

## Használat
A felhasználó egyszerűen átmásolja a kívánt mappa tartalmát az új projektjébe, és futtatja a `docker compose up` parancsot.
