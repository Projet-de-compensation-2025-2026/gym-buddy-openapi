#!/usr/bin/env bash
# Resolve the $ref tree into one file. CI uses this as a resolve check only.
# Do not check the output in. Generators read openapi/openapi.yaml.
set -euo pipefail
root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$root"
out="${1:-openapi/bundled.yaml}"
mkdir -p "$(dirname "$out")"
npx --yes @redocly/cli@1 bundle openapi/openapi.yaml --output "$out"
npx --yes prettier@3.6.2 --write "$out"
echo "BUNDLE OK: $out"
