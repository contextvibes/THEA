#!/bin/bash
# scripts/clean.sh (FINAL, STATE-AWARE, ROBUST VERSION)
#
# WHY:  Provides a single, smart cleanup command that respects user's work.
# WHAT: Checks for uncommitted changes and asks the user for permission to
#       stash them before proceeding with the cleanup workflow.

set -e

# --- Phase 0: Get Original State ---
ORIGINAL_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# --- Phase 1: State Verification and Orchestrator Decision ---
STASH_PERFORMED=false
if ! git diff --quiet --exit-code; then
  echo "⚠️ You have uncommitted changes."
  read -p "   Would you like to temporarily stash them to proceed? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    git stash
    STASH_PERFORMED=true
    echo "✅ Changes stashed."
  else
    echo "Aborted by user. Please commit or stash your changes before running again."
    exit 1
  fi
fi

# --- Cleanup function to restore original state ---
cleanup() {
  echo ""
  echo "--> Returning to original state..."
  # Switch back to the original branch BEFORE popping the stash
  if [[ "$(git rev-parse --abbrev-ref HEAD)" != "$ORIGINAL_BRANCH" ]]; then
    echo "--> Switching back to branch '$ORIGINAL_BRANCH'."
    git checkout "$ORIGINAL_BRANCH"
  fi

  if [ "$STASH_PERFORMED" = true ]; then
    echo "--> Re-applying your stashed changes..."
    git stash pop
    echo "✅ Your work has been restored."
  fi
}
# Register the cleanup function to run on script exit
trap cleanup EXIT

# --- Phase 2: Automatic File Cleanup ---
echo ""
echo "--> Performing automatic file cleanup..."
rm -f contextvibes_*.md
echo "✅ Generated report files cleaned."
echo ""

# --- Phase 3: Analysis ---
echo "--> Analyzing repository for branch cleanup opportunities..."
MAIN_BRANCH="main"
BRANCH_PATTERN="^((feature|fix|docs|format)/.+)$"

git fetch --all --prune

# Switch to main to get an accurate list of merged branches
if [[ "$(git rev-parse --abbrev-ref HEAD)" != "$MAIN_BRANCH" ]]; then
  echo "--> Switching to the '$MAIN_BRANCH' branch..."
  git checkout "$MAIN_BRANCH"
fi
echo "--> Pulling latest changes on '$MAIN_BRANCH'..."
git pull origin "$MAIN_BRANCH"

# Identify branches for cleanup.
MERGED_BRANCHES=$(git branch --merged "$MAIN_BRANCH" | grep -v '^\* ' | grep -v " $MAIN_BRANCH$" | sed 's/^[ ]*//' || true)
ALL_LOCAL_BRANCHES=$(git branch | sed 's/^\* //' | grep -v " $MAIN_BRANCH$" | sed 's/^[ ]*//' || true)
NON_COMPLIANT_BRANCHES=""

for branch in $ALL_LOCAL_BRANCHES; do
  if [[ ! "$branch" =~ $BRANCH_PATTERN ]]; then
    if ! echo "$MERGED_BRANCHES" | grep -q "^$branch$"; then
      NON_COMPLIANT_BRANCHES="$NON_COMPLIANT_BRANCHES $branch"
    fi
  fi
done

if [ -z "$MERGED_BRANCHES" ] && [ -z "$NON_COMPLIANT_BRANCHES" ]; then
  echo "✅ No local branches require attention. Repository is clean."
  exit 0
fi

# --- Phase 4: Present Decisions ---
echo "---"
echo "The following branches require your attention:"
echo ""

if [ -n "$MERGED_BRANCHES" ]; then
    echo "--- Merged Branches (Safe to Delete) ---"
    for branch in $MERGED_BRANCHES; do
        read -p "Delete local branch '$branch'? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git branch -d "$branch"
            echo "    ✅ Deleted local branch '$branch'."
        else
            echo "    ☑️  Skipped local branch '$branch'."
        fi
    done
    echo ""
fi

if [ -n "$NON_COMPLIANT_BRANCHES" ]; then
    echo "--- Non-Compliant Branches (Review Carefully) ---"
    for branch in $NON_COMPLIANT_BRANCHES; do
        read -p "Delete local branch '$branch'? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git branch -d "$branch"
            echo "    ✅ Deleted local branch '$branch'."

            read -p "      Delete remote branch 'origin/$branch' as well? (y/N) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                git push origin --delete "$branch"
                echo "    ✅ Deleted remote branch 'origin/$branch'."
            else
                echo "    ☑️  Skipped remote branch."
            fi
        else
            echo "    ☑️  Skipped local branch '$branch'."
        fi
    done
    echo ""
fi

echo "✅ Branch cleanup complete."
