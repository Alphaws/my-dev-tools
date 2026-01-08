# Fejlesztői Környezet (Tools) Implementációs Terv

A cél egy alapvető, Docker-alapú webfejlesztői környezet kialakítása, amely központi reverse proxy-t és menedzsment eszközöket biztosít.

## Komponensek

### 1. Reverse Proxy (Traefik)
- **Hely**: `tools/traefik`
- **Portok**: 80 (HTTP), 443 (HTTPS), 8080 (Dashboard)
- **Funkció**: Minden `.localhost` kérés kezelése és továbbítása a megfelelő konténerhez.
- **SSL**: `mkcert` által generált lokális tanúsítványok.

### 2. Konténer Menedzsment (Portainer)
- **Hely**: `tools/portainer`
- **URL**: `https://portainer.localhost`
- **Funkció**: Grafikus felület a Docker konténerek, image-ek és volume-ok kezeléséhez.

### 3. Email Tesztelés (Mailhog)
- **Hely**: `tools/mailhog`
- **URL**: `https://mailhog.localhost`
- **SMTP Port**: 1025
- **Funkció**: Minden fejlesztés közben kiküldött email elkapása és megjelenítése.

### 4. Adatbázis Menedzsment (Adminer)
- **Hely**: `tools/adminer`
- **URL**: `https://adminer.localhost`
- **Funkció**: Webes kliens MySQL, PostgreSQL és egyéb adatbázisokhoz.

## Integráció
Minden eszköz közös Docker hálózaton (`traefik`) kommunikál, és a Traefik címkéken keresztül érhető el.
