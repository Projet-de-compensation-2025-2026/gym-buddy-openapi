#!/usr/bin/env bash
# Produce the single-file OpenAPI 3.1 document consumers generate from.
# Source of truth is the $ref tree rooted at openapi/openapi.yaml.
set -euo pipefail
root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$root"
out="${1:-openapi/bundled.yaml}"
mkdir -p "$(dirname "$out")"
npx --yes @redocly/cli@1 bundle openapi/openapi.yaml --output "$out"
npx --yes prettier@3.6.2 --write "$out"
echo "BUNDLE OK: $out"
