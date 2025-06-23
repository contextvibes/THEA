#!/bin/bash
# scripts/export_codebase.sh
#
# WHY: Generates the most comprehensive project snapshot for an LLM.
# WHAT: It captures the full git status (local and vs. main), the project
#       structure, and the content of all key configuration and guidance files.
# HOW: Uses git, tree, and cat commands, appending each section to the output.

set -e

OUTPUT_FILE="contextvibes_export.md"
MAIN_BRANCH="main"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "--> Generating comprehensive project export to '$OUTPUT_FILE'..."

# --- Header ---
{
  echo "# Comprehensive Project Export"
  echo ""
  echo "**Branch:** \`$CURRENT_BRANCH\`"
  echo "**Generated:** $(date)"
  echo ""
  echo "---"
} > "$OUTPUT_FILE"

# --- Section 1: Git Status (What's New?) ---
{
  echo "## 1. Uncommitted Local Changes"
  echo '```'
  if [[ -z $(git status --porcelain) ]]; then
    echo "No uncommitted local changes. The working directory is clean."
  else
    git status
  fi
  echo '```'
  echo ""
  echo "---"
} >> "$OUTPUT_FILE"

if [ "$CURRENT_BRANCH" != "$MAIN_BRANCH" ]; then
  MERGE_BASE=$(git merge-base $MAIN_BRANCH HEAD)
  {
    echo "## 2. New Work on This Branch (Compared to \`$MAIN_BRANCH\`)"
    echo ""
    if [ $(git rev-list --count $MERGE_BASE..HEAD) -eq 0 ]; then
      echo "No new commits found on this branch compared to \`$MAIN_BRANCH\`."
    else
      echo "**Commit History:**"
      echo '```'
      git log --oneline $MERGE_BASE..HEAD
      echo '```'
      echo ""
      echo "**Detailed file changes (diff):**"
      echo '```diff'
      git diff $MERGE_BASE..HEAD
      echo '```'
    fi
    echo ""
    echo "---"
  } >> "$OUTPUT_FILE"
fi

# --- Section 2: Project Structure ---
{
  echo "## 3. Project Structure"
  echo ""
  echo '```'
  tree -a -I '.git|.task|bin|node_modules|.venv|__pycache__|*.log|contextvibes_*.md'
  echo '```'
  echo ""
  echo "---"
} >> "$OUTPUT_FILE"

# --- Section 3: Key Project Files ---
echo "## 4. Key Project Files" >> "$OUTPUT_FILE"
KEY_FILES=(
  "README.md"
  "Taskfile.yml"
  ".idx/dev.nix"
  ".idx/airules.md"
  ".github/CONTRIBUTING.MD"
  ".contextvibes.yaml"
)

for file in "${KEY_FILES[@]}"; do
  if [ -f "$file" ]; then
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

echo "✅ Comprehensive export complete. Report saved to '$OUTPUT_FILE'."
