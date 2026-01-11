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

## Ubuntu telepítés (Docker, Compose, Node/npm, mkcert, stb.)

Az alábbi lépések Ubuntu 22.04+ rendszeren működnek. Ha más verziót használsz, ellenőrizd a csomagneveket.

### 1) Alap csomagok

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release git
```

### 2) Docker Engine + Compose plugin

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Opció: Docker használata `sudo` nélkül:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

Ellenőrzés:

```bash
docker --version
docker compose version
```

### 3) Node.js + npm (NVM)

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm install --lts
```

Ellenőrzés:

```bash
node -v
npm -v
```

### 4) mkcert

```bash
sudo apt-get install -y libnss3-tools
curl -L -o /usr/local/bin/mkcert https://github.com/FiloSottile/mkcert/releases/latest/download/mkcert-linux-amd64
sudo chmod +x /usr/local/bin/mkcert
mkcert -install
```

### 5) Codex CLI (opcionális)

Ha használod a Codex CLI-t, kövesd a hivatalos telepítési útmutatót. A telepítés módja kiadástól függ (npm/pipx/binary).

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
3. Ha új domaint használsz, generálj külön tanúsítványt (a script frissíti a Traefik TLS listáját is):
    ```bash
    cd traefik
    ./scripts/generate-certs.sh "uj-projekt.localhost"
    docker compose restart traefik
    ```
