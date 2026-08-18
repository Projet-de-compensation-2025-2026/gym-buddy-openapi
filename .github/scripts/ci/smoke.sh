#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$root"
port="${SMOKE_PORT:-4175}"
python3 -m http.server "$port" --bind 127.0.0.1 --directory openapi &
pid=$!
trap 'kill $pid 2>/dev/null || true' EXIT

check() {
  local path="$1"
  local body
  body="$(curl -fsS "http://127.0.0.1:${port}${path}" 2>/dev/null || true)"
  [[ "$body" == *"Gym Buddy API"* ]]
}

for _ in $(seq 1 40); do
  if check /openapi.yaml && check /bundled.yaml; then
    echo "SMOKE OK: openapi.yaml (tree) and bundled.yaml (today's service fetch) served over HTTP"
    exit 0
  fi
  sleep 0.25
done
echo "SMOKE FAIL" >&2
exit 1
