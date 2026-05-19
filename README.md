# paperclip-hermes

Paperclip with [Hermes Agent](https://github.com/NousResearch/hermes-agent) CLI baked into the runtime image, for use with [`hermes-paperclip-adapter`](https://github.com/NousResearch/hermes-paperclip-adapter) installed at runtime via Paperclip's external adapter plugin system (v2026.416.0+).

## Quick start

```bash
cp .env.example .env && $EDITOR .env
docker compose up -d
./bootstrap.sh                          # creates admin user
PAPERCLIP_COOKIE='...' ./bootstrap.sh adapter   # installs adapter + runs hermes setup
```

Then create a `hermes_local` agent in the Paperclip UI.

## Why a custom image?

The stock `ghcr.io/paperclipai/paperclip` image doesn't ship Python or the `hermes` CLI. The adapter spawns `hermes chat -q` as a subprocess of the Paperclip server process, so the binary must be on `$PATH` in the same container. Everything else (the adapter itself, its config, its session state) is managed by Paperclip's plugin system and persists in the database.

## Upgrades

Bump `PAPERCLIP_TAG` in `.github/workflows/build.yaml` (or run the workflow with the `paperclip_tag` input) to track upstream releases. The adapter is upgraded independently via the plugin API.

## License

MIT.