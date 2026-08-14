#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$root"

if [[ ! -f openapi/openapi.yaml ]]; then
  echo "TEST FAIL: openapi/openapi.yaml missing" >&2
  exit 1
fi

npx --yes @redocly/cli@1 lint openapi/openapi.yaml
echo "TEST OK: OpenAPI document lints"
