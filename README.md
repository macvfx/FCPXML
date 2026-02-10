# FCPXMLD to FCPXML Converter

A Bash script to recursively find Final Cut Pro `.fcpxmld` bundles (directory packages) and extract their inner `.fcpxml` files as standalone, flattened XML files.

## What it Does
Final Cut Pro 10.4+ exports projects as `.fcpxmld` bundles containing:
- A main `Info.plist`
- One primary `.fcpxml` text file
- Optional sidecar files (missing media reports, etc.)

This script:
1. Recursively scans a directory tree for all `.fcpxmld` bundles.
2. For each bundle, locates the inner `.fcpxml` file.
3. Formats it (using `xmllint` or `xmlstarlet` if available) or copies as-is.
4. Writes `ProjectName.fcpxml` either in-place (next to each bundle) or to a separate output directory (mirroring the folder structure).

## In-place conversion (writes fcpxml next to each fcpxmld bundle)
```bash
./flatten_fcpxmld.sh "/path/to/search"
```

## To separate output directory (mirrors folder structure)
```bash
./flatten_fcpxmld.sh "/path/to/search" "/path/to/output"
```

## Convert everything under Projects folder
```bash
./flatten_fcpxmld.sh "/Volumes/Projects"
```

## Convert to clean output tree
```bash
./flatten_fcpxmld.sh "/Volumes/Projects" "/Volumes/Projects_XML"
```

### Features
- **✅ Recursive**: Finds all `.fcpxmld` bundles anywhere under the search path.
- **✅ Safe**: Skips invalid bundles, logs errors, verifies output files exist.
- **✅ Flexible output**: In-place or mirrored directory structure.
- **✅ Pretty formatting**: Uses `xmllint --format` or `xmlstarlet fo` when available.
- **✅ Progress logging**: Shows each conversion + final totals.
- **✅ macOS native**: Works with built-in tools + optional Homebrew helpers.

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
1. Save as `flatten_fcpxmld.sh`.
2. `chmod +x flatten_fcpxmld.sh`.
3. `./flatten_fcpxmld.sh /your/path`.

## Pro Tips
- Log to file: `./flatten_fcpxmld.sh /path | tee conversion.log`
- Dry run: Comment out the `xmllint/cp` line to preview.
- Test first: Run on a small folder to verify behavior.
- Backup: `.fcpxmld` bundles remain untouched.

### Why this exists
To restore files from [Archiware P5 v.8.0](archiware.com) you need a plain text formatted media list. Also, a lot of older tools, cross-platform workflows, and XML parsers often expect plain `.fcpxml` files, not Apple bundles.
