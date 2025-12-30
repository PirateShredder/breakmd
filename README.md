# breakmd

A simple bash utility for splitting and reassembling markdown files based on headings.

## Overview

`breakmd` helps you work with large markdown documents by splitting them into smaller, manageable files organized by headings. Each section becomes its own file with automatic navigation links between sections, making it easier to edit, reorganize, or process individual sections. A manifest file tracks all sections. When you're done, reassemble them back into a single document with navigation markers automatically removed.

This tool was developed to enhance LLM / Obsidian Directories.
* https://code.claude.com/docs/en/setup
* https://obsidian.md/download

## Installation

```bash
# Clone or download breakmd.sh
chmod +x breakmd.sh
```

## Usage

> **Note:** Short forms `-b` and `-f` are recommended. Long forms `--break` and `--fix` are also available.

### Split a markdown file

```bash
./breakmd.sh -b yourfile.md
```

This creates a directory named `yourfile/` containing:
- Numbered markdown files (one per heading) with navigation links
- A MANIFEST.md file listing all sections

```
yourfile/
├── 001_introduction.md
├── 002_getting-started.md
├── 003_installation.md
├── 004_usage.md
└── MANIFEST.md
```

Each split file contains:
- Navigation link to previous section (except first file)
- The section heading and content
- Navigation link to next section (except last file)

### Reassemble split files

```bash
./breakmd.sh -f yourfile/
```

This creates `yourfile_reassembled.md` with all sections merged back together in order. Navigation markers are automatically removed, and the manifest file is excluded from the reassembly.

## Example

```bash
# Create a sample markdown file
cat > example.md << 'EOF'
# Introduction
Welcome to my document.

## Background
Some background information here.

# Main Content
The main part of the document.

## Details
More detailed information.
EOF

# Split it
./breakmd.sh -b example.md

# Output structure:
# example/
#   001_introduction.md        (contains: NEXT link, heading, content)
#   002_background.md          (contains: PREV link, heading, content, NEXT link)
#   003_main-content.md        (contains: PREV link, heading, content, NEXT link)
#   004_details.md             (contains: PREV link, heading, content)
#   MANIFEST.md                (index of all files)

# Reassemble it
./breakmd.sh -f example/

# Creates: example_reassembled.md
```

## How It Works

- **Breaking**: Detects any markdown heading (h1-h6) and creates a separate file for each section
- **Navigation**: Automatically adds `[[wiki-style]]` links between consecutive sections using HTML comments
- **Manifest**: Generates an index file listing all sections with their original headings
- **Sanitization**: Heading text is converted to safe filenames (lowercase, spaces to underscores, special characters removed)
- **Numbering**: Files are prefixed with sequential numbers (001, 002, etc.) to maintain order
- **Reassembly**: Files are concatenated in order, with navigation markers automatically filtered out

## Requirements

- Bash shell
- Standard Unix utilities (sed, tr, cat)

## License

MIT
