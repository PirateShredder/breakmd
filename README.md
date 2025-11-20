┌─────────────────────────────────┐
│        b r e a k m d . s h      │
│  Markdown File Splitter/Merger  │
└─────────────────────────────────┘

A simple utility to split and reassemble large markdown files based on headings.
Use this tool to break down huge md files, so that agentic AI can manipulate it in smaller chunks.

USAGE:
  ./breakmd.sh [COMMAND] [ARGUMENT]

COMMANDS:
  -break <file.md>      Splits a markdown file by its H1-H6 headings. Each heading
                       starts a new file in a dedicated directory.

  -fix   <directory>    Reassembles split markdown files from a directory
                       back into a single file, ordered by filename.

EXAMPLES:
  # Split a large document into smaller chapter files
  ./breakmd.sh -break BigProject.md

  # Reassemble the chapters back into a single document
  ./breakmd.sh -fix BigProject
