#!/usr/bin/env bash
set -euo pipefail

CLI_NAME="OpenFCPXMLKit-CLI"
CLI_BIN="${OPENFCPXMLKIT_CLI:-}"

# Resolve the CLI either from $OPENFCPXMLKIT_CLI, PATH, or the canonical install location.
if [[ -z "$CLI_BIN" ]] && command -v "$CLI_NAME" >/dev/null 2>&1; then
  CLI_BIN="$(command -v "$CLI_NAME")"
fi
if [[ -z "$CLI_BIN" ]] && [[ -x "/usr/local/bin/$CLI_NAME" ]]; then
  CLI_BIN="/usr/local/bin/$CLI_NAME"
fi
if [[ -z "$CLI_BIN" ]] || [[ ! -x "$CLI_BIN" ]]; then
  echo "Error: $CLI_NAME not found. Set OPENFCPXMLKIT_CLI, add it to PATH, or place it in /usr/local/bin." >&2
  echo "Install it first:" >&2
  echo "  brew install TheAcharya/homebrew-tap/OpenFCPXMLKit-CLI" >&2
  echo "  ... or use the installer pkg from https://github.com/TheAcharya/OpenFCPXMLKit/releases" >&2
  exit 1
fi

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 input.fcpxml|input.fcpxmld output-dir [--pdf] [--full]"
  echo
  echo "Builds an Excel report from a Final Cut Pro .fcpxml file or .fcpxmld bundle"
  echo "using $CLI_NAME ($CLI_BIN)."
  echo
  echo "  input     .fcpxml file or .fcpxmld bundle to report on"
  echo "  output    directory where the report workbook will be written"
  echo "  --pdf     also write a PDF report alongside the Excel workbook"
  echo "  --full    include every optional report sheet (equivalent to --report-full)"
  echo
  echo "Default sheets: Role Inventory, Media Summary (separate Missing Original /"
  echo "Missing Proxy columns)."
  exit 1
fi

INPUT_PATH="$1"
OUTPUT_DIR="$2"
PDF_FLAG=""
FULL_FLAG=""

for arg in "${@:3}"; do
  case "$arg" in
    --pdf)  PDF_FLAG="--create-pdf" ;;
    --full) FULL_FLAG="--report-full" ;;
    *)
      echo "Unknown option: $arg" >&2
      exit 1
      ;;
  esac
done

if [[ ! -e "$INPUT_PATH" ]]; then
  echo "Error: input not found: $INPUT_PATH"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "Input  : $INPUT_PATH"
echo "Output : $OUTPUT_DIR"
echo "CLI    : $CLI_BIN"

# shellcheck disable=SC2086
"$CLI_BIN" --report $FULL_FLAG \
  --report-media-summary \
  --media-summary-distinguish-proxy \
  $PDF_FLAG \
  "$INPUT_PATH" "$OUTPUT_DIR"
