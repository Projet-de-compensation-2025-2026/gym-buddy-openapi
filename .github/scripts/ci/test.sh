#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$root"

if [[ ! -f openapi/openapi.yaml ]]; then
  echo "TEST FAIL: openapi/openapi.yaml missing" >&2
  exit 1
fi
if [[ ! -f package.json ]]; then
  echo "TEST FAIL: package.json missing (consumers pin this package by tag)" >&2
  exit 1
fi
if [[ -n "$(git ls-files -- openapi/bundled.yaml)" ]]; then
  echo "TEST FAIL: openapi/bundled.yaml must not be checked in (ticket #54)" >&2
  exit 1
fi

python3 - <<'PY'
import json
import re
import sys
from pathlib import Path

pkg = json.loads(Path("package.json").read_text(encoding="utf-8"))
if pkg.get("name") != "gym-buddy-openapi":
    sys.exit(f"package.json name is {pkg.get('name')!r}, expected gym-buddy-openapi")
ver = str(pkg.get("version", ""))
if not re.fullmatch(r"0\.\d+\.\d+", ver):
    sys.exit(f"package.json version {ver!r} must stay 0.y.z")

root = Path("openapi/openapi.yaml").read_text(encoding="utf-8")
match = re.search(r"^  version:\s*(\S+)\s*$", root, flags=re.MULTILINE)
if match is None:
    sys.exit("openapi/openapi.yaml info.version missing")
if match.group(1) != ver:
    sys.exit(f"info.version {match.group(1)!r} != package.json {ver!r}")
print(f"TEST OK: package {pkg['name']}@{ver} matches info.version")
PY

npx --yes @redocly/cli@1 lint openapi/openapi.yaml

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
bash .github/scripts/ci/bundle.sh "$tmpdir/bundled.yaml"
npx --yes @redocly/cli@1 lint "$tmpdir/bundled.yaml"

echo "TEST OK: OpenAPI \$ref tree lints; temp bundle is lint-only and not checked in"
