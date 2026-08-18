#!/usr/bin/env bash
# Keep the checked-in consumer fetch file in sync with the $ref tree.
# Today's gym-buddy-service generate-sources still GETs openapi/bundled.yaml.
# Target SoT for new consumers is openapi/openapi.yaml (ticket #47 switches the service).
set -euo pipefail
root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$root"
out="${1:-openapi/bundled.yaml}"
mkdir -p "$(dirname "$out")"
npx --yes @redocly/cli@1 bundle openapi/openapi.yaml --output "$out"
npx --yes prettier@3.6.2 --write "$out"
echo "BUNDLE OK: $out"
