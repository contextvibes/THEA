#!/bin/bash
# scripts/start_task.sh
#
# WHY:  Handles the logic for starting a new feature branch safely.
# WHAT: Verifies the working directory is clean, then creates and
#       checks out a new Git branch from the current branch.
# HOW:  Takes the new branch name as an argument.

set -e

# 1. Safety Check: Ensure the working directory is clean before proceeding.
if ! git diff --quiet --exit-code; then
  echo "❌ ERROR: You have uncommitted changes."
  echo "   Please commit or stash them before starting a new task."
  exit 1
fi

# 2. Validate that a branch name was provided.
if [ -z "$1" ]; then
  echo "❌ ERROR: You must provide a name for the new feature branch."
  echo "   Usage: task task-start -- <new-branch-name>"
  exit 1
fi

BRANCH_NAME=$1

echo "--> Creating and switching to new branch '$BRANCH_NAME'..."
git checkout -b "$BRANCH_NAME"

echo "✅ Switched to a new branch '$BRANCH_NAME'."
