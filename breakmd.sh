#!/usr/bin/env bash
set -euo pipefail

usage() {
  # --- COLORS ---
  C_RESET='\033[0m'
  C_BOLD='\033[1m'
  C_GREEN='\033[32m'
  C_YELLOW='\033[33m'
  C_GRAY='\033[90m'

  printf "\n"
  printf "${C_BOLD}┌─────────────────────────────────┐${C_RESET}\n"
  printf "${C_BOLD}│        b r e a k m d . s h      │${C_RESET}\n"
  printf "${C_BOLD}│  Markdown File Splitter/Merger  │${C_RESET}\n"
  printf "${C_BOLD}└─────────────────────────────────┘${C_RESET}\n"
  printf "\n"
  printf "${C_BOLD}A simple utility to split and reassemble large markdown files based on headings.${C_RESET}\n"
  printf "${C_BOLD}Use this tool to break down huge md files, so that agentic AI can manipulate it in smaller chunks.${C_RESET}\n"
  printf "\n"
  printf "${C_YELLOW}USAGE:${C_RESET}\n"
  printf "  ${C_BOLD}%s${C_RESET} [COMMAND] [ARGUMENT]\n" "$0"
  printf "\n"
  printf "${C_YELLOW}COMMANDS:${C_RESET}\n"
  printf "  ${C_GREEN}-break${C_RESET} <file.md>      Splits a markdown file by its H1-H6 headings. Each heading\n"
  printf "                       starts a new file in a dedicated directory.\n"
  printf "\n"
  printf "  ${C_GREEN}-fix${C_RESET}   <directory>    Reassembles split markdown files from a directory\n"
  printf "                       back into a single file, ordered by filename.\n"
  printf "\n"
  printf "${C_YELLOW}EXAMPLES:${C_RESET}\n"
  printf "  ${C_GRAY}# Split a large document into smaller chapter files${C_RESET}\n"
  printf "  %s -break BigProject.md\n" "$0"
  printf "\n"
  printf "  ${C_GRAY}# Reassemble the chapters back into a single document${C_RESET}\n"
  printf "  %s -fix BigProject\n" "$0"
  printf "\n"
  exit 1
}

sanitize() {
  local raw="$1"

  raw="$(echo "$raw" | tr '[:upper:]' '[:lower:]')"
  raw="$(echo "$raw" | sed 's/[ ]\+/_/g')"
  raw="$(echo "$raw" | sed 's/[^a-z0-9_]/-/g')"
  raw="$(echo "$raw" | sed 's/-\{2,\}/-/g')"
  raw="$(echo "$raw" | sed 's/^-//; s/-$//')"

  echo "$raw"
}

break_file() {
  local input="$1"

  if [ ! -f "$input" ]; then
    echo "Error: File not found: $input"
    exit 1
  fi

  local basename="$(basename "$input" .md)"
  local outdir="./${basename}"

  mkdir -p "$outdir"

  local idx=1
  local current_file=""
  local buffer=""

  # Read the file line by line
  while IFS='' read -r line || [[ -n "$line" ]]; do

    if [[ "$line" =~ ^\#{1,6}[[:space:]]+(.*) ]]; then
      heading="${BASH_REMATCH[1]}"
      sanitized="$(sanitize "$heading")"
      seq=$(printf "%03d" "$idx")
      idx=$((idx+1))

      # Write previous
      if [ -n "$current_file" ]; then
        echo -n "$buffer" > "$current_file"
      fi

      current_file="$outdir/${seq}_${sanitized}.md"
      buffer="$line"$'\n'

    else
      buffer+="$line"$'\n'
    fi

  done < "$input"

  # Write last buffer
  if [ -n "$current_file" ]; then
    echo -n "$buffer" > "$current_file"
  fi

  echo "Split complete. Files stored in: $outdir/"
}

fix_directory() {
  local dir="$1"

  if [ ! -d "$dir" ]; then
    echo "Error: Directory not found: $dir"
    exit 1
  fi

  local out="${dir%/}_reassembled.md"

  # Merge in order: 000_*, 001_*, 002_*, ...
  (
    cd "$dir"
    ls -1 | sort | while read -r file; do
      cat "$file"
      echo
    done
  ) > "$out"

  echo "Reassembled file created: $out"
}

# ----------------- MAIN -----------------

if [ $# -lt 2 ]; then
  usage
fi

mode="$1"

case "$mode" in
  -break)
    break_file "$2"
    ;;
  -fix)
    fix_directory "$2"
    ;;
  *)
    usage
    ;;
esac

