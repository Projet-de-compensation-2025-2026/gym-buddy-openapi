#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$root"

if [[ ! -f openapi/openapi.yaml ]]; then
  echo "TEST FAIL: openapi/openapi.yaml missing" >&2
  exit 1
fi
if [[ ! -f openapi/bundled.yaml ]]; then
  echo "TEST FAIL: openapi/bundled.yaml missing (run bash .github/scripts/ci/bundle.sh)" >&2
  exit 1
fi

npx --yes @redocly/cli@1 lint openapi/openapi.yaml
npx --yes @redocly/cli@1 lint openapi/bundled.yaml

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
bash .github/scripts/ci/bundle.sh "$tmpdir/bundled.yaml"
if ! diff -u openapi/bundled.yaml "$tmpdir/bundled.yaml"; then
  echo "TEST FAIL: openapi/bundled.yaml is stale; run bash .github/scripts/ci/bundle.sh" >&2
  exit 1
fi

echo "TEST OK: OpenAPI document lints; consumer bundle is current"
