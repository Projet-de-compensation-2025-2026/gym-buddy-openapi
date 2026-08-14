#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$root"
mode="${1:---check}"
npx --yes prettier@3.6.2 "$mode" "openapi/**/*.{yaml,yml}" ".github/**/*.{yml,yaml}"
