#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 input.fcpxmld"
  exit 1
fi

BUNDLE_PATH="$1"

if [[ ! -d "$BUNDLE_PATH" ]]; then
  echo "Error: $BUNDLE_PATH is not a directory (fcpxmld bundle)."
  exit 1
fi

# Get base name of the bundle without extension
bundle_base="$(basename "$BUNDLE_PATH")"     # e.g. MyEdit.fcpxmld
bundle_base_no_ext="${bundle_base%.*}"       # e.g. MyEdit

# Choose output extension: .xml (change to .xml if you want)
OUT_PATH="${bundle_base_no_ext}.fcpxml"

# Find the main .fcpxml file inside the bundle.
FCPXML_FILE="$(find "$BUNDLE_PATH" -maxdepth 2 -type f -name '*.fcpxml' | head -n 1)"
if [[ -z "$FCPXML_FILE" ]]; then
  echo "Error: no .fcpxml file found inside bundle."
  exit 1
fi

# Optional: pretty‑print or normalize the XML so the output is a clean flat text XML.
if command -v xmllint >/dev/null 2>&1; then
  xmllint --format "$FCPXML_FILE" > "$OUT_PATH"
elif command -v xmlstarlet >/dev/null 2>&1; then
  xmlstarlet fo "$FCPXML_FILE" > "$OUT_PATH"
else
  # Fallback: just copy as-is (it is already a flat XML text file).
  cp "$FCPXML_FILE" "$OUT_PATH"
fi

echo "Wrote flattened XML to: $OUT_PATH"