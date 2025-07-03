#!/bin/bash
# factory/scripts/commit.sh
#
# WHAT: Provides a safe, interactive, and guided workflow for creating Git commits.
# WHY:  Instead of a blunt 'git add .', this script forces the developer to
#       intentionally select which files to stage and to write a well-formatted
#       commit message, preventing common errors and improving commit quality.

set -e

# --- Configuration & Setup ---
# shellcheck source=./_automation_helpers.sh
source "$(dirname "$0")/_automation_helpers.sh"


# --- Safety Checks ---
prevent_action_on_main_branch "commit"
validate_current_branch_compliance


# --- Phase 1: Interactive Staging ---
echo "--> Analyzing changed files..."
GIT_STATUS_LINES=$(git status --porcelain)

if [ -z "$GIT_STATUS_LINES" ]; then
    gum style --bold "✅ No changes to commit. Working tree is clean."
    exit 0
fi

gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "SELECT FILES TO STAGE FOR COMMIT"
echo "Status: M=Modified, A=Added, D=Deleted, R=Renamed, ??=Untracked"
echo "Use [space] to select, [enter] to confirm."

SELECTED_LINES=$(echo "$GIT_STATUS_LINES" | gum filter --no-limit --placeholder="Choose files to stage for the commit...")

if [ -z "$SELECTED_LINES" ]; then
    echo "No files selected. Aborting commit."
    exit 0
fi


# --- Staging Logic ---
echo "--> Staging selected files..."

# WHAT: This loop uses 'awk' to reliably parse each line of the git status output.
# WHY:  This is the robust solution. 'awk' correctly separates the status code from
#       the filename, regardless of spacing, preventing the "pathspec" error.
#       'git add' is then used to stage all changes, as it correctly handles
#       new, modified, deleted, and renamed files when given the right path.
echo "$SELECTED_LINES" | grep -v '^>' | while IFS= read -r line; do
    if [ -z "$line" ]; then continue; fi

    # Use awk to print everything from the second field onwards. This reliably
    # gets the full filename, even if it contains spaces (like in a rename).
    filename=$(echo "$line" | awk '{ $1=""; print $0 }' | sed 's/^ *//')

    echo "Staging: $filename"
    # The '--' tells git to stop processing flags, making it safe for filenames
    # that might start with a dash.
    git add -- "$filename"
done

gum style --faint "Staging complete."


# --- Phase 2: Interactive Commit Message ---
gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "COMPOSE COMMIT MESSAGE"

COMMIT_TYPE=$(gum choose "feat" "fix" "docs" "style" "refactor" "test" "chore" "factory")
COMMIT_SCOPE=$(gum input --placeholder="(optional scope, e.g., 'api', 'db')")
COMMIT_SUBJECT=$(gum input --placeholder="Short description (imperative mood, e.g., 'Add new endpoint')")
COMMIT_BODY=$(gum write --placeholder="Longer description (optional)...")

if [ -n "$COMMIT_SCOPE" ]; then
    COMMIT_SCOPE="($COMMIT_SCOPE)"
fi

COMMIT_HEADER="${COMMIT_TYPE}${COMMIT_SCOPE}: ${COMMIT_SUBJECT}"


# --- Phase 3: Final Confirmation and Commit ---
gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "FINAL CONFIRMATION"
gum style --bold "Commit with the following message?"
echo
gum style --background 236 --padding "1" "${COMMIT_HEADER}"$'\n\n'"${COMMIT_BODY}"
echo

if ! gum confirm "Proceed with commit?"; then
    echo "Aborted by user."
    echo "To unstage the files, run: git reset"
    exit 1
fi

echo "--> Committing..."
git commit -m "$COMMIT_HEADER" -m "$COMMIT_BODY"

gum style --foreground 212 "✅ Commit successful."
