# Fejlesztői Környezet Használati Útmutató

A fejlesztői környezet sikeresen telepítve lett. Az alábbiakban leírjuk a rendszer használatát és bővítését.

## 1. Rendszer Áttekintés

- **Fő könyvtár**: `/home/alphaws/Develop`
- **Traefik helye**: `/home/alphaws/Develop/tools/traefik`
- **Elérési címek**:
- **Elérési címek**:
- **Elérési címek**:
    - Traefik Dashboard: [https://traefik.localhost/dashboard/](https://traefik.localhost/dashboard/)
    - Portainer: [https://portainer.localhost](https://portainer.localhost)
    - Mailhog: [https://mailhog.localhost](https://mailhog.localhost)
    - Adminer: [https://adminer.localhost](https://adminer.localhost)
    - Projektek: `[projekt-neve].localhost`

## 2. Traefik Indítása

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
    networks:
      - web-gateway
    volumes:
      - ./src:/var/www/html

networks:
  web-gateway:
    external: true
```

Indítsd el a projektet:
```bash
docker compose up -d
```

Ez a projekt a **http://my-php-app.localhost** címen lesz elérhető.

## 4. Validáció (Whoami)

A telepítés validálásához egy teszt szolgáltatás (`whoami`) lett létrehozva.

Indítás:
```bash
cd /home/alphaws/Develop/tools/traefik
docker compose -f validation-compose.yml up -d
```

ellenőrzés:
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

## Hibaelhárítás

Ha "Permission Denied" hibát kapsz Docker parancsoknál:
Győződj meg róla, hogy a felhasználód benne van a `docker` csoportban, és újra bejelentetkeztél.
Ideiglenes megoldás: `newgrp docker`.
