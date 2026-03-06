#!/bin/bash

set -euo pipefail

RELEASE=$(curl -fsSL https://api.github.com/repos/mozilla/pdf.js/releases/latest)

RELEASE_VERSION=$(printf '%s' "$RELEASE" | jq -r '.tag_name | ltrimstr("v")')
RELEASE_ASSET_URL=$(printf '%s' "$RELEASE" | jq -r '.assets[] | select(.name | endswith("-dist.zip")) | select(.name | contains("legacy") | not) | .browser_download_url' | head -n 1)

if [[ -z "$RELEASE_VERSION" || "$RELEASE_VERSION" == "null" ]]; then
    echo "Could not determine the latest PDF.js release version" >&2
    exit 1
fi

if [[ -z "$RELEASE_ASSET_URL" || "$RELEASE_ASSET_URL" == "null" ]]; then
    echo "Could not find the official non-legacy dist zip for PDF.js $RELEASE_VERSION" >&2
    exit 1
fi

TEMP_DIR=$(mktemp -d)
ZIP_PATH="$TEMP_DIR/pdfjs-dist.zip"

cleanup() {
    rm -rf "$TEMP_DIR"
}

trap cleanup EXIT

curl -fsSL "$RELEASE_ASSET_URL" -o "$ZIP_PATH"

rm -rf build web LICENSE
unzip -q "$ZIP_PATH"

if [[ ! -f web/viewer.html ]]; then
    echo "Expected web/viewer.html to exist after extracting PDF.js $RELEASE_VERSION" >&2
    exit 1
fi

if [[ ! -f build/pdf.mjs || ! -f build/pdf.worker.mjs || ! -f web/viewer.mjs ]]; then
    echo "Expected module-based PDF.js assets were not extracted correctly" >&2
    exit 1
fi

if [[ ! -f web/viewer.css ]]; then
    echo "Expected web/viewer.css to exist after extracting PDF.js $RELEASE_VERSION" >&2
    exit 1
fi

python3 <<'PY'
from pathlib import Path

viewer_css = Path("web/viewer.css")
patch = "#presentationMode, #secondaryOpenFile, #viewBookmark { display: none !important; }"

content = viewer_css.read_text()
if patch not in content:
    separator = "\n" if content.endswith("\n") else "\n\n"
    viewer_css.write_text(f"{content}{separator}{patch}\n")
PY

RELEASE_VERSION="$RELEASE_VERSION" python3 <<'PY'
import json
import os
from pathlib import Path

release_version = os.environ["RELEASE_VERSION"]

version = Path("package.json")
data = json.loads(version.read_text())
data["version"] = release_version
version.write_text(json.dumps(data, indent=4) + "\n")

lock = Path("package-lock.json")
lock_data = json.loads(lock.read_text())
lock_data["version"] = release_version
lock_data["packages"][""]["version"] = release_version
lock.write_text(json.dumps(lock_data, indent=4) + "\n")
PY
