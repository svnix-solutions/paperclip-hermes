#!/usr/bin/env bash
set -euo pipefail

CONTAINER=${CONTAINER:-paperclip-hermes}
BASE_URL=${BASE_URL:-http://127.0.0.1:3100}

echo "==> Bootstrapping Paperclip admin (CEO)"
docker exec --user node -it "$CONTAINER" pnpm paperclipai auth bootstrap-ceo

echo
echo "==> Open the invite URL above in your browser, finish account creation."
echo "==> Then export the auth cookie from your browser as PAPERCLIP_COOKIE and run:"
echo
cat <<'EOF'
   PAPERCLIP_COOKIE='<paste cookie value>' ./bootstrap.sh adapter
EOF

if [[ "${1:-}" == "adapter" ]]; then
  : "${PAPERCLIP_COOKIE:?set PAPERCLIP_COOKIE first}"
  echo "==> Installing hermes-paperclip-adapter via plugin API"
  curl -fsS -X POST "$BASE_URL/api/adapters/install" \
    -H "content-type: application/json" \
    -H "Cookie: $PAPERCLIP_COOKIE" \
    -d '{"packageName":"hermes-paperclip-adapter"}' | jq .

  echo
  echo "==> Running hermes setup inside the container"
  docker exec --user node -it "$CONTAINER" hermes setup
fi