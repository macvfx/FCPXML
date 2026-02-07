#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 /path/to/search [optional_output_root]"
  exit 1
fi

ROOT_PATH="$1"
OUTPUT_ROOT="${2:-}"   # optional

if [[ ! -d "$ROOT_PATH" ]]; then
  echo "Error: $ROOT_PATH is not a directory."
  exit 1
fi

# If output root is given, ensure it exists
if [[ -n "$OUTPUT_ROOT" ]]; then
  mkdir -p "$OUTPUT_ROOT"
fi

bundles_found=0
bundles_converted=0
xml_created=0

convert_bundle() {
  local bundle_path="$1"
  bundles_found=$((bundles_found + 1))

  if [[ ! -d "$bundle_path" ]]; then
    echo "Skipping non-directory: $bundle_path" >&2
    return
  fi

  local bundle_base
  bundle_base="$(basename "$bundle_path")"        # Example.fcpxmld
  local bundle_base_no_ext="${bundle_base%.*}"    # Example

  local parent_dir
  parent_dir="$(dirname "$bundle_path")"

  # Decide output directory:
  # - if OUTPUT_ROOT is set, mirror the relative path inside it
  # - otherwise, write next to the bundle
  local out_dir
  if [[ -n "$OUTPUT_ROOT" ]]; then
    # Compute path relative to ROOT_PATH
    local rel_path="${parent_dir#$ROOT_PATH}"
    # Normalize leading slash
    rel_path="${rel_path#/}"
    out_dir="${OUTPUT_ROOT}/${rel_path}"
    mkdir -p "$out_dir"
  else
    out_dir="$parent_dir"
  fi

  local out_path="${out_dir}/${bundle_base_no_ext}.fcpxml"

  # Find the .fcpxml file inside the bundle
  local fcpxml_file
  fcpxml_file="$(find "$bundle_path" -maxdepth 2 -type f -name '*.fcpxml' | head -n 1 || true)"

  if [[ -z "$fcpxml_file" ]]; then
    echo "No .fcpxml found in bundle: $bundle_path" >&2
    return
  fi

  echo "Found bundle: $bundle_path"
  echo "  Inner FCPXML: $fcpxml_file"
  echo "  Output file : $out_path"

  if command -v xmllint >/dev/null 2>&1; then
    xmllint --format "$fcpxml_file" > "$out_path"
  elif command -v xmlstarlet >/dev/null 2>&1; then
    xmlstarlet fo "$fcpxml_file" > "$out_path"
  else
    cp "$fcpxml_file" "$out_path"
  fi

  bundles_converted=$((bundles_converted + 1))

  if [[ -f "$out_path" ]]; then
    xml_created=$((xml_created + 1))
    echo "  Created: $out_path"
  else
    echo "  Warning: expected output not found: $out_path" >&2
  fi

  echo
}

export -f convert_bundle
export ROOT_PATH OUTPUT_ROOT bundles_found bundles_converted xml_created

# Run conversions
while IFS= read -r -d '' bundle; do
  convert_bundle "$bundle"
done < <(find "$ROOT_PATH" -type d -name "*.fcpxmld" -print0)

echo "=============================="
echo "Scan complete for: $ROOT_PATH"
echo "Bundles found    : $bundles_found"
echo "Bundles converted: $bundles_converted"
echo "XML files created: $xml_created"
echo "Output root      : ${OUTPUT_ROOT:-<same as bundle dirs>}"
echo "=============================="
