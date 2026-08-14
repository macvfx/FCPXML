# FCPXMLD ⇄ FCPXML — Tools

Command-line scripts **and** a macOS drag-and-drop app for working with Final Cut Pro
`.fcpxmld` bundles and their inner `.fcpxml` files.

| Tool | What it does |
|---|---|
| FCP Reports app | Native macOS SwiftUI app: library FCPXML capture, Excel/PDF reporting, and drag-and-drop `.fcpxmld` conversion. [See **APP.md**](APP.md). |
| `find-all-FCPXMLD-convert-count-move.sh` | Recursive batch converter — finds every `.fcpxmld` under a folder and produces renamed `.fcpxml` output (in a `Save in Place` or `Save to Destination` mirror). |
| `FCPXMLD-to-XML.sh` | Single-bundle converter — flattens one `.fcpxmld` to a standalone `.fcpxml` next to it. |

---

## The macOS App

Prefer a GUI? Download the latest signed **FCP Reports** app from
[Releases](https://github.com/macvfx/FCPXML/releases) (`.dmg`).

Full feature list, build instructions, and usage: [`APP.md`](APP.md).

---

## Why this exists

To restore files from [Archiware P5 v.8.0](archiware.com) you need a plain text
formatted media list. Also, a lot of cross-platform workflows and XML parsers often
expect plain `.fcpxml` files, not Apple bundles.

## What the scripts do

Final Cut Pro 10.4+ exports projects as `.fcpxmld` bundles containing:

- A main `Info.plist`
- One primary `.fcpxml` text file
- Optional sidecar files (missing media reports, etc.)

The scripts:

1. Recursively scan a directory tree for all `.fcpxmld` bundles.
2. For each bundle, locate the inner `.fcpxml` file.
3. Format it (using `xmllint` or `xmlstarlet` if available) or copy it as-is.
4. Write `ProjectName.fcpxml` either in place (next to each bundle) or to a separate output directory (mirroring the folder structure).

---

## Batch conversion (`find-all-FCPXMLD-convert-count-move.sh`)

## In-place conversion (writes fcpxml next to each fcpxmld bundle)
```bash
./find-all-FCPXMLD-convert-count-move.sh "/path/to/search"
```

## To separate output directory (mirrors folder structure)
```bash
./find-all-FCPXMLD-convert-count-move.sh "/path/to/search" "/path/to/output"
```

## Convert everything under Projects folder
```bash
./find-all-FCPXMLD-convert-count-move.sh "/Volumes/Projects"
```

## Convert to clean output tree
```bash
./find-all-FCPXMLD-convert-count-move.sh "/Volumes/Projects" "/Volumes/Projects_XML"
```

### Features
- **✅ Recursive**: Finds all `.fcpxmld` bundles anywhere under the search path.
- **✅ Safe**: Skips invalid bundles, logs errors, verifies output files exist.
- **✅ Flexible output**: In-place or mirrored directory structure.
- **✅ Pretty formatting**: Uses `xmllint --format` or `xmlstarlet fo` when available.
- **✅ Progress logging**: Shows each conversion + final totals (bundles found, converted, XML files created).
- **✅ macOS native**: Works with built-in tools + optional Homebrew helpers.

---

## Single conversion (`FCPXMLD-to-XML.sh`)

Convert one bundle:
```bash
./FCPXMLD-to-XML.sh "/path/to/MyProject.fcpxmld"
```
Writes a flattened `MyProject.fcpxml` next to the bundle.

---

### Prerequisites
Required: None (just Bash)
Optional (for pretty XML output):
```bash
# Install via Homebrew
brew install libxml2 xmlstarlet
```

## Example Output
Found bundle: /path/to/MyProject.fcpxmld  
Inner FCPXML: /path/to/Info.fcpxml  
Output file : /path/to/MyProject.fcpxml  
Created: /path/to/MyProject.fcpxml

==============================  
Scan complete for: /Volumes/Projects  
Bundles found    : 12  
Bundles converted: 11  
XML files created: 11  
Output root      : <same as bundle dirs>  
==============================  

```
Projects/
├── Edit01.fcpxmld/
│   └── Info.fcpxml
└── Subfolder/
    └── Edit02.fcpxmld/
        └── Info.fcpxml
```

## Error Handling
- No `.fcpxml` inside bundle → Skip + log warning.
- Invalid bundle path → Skip + log.
- Output write fails → Log warning, continue.
- Missing output root dir → Auto-creates directories.

### Save & Run
1. Save the script (e.g. `find-all-FCPXMLD-convert-count-move.sh`).
2. `chmod +x find-all-FCPXMLD-convert-count-move.sh`.
3. `./find-all-FCPXMLD-convert-count-move.sh /your/path`.

## Pro Tips
- Log to file: `./find-all-FCPXMLD-convert-count-move.sh /path | tee conversion.log`
- Dry run: Comment out the `xmllint/cp` line to preview.
- Test first: Run on a small folder to verify behavior.
- Backup: `.fcpxmld` bundles remain untouched.