# Local Development Tools

Ez a repozitórium tartalmazza a lokális webfejlesztéshez szükséges infrastrukturális eszközöket.

## Összetevők

A rendszer Docker alapú, és az alábbi szolgáltatásokat nyújtja:

| Szolgáltatás | URL (HTTPS) | Leírás |
|---|---|---|
| **Traefik** | [https://traefik.localhost/dashboard/](https://traefik.localhost/dashboard/) | Reverse proxy és SSL terminálás. |
| **Portainer** | [https://portainer.localhost](https://portainer.localhost) | Grafikus felület Docker konténerek kezeléséhez. |
| **Mailhog** | [https://mailhog.localhost](https://mailhog.localhost) | Lokális SMTP szerver e-mailek teszteléséhez (SMTP port: 1025). |

## Követelmények

- Ubuntu (vagy más Linux disztró)
- Docker & Docker Compose
- `mkcert` (SSL tanúsítványokhoz)

## Telepítés és Indítás

A részletes telepítési lépéseket a [task.md](task.md) tartalmazza.

Ha a rendszer már telepítve van, az indítás egyszerű:

1. **Traefik indítása** (Ennek mindig futnia kell):
    ```bash
    cd traefik
    docker compose up -d
    ```

2. **Eszközök indítása** (Opcionális, igény szerint):
    ```bash
    cd portainer
    docker compose up -d
    cd ../mailhog
    docker compose up -d
    ```

## Új Projekt hozzáadása

Lásd a [walkthrough.md](walkthrough.md) fájlt részletes útmutatóért.

Röviden:
1. Hozz létre egy `docker-compose.yml`-t a projektednek.
2. Add hozzá a Traefik címkéket (`traefik.http.routers...`).
3. Ha új domaint használsz, frissítsd a tanúsítványt:
    ```bash
    cd traefik
    mkcert -cert-file certs/local-cert.pem -key-file certs/local-key.pem "localhost" "*.localhost" "uj-projekt.localhost"
    docker compose restart traefik
    ```
