# FCP Reports — macOS App

A native macOS (SwiftUI) utility for Final Cut Pro XML work, with four tabs:

1. **Library Capture** — pull the entire FCPXML description of a Final Cut library
   straight from the Final Cut sidebar, archiving it as evidence and optionally
   building reports from it.
2. **FCP Reports** — export OpenFCPXMLKit report workbooks and PDFs from
   `.fcpxml` files or `.fcpxmld` bundles using your own custom report selections.
3. **Convert FCPXMLD** — drag-and-drop batch conversion of `.fcpxmld` bundles to
   standalone `.fcpxml` files.
4. **Settings** — global output locations (Save in Place / Save to Destination),
   report defaults for Library Capture auto-reports, and about information.

> **Requirements:** macOS 26+, Apple Silicon or Intel (universal workspace supported
> via Xcode 26 / Swift 6.3). OpenFCPXMLKit 3.3.13 requires macOS 26.

## Download

Grab the latest **FCP Reports** `.dmg` from
[Releases](https://github.com/macvfx/FCPXML/releases). The app is built from the
private source repo `macvfx/FCPXMLDConversion`.

Current release: **FCP Reports 1.6.1 (build 15)**.

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

**Output & Reports** (in the tab, or in Settings):
- Captures go to every output location enabled in **Settings** — Save in Place
  writes next to the library bundle, Save to Destination writes to the chosen
  folder.
- **Build reports after FCPXML created** (on by default) builds reports beside the
  capture evidence using the report selections in **Settings → Report Defaults**;
  changes there apply to future captures.
- **Status in the drop zone** — capture and validation progress streams inline in
  the drop zone (a checkmark icon on success); result details (event/project
  counts, SHA-256, evidence path) and the Reveal buttons sit below it.

## FCP Reports tab

Drop `.fcpxml` files or `.fcpxmld` bundles and export reports built with
OpenFCPXMLKit. This tab is **independent** of the Library Capture defaults — build
custom reports on your own selections:

- **Formats** — Excel workbook (`.xlsx`), PDF (`.pdf`), or both.
- **Sections** — role inventory, markers, keywords, titles & generators, transitions,
  non-standard effects & templates, video/audio effects, speed-change effects,
  summary, and media summary.
- **Role Inventory screenshots** — a **Role Screenshots** toggle adds a **Screenshot**
  column after **Row** on the Role Inventory Excel report, embedding a **Source In**
  frame grab. Original media is preferred; proxy media is used only when the original
  is missing or unreadable (MXF, camera RAW). PDF output omits the column; missing
  media leaves a blank cell.
- **Media Summary** — optionally split into separate *Missing Original* / *Missing
  Proxy* columns.
- **Options** — timecode format (SMPTE `HH:MM:SS:FF`, Frames, Feet+Frames,
  `HH:MM:SS`), exclude disabled clips, protect workbook sheets, copyright /
  attribution label, and a project-name filter.
- **Naming** — output files are named `{project-or-clip-name}.xlsx` / `.pdf`.
  **Reveal Report in Finder** reveals the latest outputs.
- **Status in the drop zone** — report progress appears inline under the path
  list (orange while running, grey when done); there is no separate log box.
- Reports are written to every output location enabled in Settings.
- **OpenFCPXMLKit 3.3.13 reporting update** — large FCPXML reports use less memory
  and avoid stalls while loading roles or projecting timelines. Retimed usages,
  source durations, secondary-storyline roles, multicam inventory rows, Inspector
  position units, and duplicate-frame ranges are reported more accurately.

## Convert FCPXMLD tab

Drop one or more folders or `.fcpxmld` bundles. The app runs the bundled
`find-all-FCPXMLD-convert-count-move.sh` script to find every `.fcpxmld` and produce
a renamed `.fcpxml` output, written to every output location enabled in Settings.

Formatting uses `xmllint` if available, then `xmlstarlet`, otherwise a raw copy
fallback (same behaviour as the command-line scripts). The drop zone is a fixed
height — the "Drop FCPXMLD here" prompt, the path list, and the inline conversion
status all share the same panel, so it never resizes.

## Settings tab

- **Output locations** — global **Save in Place** and **Save to Destination**
  toggles, persisted across launches. Every tab writes to every enabled location;
  both can be on at once:
  - Save in Place — beside each input file/bundle, or next to the Final Cut library
    bundle for captures.
  - Save to Destination — the global default output folder (a `FCP Reports` folder
    in Documents by default).
  If neither is enabled, the tabs refuse to run until one is turned on.
- **Report Defaults** — the report sections, format, and options (with Select All /
  Deselect All) that control the auto-reports built by Library Capture. All sections
  are on by default.
- **About FCP Reports** — attribution to code.matx.ca and the OpenFCPXMLKit library.

## Build from source

The project is a Swift package plus an Xcode app project.

```bash
# Swift Package Manager
swift build

# Xcode
open FCPReports.xcodeproj   # select the FCPReportsApp scheme, Run

# xcodebuild
xcodebuild -project "FCPReports.xcodeproj" \
  -scheme "FCPReportsApp" \
  -configuration Debug \
  -derivedDataPath "./DerivedData" \
  CODE_SIGNING_ALLOWED=NO build
```

Dependencies: [OpenFCPXMLKit](https://github.com/TheAcharya/OpenFCPXMLKit) 3.3.13 and
[GitHubUpdateChecker](https://github.com/macvfx/GitHubUpdateChecker).

## Update checks

The app compares its version against the latest release in this repository at launch
(and on demand via **Check for Updates…** in the app menu). It never downloads or
installs anything automatically and sends no information about your Mac.

## Notes

- The bundled conversion script is included in the app at runtime.
- Everything builds against macOS 26 SDK; the binary targets macOS 26+.
- Bundle identifier: `com.macvfx.FCPReportsApp`.
