# Adminer Telepítési Terv

Webes adatbázis-kezelő felület (GUI) minden Docker-es adatbázishoz.

## Specifikáció
- **Image**: `adminer` (hivatalos image)
- **Hely**: `/home/alphaws/Develop/tools/adminer`
- **URL**: `https://adminer.localhost`
- **Dizájn**: Opcionálisan beállíthatunk egy szebb CSS témát (pl. `pepa-linha`), de az alap is megfelel.

## Lépések

### 1. Mappaszerkezet
```bash
mkdir -p /home/alphaws/Develop/tools/adminer
```

### 2. Tanúsítványok Frissítése
`adminer.localhost` hozzáadása a megbízható tanúsítványhoz.

### 3. Docker Compose (`tools/adminer/docker-compose.yml`)
```yaml
services:
  adminer:
    image: adminer
    container_name: adminer
    restart: unless-stopped
    networks:
      - web-gateway
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.adminer.rule=Host(`adminer.localhost`)"
      - "traefik.http.routers.adminer.entrypoints=websecure"
      - "traefik.http.routers.adminer.tls=true"
      - "traefik.http.services.adminer.loadbalancer.server.port=8080"

networks:
  web-gateway:
    external: true
```

### 4. Validáció
- Web UI elérése: `https://adminer.localhost`

### 5. Dokumentáció és Git
- `README.md` és `walkthrough.md` frissítése.
- Git commit és push.
