This repo publishes images for running RealityRipple's Home-Made Emote Wall authentication services.

Work in progress.

### Usage

In your EmoteWall.html:
- update the [oauthClient variable](https://github.com/RealityRipple/EmoteWall/blob/9a1fb4203411c010fd0e4f046b75062738674704/emotes.html#L1359) with your client IDs
- replace instances of [ew.realityripple.com](https://ew.realityripple.com) with your domain in [cURLS.html.rr](https://github.com/RealityRipple/EmoteWall/blob/9a1fb4203411c010fd0e4f046b75062738674704/emotes.html#L1590) & [cURLS.api.trovo.gql](https://github.com/RealityRipple/EmoteWall/blob/9a1fb4203411c010fd0e4f046b75062738674704/emotes.html#L1504)

```bash
docker pull ghcr.io/Bergbok/Docker-Emote-Wall-Auth
# or
docker pull bergb0k/Emote-Wall-Auth
# or
git clone --recursive https://github.com/Bergbok/Emote-Wall-Auth.git
cd Emote-Wall-Auth
docker build -t Bergbok/Docker-Emote-Wall-Auth .
```

#### via docker run

```bash
docker run -p 4200:80 --name emote-wall-auth --rm \
	-e GLOBAL_HOST=localhost:4200 \
	-e GLOBAL_HOME=https://realityripple.com/Tools/Twitch/EmoteWall \
	-e GLOBAL_TWITCH=https://ew.realityripple.com/t/login \
	-e GLOBAL_RETURN=https://ew.realityripple.com \
	-e TWITCH_CLIENT_ID=000000000000000000000000000000 \
	-e TWITCH_CLIENT_SECRET=000000000000000000000000000000 \
	Bergbok/Docker-Emote-Wall-Auth
```

#### via docker compose

```yml
services:
  emote-wall-auth:
    build: .
    container_name: emote-wall-auth
    env_file:
      - .env
    ports:
      - 4200:80
    network_mode: bridge
    restart: unless-stopped
```

```bash
docker compose up -d
```

<!-- > see [example_addr.json](./src/data/example_addr.json) and [example_auth.json](./src/data/example_auth.json) for all configuration options -->
