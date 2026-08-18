#!/usr/bin/env python3
"""Keep package.json and openapi info.version aligned with the Release tag."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path


def main() -> None:
    if len(sys.argv) != 2:
        sys.exit("usage: sync_package_version.py X.Y.Z")
    version = sys.argv[1]
    if not re.fullmatch(r"\d+\.\d+\.\d+", version):
        sys.exit(f"invalid version: {version}")

    pkg_path = Path("package.json")
    pkg = json.loads(pkg_path.read_text(encoding="utf-8"))
    pkg["version"] = version
    pkg_path.write_text(json.dumps(pkg, indent=2) + "\n", encoding="utf-8")

    spec_path = Path("openapi/openapi.yaml")
    spec = spec_path.read_text(encoding="utf-8")
    updated, count = re.subn(
        r"^  version:\s*\d+\.\d+\.\d+\s*$",
        f"  version: {version}",
        spec,
        count=1,
        flags=re.MULTILINE,
    )
    if count != 1:
        sys.exit("could not update openapi/openapi.yaml info.version")
    spec_path.write_text(updated, encoding="utf-8")
    print(f"Synced package.json and info.version to {version}")


if __name__ == "__main__":
    main()
