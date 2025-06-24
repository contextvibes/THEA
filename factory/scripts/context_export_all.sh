#!/bin/bash
# Filename: factory/scripts/context_export_all.sh
#
# WHAT: Exports a comprehensive snapshot of the entire project, organized
#       by our "Product, Library, Factory" architectural model.
# WHY:  Provides a complete, structured context file for high-level AI
#       analysis, onboarding, or architectural review. This version is
#       "root-aware" and will function correctly even when run from a subdirectory.

set -e
# Source the single source of truth for all helper functions and variables.
source "$(dirname "$0")/_automation_helpers.sh"

# --- Configuration ---
# Programmatically find the absolute path to the project's root directory.
# This makes all subsequent paths robust and independent of the execution directory.
readonly GIT_ROOT=$(git rev-parse --show-toplevel)

# Define file paths relative to the newly found GIT_ROOT.
readonly OUTPUT_FILE="$GIT_ROOT/contextvibes_export_project.md"
readonly PROMPT_FILE="$GIT_ROOT/$PROMPTS_DIR/export-project-context.md"

# --- Main Logic ---

echo "--> Generating full project export..."

# Use the helper function to create the report file with a custom or default prompt.
# This now uses the full, absolute path to the output and prompt files.
generate_report_header \
  "$OUTPUT_FILE" \
  "$PROMPT_FILE" \
  "Full Project Context Analysis" \
  "You are an expert AI systems architect. Your task is to analyze the following comprehensive project export to build a complete mental model of the repository's architecture, purpose, and implementation."

# ---
# WHAT:  A local helper function to find all tracked, text-based files in a
#        given set of paths and append them to the report under a "Book" heading.
# ---
export_book() {
  local title="$1"
  shift # Remove the title from the arguments, leaving only the paths
  local paths=("$@")
  local files

  # Use `git -C` to run the command from the context of the GIT_ROOT.
  # This ensures it finds the correct files (e.g., "thea/", not "factory/thea/").
  files=$(git -C "$GIT_ROOT" ls-files -- "${paths[@]}")

  # Append the book header to the main output file
  { echo ""; echo "---"; echo "## Book: ${title}"; echo ""; } >> "$OUTPUT_FILE"

  # Process each file found by Git
  echo "$files" | while read -r file; do
    # Construct the full, absolute path for file system operations like `cat` and `is_text_file`.
    local full_path="$GIT_ROOT/$file"

    # Skip if the file doesn't exist or is not a text file
    if [ ! -f "$full_path" ] || ! is_text_file "$full_path"; then
      echo "--> Skipping non-text file: $file"
      continue
    fi

    # Append the file's content, wrapped in markdown code blocks.
    # The header uses the clean, relative path for readability. The `cat` uses the full path.
    {
      echo ""
      echo "======== FILE: ${file} ========"
      echo "\`\`\`${file##*.}"
      cat "$full_path"
      echo "\`\`\`"
      echo "======== END FILE: ${file} ========"
    } >> "$OUTPUT_FILE"
  done
}

#
# --- Execute the Export ---
#
# The paths here are relative to the GIT_ROOT, as expected by the `git -C` command.
# This aligns perfectly with our "Product, Library, Factory" model.
#

export_book "The Product (Core THEA Guidance)" \
  "README.md" \
  "CHANGELOG.md" \
  "thea/"

export_book "The Library (Project & Process Documentation)" \
  "docs/"

export_book "The Factory (Automation Framework & Environment)" \
  "Taskfile.yml" \
  ".github/" \
  "factory/"

echo "✅ Full project export complete. Report saved to '$OUTPUT_FILE'."
