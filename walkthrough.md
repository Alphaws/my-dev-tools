# Fejlesztői Környezet Használati Útmutató

Ez a dokumentáció a lokális `tools` környezet használatát és bővítését írja le.

## 1. Rendszer Áttekintés

- **Fő könyvtár**: `/home/alphaws/Develop/tools`
- **Traefik helye**: `/home/alphaws/Develop/tools/traefik`
- **Elérési címek**:
    - Traefik Dashboard: [https://traefik.localhost/dashboard/](https://traefik.localhost/dashboard/)
    - Portainer: [https://portainer.localhost](https://portainer.localhost)
    - Mailhog: [https://mailhog.localhost](https://mailhog.localhost)
    - Adminer: [https://adminer.localhost](https://adminer.localhost)
    - Projektek: `[projekt-neve].localhost`

## 2. Indítás

### Teljes stack indítása (ajánlott)

```bash
cd /home/alphaws/Develop/tools
docker compose up -d
```

### Traefik indítása (külön)

A Traefiknek mindig futnia kell, ha el szeretnéd érni a projektjeidet a `.localhost` címeken.

```bash
cd /home/alphaws/Develop/tools/traefik
docker compose up -d
```

## 3. Új Projekt Létrehozása (Pl. PHP)

Hozz létre egy új mappát a projektednek, pl. `my-php-app`. Ebben hozz létre egy `docker-compose.yml` fájlt az alábbi minta alapján:

```yaml
version: '3'
services:
  web:
    image: php:8.2-apache
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.my-php-app.rule=Host(`my-php-app.localhost`)"
      - "traefik.http.routers.my-php-app.entrypoints=websecure"
      - "traefik.http.routers.my-php-app.tls=true"
      - "traefik.docker.network=traefik"
    networks:
      - traefik
    volumes:
      - ./src:/var/www/html

networks:
  traefik:
    external: true
    name: traefik
```

Indítsd el a projektet:
```bash
docker compose up -d
```

Ez a projekt a **https://my-php-app.localhost** címen lesz elérhető.

## 4. Validáció (Whoami)

A telepítés validálásához egy teszt szolgáltatás (`whoami`) lett létrehozva.

Indítás:
```bash
cd /home/alphaws/Develop/tools/traefik
docker compose -f validation-compose.yml up -d
```

Ellenőrzés:
Nyisd meg a [https://whoami.localhost](https://whoami.localhost) címet.
A böngészőnek biztonságos kapcsolatot (lakat ikon) kell mutatnia.

## 5. HTTPS és Tanúsítványok

A rendszer `mkcert` segítségével biztosítja a HTTPS-t.
A tanúsítványok helye: `/home/alphaws/Develop/tools/traefik/certs/`

Ha új domain-t szeretnél használni (pl. `uj-projekt.localhost`), újra kell generálnod a tanúsítványt, hogy tartalmazza az új nevet is:

```bash
cd /home/alphaws/Develop/tools/traefik
mkcert -cert-file certs/local-cert.pem -key-file certs/local-key.pem "localhost" "*.localhost" "uj-projekt.localhost"
docker compose restart traefik
```

> **Fontos**: A `*.localhost` wildcard sajnos nem minden környezetben működik tökéletesen (böngésző függő), ezért ajánlott az explicit domain nevek megadása a fenti módon.

## 6. Külső Projektek Integrálása (Meglévő repók)

Ha egy meglévő Docker-es projektet (pl. `prstart-lms`) szeretnél futtatni ebben a környezetben anélkül, hogy módosítanád a `docker-compose.yml`-t (amit verziókezelés alatt tartasz), használd a `docker-compose.override.yml`-t.

**Lépések:**
1.  Klónozd a repót: `git clone ...`
2.  Generálj tanúsítványt a Traefik mappában: `mkcert ... "projekt.localhost"`
3.  Hozz létre egy `docker-compose.override.yml` fájlt a projekt gyökerében:

```yaml
services:
  app: # A szolgáltatás neve az eredeti compose fájlból
    labels:
      - "traefik.enable=true"
      - "traefik.docker.network=traefik" # A közös hálózat neve
      - "traefik.http.routers.my-app.rule=Host(`projekt.localhost`)"
      - "traefik.http.routers.my-app.tls=true"
      # Ha az eredeti projekt nem állította be a Let's Encryptet, itt kapcsold ki a resolver kérést:
      - "traefik.http.routers.my-app.tls.certresolver=" 
    networks:
      - traefik

networks:
  traefik:
    external: true
    name: traefik # A te lokális hálózatod neve
```

Ez a módszer tisztán tartja az eredeti projektfájlokat, miközben illeszti őket a helyi környezethez.

## Hibaelhárítás

Ha "Permission Denied" hibát kapsz Docker parancsoknál:
Győződj meg róla, hogy a felhasználód benne van a `docker` csoportban, és újra bejelentetkeztél.
Ideiglenes megoldás: `newgrp docker`.
