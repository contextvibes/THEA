#!/bin/bash
# factory/scripts/commit.sh
#
# WHAT: Handles the logic for committing changes safely. It stages all changes
#       and then passes any arguments directly to the 'git commit' command.
# WHY:  Provides a safe, standardized wrapper around 'git commit' that prevents
#       accidental commits to the main branch.

set -e

# --- Configuration & Setup ---
# WHAT: Imports shared constants like MAIN_BRANCH from the helper script.
# WHY:  Ensures that the definition of the main branch is consistent across all scripts.
# shellcheck source=./_automation_helpers.sh
source "$(dirname "$0")/_automation_helpers.sh"


# --- Safety Check ---
# WHAT: Prevents the script from running on the main branch.
# WHY:  This is a critical guardrail to enforce a feature-branch workflow and
#       protect the main branch from direct commits.
if [[ "$(git rev-parse --abbrev-ref HEAD)" == "$MAIN_BRANCH" ]]; then
  gum style --border normal --margin "1" --padding "1 2" --border-foreground 99 "❌ ERROR: Direct commits to the '$MAIN_BRANCH' branch are not allowed."
  echo "   Please use 'task task-start' to create a feature branch first."
  exit 1
fi

# --- Execution ---
echo "--> Staging all changes..."
git add .

echo "--> Committing staged changes..."
# WHAT: Passes all command-line arguments (like -m "message") to 'git commit'.
# WHY:  This allows the task to act as a seamless, transparent proxy for the
#       underlying git command.
git commit "$@"

gum style --foreground 212 "✅ Commit successful."
