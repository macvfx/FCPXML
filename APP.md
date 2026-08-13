# FCPXMLD Conversion — macOS App

A native macOS (SwiftUI) utility for Final Cut Pro XML work, with three tabs:

1. **Library Capture** — pull the entire FCPXML description of a Final Cut library
   straight from the Final Cut sidebar.
2. **FCPXMLD Conversion** — drag-and-drop batch conversion of `.fcpxmld` bundles to
   standalone `.fcpxml` files.
3. **Excel / PDF Reports** — export OpenFCPXMLKit report workbooks and PDFs from
   `.fcpxml` files or `.fcpxmld` bundles.

> **Requirements:** macOS 26+, Apple Silicon or Intel (universal workspace supported
> via Xcode 26 / Swift 6.3). OpenFCPXMLKit 3.3.4 requires macOS 26.

## Download

Grab the latest **FCPXMLD Conversion** `.dmg` from
[Releases](https://github.com/macvfx/FCPXML/releases). The app is built from the
private source repo `macvfx/FCPXMLDConversion`.

## Library Capture tab

In Final Cut Pro, drag one library from the **sidebar** into the app. Final Cut
supplies an FCPXML description of the entire library through Apple's endorsed
pasteboard mechanism.

- **Byte-for-byte preservation** — the received FCPXML is written to disk untouched
  before any analysis runs.
- **Validation** — OpenFCPXMLKit runs semantic checks plus declared-version DTD
  validation.
- **Evidence folder** — each capture writes a folder containing:
  - `Source/Full Library.fcpxml` — the raw received FCPXML
  - `Reports/checksums.sha256` — SHA-256 checksum of the source
  - `Reports/library-inventory.json` — library / event / project / resource inventory
  - `Reports/validation-report.txt` — the validation result

For repeatable testing you can also drop a `.fcpxml` file or `.fcpxmld` bundle from
Finder instead of a Final Cut library.

## FCPXMLD Conversion tab

Drop one or more folders or `.fcpxmld` bundles. The app runs the bundled
`find-all-FCPXMLD-convert-count-move.sh` script to find every `.fcpxmld` and produce
a renamed `.fcpxml` output.

Output modes:
- **Save in Place** — writes `Name.fcpxml` next to each found bundle.
- **Save to Destination** — mirrors the relative paths into a chosen output folder.

Formatting uses `xmllint` if available, then `xmlstarlet`, otherwise a raw copy
fallback (same behaviour as the command-line scripts). Results stream into a live
in-app log.

## Excel / PDF Reports tab

Drop `.fcpxml` files or `.fcpxmld` bundles and export reports built with
OpenFCPXMLKit:

- **Formats** — Excel workbook (`.xlsx`), PDF (`.pdf`), or both.
- **Sections** — role inventory, markers, keywords, titles & generators, transitions,
  non-standard effects & templates, video/audio effects, speed-change effects,
  summary, and media summary.
- **Media Summary** — optionally split into separate *Missing Original* / *Missing
  Proxy* columns.
- **Options** — timecode format (SMPTE `HH:MM:SS:FF`, Frames, Feet+Frames,
  `HH:MM:SS`), exclude disabled clips, protect workbook sheets, copyright /
  attribution label, and a project-name filter.
- **Naming** — output files are named `{project-or-clip-name}.xlsx` / `.pdf`.
  **Reveal Report in Finder** reveals the latest outputs.

## Build from source

The project is a Swift package plus an Xcode app project.

```bash
# Swift Package Manager
swift build

# Xcode
open FCPXMLDDragConvertApp.xcodeproj   # select the FCPXMLDDragConvertApp scheme, Run

# xcodebuild
xcodebuild -project "FCPXMLDDragConvertApp.xcodeproj" \
  -scheme "FCPXMLDDragConvertApp" \
  -configuration Debug \
  -derivedDataPath "./DerivedData" \
  CODE_SIGNING_ALLOWED=NO build
```

Dependencies: [OpenFCPXMLKit](https://github.com/TheAcharya/OpenFCPXMLKit) 3.3.4 and
[GitHubUpdateChecker](https://github.com/macvfx/GitHubUpdateChecker).

## Update checks

The app compares its version against the latest release in this repository at launch
(and on demand via **Check for Updates…** in the app menu). It never downloads or
installs anything automatically and sends no information about your Mac.

## Notes

- The bundled conversion script is included in the app at runtime.
- Everything builds against macOS 26 SDK; the binary targets macOS 26+.