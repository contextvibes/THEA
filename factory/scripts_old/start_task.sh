#!/bin/bash
# scripts/start_task.sh (VERSION 2 - WITH BRANCH NAME VALIDATION)
#
# WHY:  Handles starting a new feature branch safely and intelligently.
# WHAT: Checks for uncommitted changes and validates the new branch name
#       against the project's conventions before creating it.
# HOW:  Uses git commands, an interactive 'read' prompt, and regex matching.

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

# --- Phase 2: Branch Creation & Validation ---
# Validate that a branch name was provided.
if [ -z "$1" ]; then
  echo "❌ ERROR: You must provide a name for the new feature branch."
  echo "   Usage: task task-start -- <new-branch-name>"
  # If we stashed, we should pop the stash before exiting
  if [ "$STASH_PERFORMED" = true ]; then git stash pop; fi
  exit 1
fi

BRANCH_NAME=$1
BRANCH_PATTERN="^((feature|fix|docs|format)/.+)$"

# --- NEW: Validate the branch name against the pattern ---
if [[ ! "$BRANCH_NAME" =~ $BRANCH_PATTERN ]]; then
  echo "❌ ERROR: Invalid branch name: '$BRANCH_NAME'"
  echo "   Branches must follow the pattern: type/description"
  echo "   Valid types are: feature, fix, docs, format"
  echo "   Example: task task-start -- feature/new-context-menu"
  if [ "$STASH_PERFORMED" = true ]; then git stash pop; fi
  exit 1
fi

echo "--> Creating and switching to new branch '$BRANCH_NAME'..."
git checkout -b "$BRANCH_NAME"
echo "✅ Switched to a new branch '$BRANCH_NAME'."

# --- Phase 3: Restore Stashed Changes (if any) ---
if [ "$STASH_PERFORMED" = true ]; then
  echo "--> Re-applying your stashed changes..."
  git stash pop
  echo "✅ Your work has been restored to the new branch."
fi
