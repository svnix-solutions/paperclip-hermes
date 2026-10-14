# paperclip-hermes

Paperclip with [Hermes Agent](https://github.com/NousResearch/hermes-agent) CLI baked into the runtime image, for use with Paperclip's built-in `hermes_local` adapter (v2026.626.0+). The external [`hermes-paperclip-adapter`](https://github.com/NousResearch/hermes-paperclip-adapter) can still be installed to override the built-in one.

## Quick start

```bash
cp .env.example .env && $EDITOR .env
docker compose up -d
./bootstrap.sh                          # creates admin user
docker exec --user node -it paperclip-hermes hermes setup
```

Optional: `PAPERCLIP_COOKIE='...' ./bootstrap.sh adapter` installs the external adapter over the built-in one and runs `hermes setup`.

Then create a `hermes_local` agent in the Paperclip UI.

## Why a custom image?

The stock `ghcr.io/paperclipai/paperclip` image doesn't ship Python or the `hermes` CLI. The adapter spawns `hermes chat -q` as a subprocess of the Paperclip server process, so the binary must be on `$PATH` in the same container. Everything else (the adapter, its config, its session state) is managed by Paperclip and persists in the database.

## Upgrades

Bump `PAPERCLIP_TAG` in `Dockerfile` and `.github/workflows/build.yaml` (or run the workflow with the `paperclip_tag` input) to track upstream releases. Upstream publishes stable `:YYYY.MDD.P` tags and `:sha-<short-sha>` tags for exact pinning. The built-in adapter upgrades with Paperclip; an external override is upgraded independently via the plugin API.

Before upgrading, read the upstream release notes' Breaking Changes, back up the `paperclip-hermes-pgdata` volume, and stop the old container completely (since v2026.1012.0, old and new versions must not run against the same `/paperclip` volume at once).

## License

MIT.