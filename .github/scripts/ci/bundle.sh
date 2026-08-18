#!/usr/bin/env bash
# Flatten the $ref tree to a caller-supplied path for optional CI lint.
# Do not check the output in. Consumers generate from openapi/openapi.yaml
# (service 3ffdef8 / UI 47eac9c pin tag v0.1.0). Ticket #54 deletes the
# former checked-in openapi/bundled.yaml.
set -euo pipefail
root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$root"
if [[ $# -lt 1 ]]; then
  echo "usage: bundle.sh <output-path>" >&2
  echo "Write a temp flatten of the \$ref tree. Do not check the output in." >&2
  exit 1
fi
out="$1"
mkdir -p "$(dirname "$out")"
npx --yes @redocly/cli@1 bundle openapi/openapi.yaml --output "$out"
npx --yes prettier@3.6.2 --write "$out"
echo "BUNDLE OK: $out (temp lint artifact; not a consumer input)"
