#!/bin/bash
# scripts/start_task.sh (FINAL, STATE-AWARE VERSION)
#
# WHY:  Handles starting a new feature branch safely and intelligently.
# WHAT: Checks for uncommitted changes. If found, it asks the user for
#       permission to stash them and carry them over to the new branch.
# HOW:  Uses git commands and an interactive 'read' prompt.

set -e

# --- Phase 1: State Verification and Orchestrator Decision ---
STASH_PERFORMED=false
if ! git diff --quiet --exit-code; then
  echo "⚠️  You have uncommitted changes."
  read -p "    Stash them and bring them to the new branch? (Y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo "Aborted by user. Please commit or stash your changes before running again."
    exit 1
  else
    git stash
    STASH_PERFORMED=true
    echo "✅ Changes stashed."
  fi
fi

# --- Phase 2: Branch Creation ---
# Validate that a branch name was provided.
if [ -z "$1" ]; then
  echo "❌ ERROR: You must provide a name for the new feature branch."
  echo "   Usage: task task-start -- <new-branch-name>"
  # If we stashed, we should pop the stash before exiting
  if [ "$STASH_PERFORMED" = true ]; then git stash pop; fi
  exit 1
fi

BRANCH_NAME=$1

echo "--> Creating and switching to new branch '$BRANCH_NAME'..."
git checkout -b "$BRANCH_NAME"
echo "✅ Switched to a new branch '$BRANCH_NAME'."

# --- Phase 3: Restore Stashed Changes (if any) ---
if [ "$STASH_PERFORMED" = true ]; then
  echo "--> Re-applying your stashed changes..."
  git stash pop
  echo "✅ Your work has been restored to the new branch."
fi
