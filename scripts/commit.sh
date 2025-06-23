#!/bin/bash
# scripts/commit.sh
#
# WHY:  Handles the logic for committing changes safely.
# WHAT: Checks that the current branch is not 'main', then stages all
#       changes and commits them using any arguments passed.
# HOW:  Uses 'git rev-parse' for the branch check, then 'git add' and 'git commit'.

set -e

MAIN_BRANCH="main"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# --- Safety Check ---
if [ "$CURRENT_BRANCH" == "$MAIN_BRANCH" ]; then
  echo "❌ ERROR: Direct commits to the '$MAIN_BRANCH' branch are not allowed."
  echo "   Please use 'task task-start -- <branch-name>' to create a feature branch."
  exit 1
fi

echo "--> Staging all changes..."
git add .

echo "--> Committing staged changes..."
# "$@" passes all arguments from the Taskfile to the git commit command
git commit "$@"

echo "✅ Commit successful."
