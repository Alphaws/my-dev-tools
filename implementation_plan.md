# Mailhog Telepítési Terv

Lokális SMTP szerver az e-mailek teszteléséhez.

## Specifikáció
- **Image**: `mailhog/mailhog:latest`
- **Hely**: `/home/alphaws/Develop/tools/mailhog`
- **Web UI URL**: `https://mailhog.localhost` (Traefik reverse proxy)
- **SMTP Port**: `1025` (elérhető a hostról localhost:1025-ön)

## Lépések

### 1. Mappaszerkezet
```bash
mkdir -p /home/alphaws/Develop/tools/mailhog
```

### 2. Tanúsítványok Frissítése
`mailhog.localhost` hozzáadása a megbízható tanúsítványhoz.

### 3. Docker Compose (`tools/mailhog/docker-compose.yml`)
```yaml
services:
  mailhog:
    image: mailhog/mailhog:latest
    container_name: mailhog
    restart: unless-stopped
    ports:
      - "1025:1025" # SMTP port exposed to host
    networks:
      - web-gateway
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.mailhog.rule=Host(`mailhog.localhost`)"
      - "traefik.http.routers.mailhog.entrypoints=websecure"
      - "traefik.http.routers.mailhog.tls=true"
      - "traefik.http.services.mailhog.loadbalancer.server.port=8025"

networks:
  web-gateway:
    external: true
```

### 4. Validáció
- Web UI elérése: `https://mailhog.localhost`
- SMTP teszt a hostról: `telnet localhost 1025`
