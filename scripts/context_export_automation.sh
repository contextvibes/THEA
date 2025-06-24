#!/bin/bash
# scripts/context_export_automation.sh (VERSION 7 - REFACTORED)
#
# WHY: Generates a focused snapshot of the project's automation framework.
# WHAT: Uses the central helper script to handle all common logic, then
#       gathers and appends the specific automation files to the report.

set -e
# Source the single source of truth for all helper functions and variables.
source "$(dirname "$0")/_automation_helpers.sh"

# --- Phase 1: State Verification ---
echo "--> Verifying repository state..."
# All complex checks are now handled by the helper script.
ensure_clean_workspace # Or use another helper like prompt_to_stash_if_dirty if preferred

# --- Phase 2: Report Generation ---
OUTPUT_FILE="contextvibes_export_automation.md"
PROMPT_FILE="$PROMPTS_DIR/export-automation-context.md"

echo "--> Generating focused automation export to '$OUTPUT_FILE'..."

# Use the new helper function to create the report with the correct prompt.
generate_report_header \
  "$OUTPUT_FILE" \
  "$PROMPT_FILE" \
  "Analyze Automation Framework" \
  "You are an expert DevOps engineer and automation specialist."

# --- Phase 3: Append Automation-Specific Content ---
# The rest of the script now only does work unique to THIS script.

# Section 1: Uncommitted Local Changes
{
  echo "## 1. Uncommitted Local Changes"
  echo '```'
  git status
  echo '```'
  echo ""
  echo "---"
} >> "$OUTPUT_FILE"

# Section 2: Project Manifest
{
  echo "## 2. Project Manifest"
  echo "Status: [T]=Tracked, [U]=Untracked, [I]=Ignored"
  echo '```'
  find . -not -path '*/.git/*' -not -name '.' | sort | while read -r file; do
    if [ -z "$file" ]; then continue; fi
    status="U"
    if git check-ignore -q "$file"; then status="I";
    elif git ls-files --error-unmatch "$file" >/dev/null 2>&1; then status="T"; fi
    indent_level=$(echo "$file" | tr -cd '/' | wc -c)
    indent=$(printf '%*s' $((indent_level * 2)) '')
    printf "[%s] %s%s\n" "$status" "$indent" "$(basename "$file")"
  done
  echo '```'
  echo ""
  echo "---"
} >> "$OUTPUT_FILE"

# Section 3: Core Automation Files
echo "## 3. Core Automation Files" >> "$OUTPUT_FILE"
CORE_FILES=( "README.md" "Taskfile.yml" )
CORE_DIRS=( "scripts" "tasks" )

for file in "${CORE_FILES[@]}"; do
  if [ -f "$file" ] && is_text_file "$file"; then
    {
      echo ""
      echo "======== FILE: ${file} ========"
      echo '```'
      cat "$file"
      echo '```'
      echo "======== END FILE: ${file} ========"
    } >> "$OUTPUT_FILE"
  fi
done

for dir in "${CORE_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    find "$dir" -type f | sort | while read -r file; do
      if is_text_file "$file"; then
        {
          echo ""
          echo "======== FILE: ${file} ========"
          lang="${file##*.}"
          echo "\`\`\`${lang}"
          cat "$file"
          echo '```'
          echo "======== END FILE: ${file} ========"
        } >> "$OUTPUT_FILE"
      fi
    done
  fi
done

echo "✅ Focused automation export complete. Report saved to '$OUTPUT_FILE'."
