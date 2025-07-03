#!/bin/bash
# factory/scripts/clean.sh
#
# WHAT: A workflow-driven script to help developers finalize and clean up
#       their work on feature branches.
# WHY:  Instead of just deleting files, this script automates the common Git
#       workflows for what to do after a branch is merged, or for tidying
#       up a local repository, ensuring safety and consistency.

set -e

# --- Configuration & Setup ---
# WHAT: Imports shared constants and functions from the helper script.
# WHY:  To use shared logic like `prompt_to_stash_if_dirty` and `MAIN_BRANCH`.
# shellcheck source=./_automation_helpers.sh
source "$(dirname "$0")/_automation_helpers.sh"

# WHAT: Saves the user's original branch name when the script starts.
# WHY:  This is part of the script's core safety mechanism, ensuring we can
#       always return the user to their starting point.
ORIGINAL_BRANCH=$(git rev-parse --abbrev-ref HEAD)
STASH_PERFORMED="false"

# --- Safety Net ---
# WHAT: Defines a cleanup function that will run automatically when the script exits.
# WHY:  This is a critical safety feature. It guarantees that if the script changes
#       branches, it will always return the user to where they started. It also
#       ensures any stashed work is restored.
cleanup() {
  if [[ "$(git rev-parse --abbrev-ref HEAD)" != "$ORIGINAL_BRANCH" ]]; then
    echo
    gum style --bold "--> Returning to original branch '$ORIGINAL_BRANCH'..."
    git checkout "$ORIGINAL_BRANCH" >/dev/null 2>&1
  fi
  if [ "$STASH_PERFORMED" = "true" ]; then
    echo
    gum style --bold "--> Re-applying stashed changes..."
    git stash pop || echo "⚠️ Warning: Could not auto-apply stashed changes due to a conflict."
  fi
}
trap cleanup EXIT


# --- ACTION FUNCTIONS ---

# WHAT: Handles the workflow for when a PR has been merged. It moves the user
#       to the main branch, pulls the latest changes, and then deletes the
#       now-merged local feature branch.
# WHY:  Automates the complete "end-of-task" cleanup process.
finish_merged_branch() {
    gum style --bold --padding "1 0" "--- Finish Merged Branch Workflow ---"
    
    if [[ "$ORIGINAL_BRANCH" == "$MAIN_BRANCH" ]]; then
        gum style --foreground 9 "Error: You are already on the main branch. There is no branch to finish."
        exit 1
    fi
    
    if ! gum confirm "This will delete your local branch '$ORIGINAL_BRANCH' and switch to '$MAIN_BRANCH'. Are you sure it has been merged?"; then
        echo "Aborted by user."
        exit 0
    fi
    
    echo "--> Switching to '$MAIN_BRANCH'..."
    git checkout "$MAIN_BRANCH"
    
    echo "--> Pulling latest changes..."
    git pull origin "$MAIN_BRANCH"
    
    echo "--> Deleting local branch '$ORIGINAL_BRANCH'..."
    git branch -d "$ORIGINAL_BRANCH"
    
    gum style --bold "✅ Successfully cleaned up '$ORIGINAL_BRANCH' and updated '$MAIN_BRANCH'."
    # Offer to do a deeper prune as well.
    if gum confirm "Also prune other stale branches now?"; then
        prune_stale_branches
    fi
}

# WHAT: Finds and interactively deletes old local branches that have already
#       been merged into main and deleted on the remote repository.
# WHY:  This is a safe way to keep a local developer's repository tidy without
#       affecting their current work.
prune_stale_branches() {
    gum style --bold --padding "1 0" "--- Prune Stale Branches ---"
    echo "--> Fetching remote state and searching for stale branches..."
    git fetch --all --prune
    
    local temp_main_branch_checkout=false
    # If not on main, we need to switch to it temporarily for an accurate check.
    if [[ "$(git rev-parse --abbrev-ref HEAD)" != "$MAIN_BRANCH" ]]; then
        temp_main_branch_checkout=true
        git checkout "$MAIN_BRANCH" >/dev/null 2>&1
    fi
    
    local remote_branches
    remote_branches=$(git branch -r | sed 's|origin/||' | sed 's/^[ \t]*//')
    local merged_local_branches
    merged_local_branches=$(git branch --merged main | grep -vE '^\*|main$' | sed 's/^[ \t]*//')
    local stale_branches
    stale_branches=$(comm -23 <(echo "$merged_local_branches" | sort) <(echo "$remote_branches" | sort))
    
    # Switch back if we temporarily changed branches.
    if [ "$temp_main_branch_checkout" = true ]; then
        git checkout "$ORIGINAL_BRANCH" >/dev/null 2>&1
    fi

    if [ -z "$stale_branches" ]; then
        gum style --bold "✅ No stale local branches found."
        return
    fi
    
    gum style --bold "The following stale branches can be safely deleted:"
    echo "$stale_branches" | gum style --faint

    if gum confirm "Proceed with deletion?"; then
        echo "$stale_branches" | xargs git branch -d
        gum style --bold "✅ Stale branches deleted."
    else
        gum style --bold "Aborted. No branches were deleted."
    fi
}

# WHAT: Cleans up temporary project files.
# WHY:  Provides a quick way to reset the local workspace without affecting code.
clean_project_files() {
    gum style --bold --padding "1 0" "--- Clean Local Project Files ---"
    echo "--> Removing compiled binaries (./bin)..."
    rm -rf ./bin
    echo "--> Cleaning Go build cache..."
    go clean
    echo "--> Removing temporary context files..."
    rm -f context_*.md contextvibes_*.md context_*.log contextvibes_*.log
    echo "--> Removing Task runner cache (./.task)..."
    rm -rf ./.task
    gum style --bold "✅ Project files cleaned."
}

# --- Main Script Logic ---

STASH_PERFORMED=$(prompt_to_stash_if_dirty)

# The new, workflow-oriented menu.
gum style --bold --padding "1 0" "🧹 What would you like to do?"
CHOICE=$(gum choose \
    "Finish Merged Branch (delete current branch, go to main)" \
    "Prune Old Branches (stay on current branch)" \
    "Clean Local Project Files Only" \
    "Quit")

case "$CHOICE" in
    "Finish Merged Branch (delete current branch, go to main)")
        finish_merged_branch
        ;;
    "Prune Old Branches (stay on current branch)")
        prune_stale_branches
        ;;
    "Clean Local Project Files Only")
        clean_project_files
        ;;
    *)
        gum style --bold "Aborted."
        # IMPORTANT: Manually trigger cleanup if we stashed but are quitting.
        # This prevents the trap from firing after a clean exit.
        if [ "$STASH_PERFORMED" = true ]; then
          cleanup
          # Disable the trap so it doesn't run again.
          trap - EXIT
        fi
        exit 0
        ;;
esac

echo
gum style --bold "✅ Operation complete."
