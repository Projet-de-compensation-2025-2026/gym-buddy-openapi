#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$root"
port="${SMOKE_PORT:-4175}"
python3 -m http.server "$port" --bind 127.0.0.1 --directory openapi &
pid=$!
trap 'kill $pid 2>/dev/null || true' EXIT
for _ in $(seq 1 40); do
  body="$(curl -fsS "http://127.0.0.1:${port}/openapi.yaml" 2>/dev/null || true)"
  if [[ "$body" == *"Gym Buddy API"* ]]; then
    echo "SMOKE OK: openapi.yaml served over HTTP"
    exit 0
  fi
  sleep 0.25
done
echo "SMOKE FAIL" >&2
exit 1
