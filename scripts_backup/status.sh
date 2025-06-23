#!/bin/bash

# scripts/status.sh
#
# WHY: Generates a focused report on "what is new" for the current workspace.
# WHAT: It captures uncommitted local changes and, if on a feature branch,
#       the new commits and file diffs compared to the 'main' branch.
# HOW: Uses git commands to check status and diffs, then formats the
#      output into a structured markdown file for LLM context.

set -e

OUTPUT_FILE="contextvibes_status.md"
MAIN_BRANCH="main" # Or 'master', depending on your repository's default
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "--> Generating status report: What's new on branch '$CURRENT_BRANCH'?"

# Overwrite the file with the initial header
{
  echo "# Status Report: What's New?"
  echo ""
  echo "**Branch:** \`$CURRENT_BRANCH\`"
  echo "**Generated:** $(date)"
  echo ""
  echo "---"
} > "$OUTPUT_FILE"

# --- Section 1: Uncommitted Local Changes ---
echo "--> Capturing uncommitted local changes..."
{
  echo "## 1. Uncommitted Local Changes"
  echo ""
  echo '```'
  # Use `git status --porcelain` to check if there is any output.
  # If not, there are no changes. Otherwise, run the full `git status`.
  if [[ -z $(git status --porcelain) ]]; then
    echo "No uncommitted local changes. The working directory is clean."
  else
    git status
  fi
  echo '```'
  echo ""
  echo "---"
} >> "$OUTPUT_FILE"

# --- Section 2: New Commits and Diffs vs. Main Branch ---
# This section only runs if we are NOT on the main branch.
if [ "$CURRENT_BRANCH" != "$MAIN_BRANCH" ]; then
  echo "--> Comparing with '$MAIN_BRANCH' to find new commits and diffs..."
  # Find the common ancestor commit to compare against
  MERGE_BASE=$(git merge-base $MAIN_BRANCH HEAD)

  {
    echo "## 2. New Work on This Branch (Compared to \`$MAIN_BRANCH\`)"
    echo ""
    echo "**Commit History since branching from \`$MAIN_BRANCH\`:**"
    echo '```'
    # Show the log of new commits
    git log --oneline $MERGE_BASE..HEAD
    echo '```'
    echo ""
    echo "**Detailed file changes (diff):**"
    echo '```diff'
    # Show the full diff of all changes in those commits
    git diff $MERGE_BASE..HEAD
    echo '```'
  } >> "$OUTPUT_FILE"
fi

echo "✅ Full status report saved to '$OUTPUT_FILE'."
echo ""
echo "---"
echo "Status Summary for Terminal:"
echo "---"
# Display the short, concise summary to the terminal for the user.
git status --short
