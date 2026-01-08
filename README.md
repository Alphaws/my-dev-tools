# Local Development Tools

Ez a repozitórium tartalmazza a lokális webfejlesztéshez szükséges infrastrukturális eszközöket.

## Összetevők

A rendszer Docker alapú, és az alábbi szolgáltatásokat nyújtja:

| Szolgáltatás | URL (HTTPS) | Leírás |
|---|---|---|
| **Traefik** | [https://traefik.localhost/dashboard/](https://traefik.localhost/dashboard/) | Reverse proxy és SSL terminálás. |
| **Portainer** | [https://portainer.localhost](https://portainer.localhost) | Grafikus felület Docker konténerek kezeléséhez. |
| **Mailhog** | [https://mailhog.localhost](https://mailhog.localhost) | Lokális SMTP szerver e-mailek teszteléséhez (SMTP port: 1025). |
| **Adminer** | [https://adminer.localhost](https://adminer.localhost) | Webes adatbázis kliens (MySQL, Postgres). |

## Követelmények

- Ubuntu (vagy más Linux disztró)
- Docker & Docker Compose
- `mkcert` (SSL tanúsítványokhoz)

## Telepítés és Indítás

A részletes telepítési lépéseket a [task.md](task.md) tartalmazza.

Ha a rendszer már telepítve van, az indítás egyszerű.

### Teljes stack indítása (ajánlott)

```bash
docker compose up -d
```

### Egyes eszközök indítása (opcionális)

Traefiknek mindig futnia kell, ha el szeretnéd érni a projektjeidet a `.localhost` címeken.

1. **Traefik indítása**:
    ```bash
    cd traefik
    docker compose up -d
    ```

2. **Eszközök indítása** (igény szerint):
    ```bash
    cd portainer
    docker compose up -d
    cd mailhog
    docker compose up -d
    cd ../adminer
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
