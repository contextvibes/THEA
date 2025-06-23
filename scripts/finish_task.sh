#!/bin/bash
# scripts/finish_task.sh
#
# WHY:  Automates the process of finalizing a feature branch.
# WHAT: It syncs with the main branch, pushes changes, and opens a PR.
# HOW:  Uses git and the GitHub CLI (gh) to perform these actions safely.

set -e

MAIN_BRANCH="main"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "--> Verifying prerequisites..."

# 1. Ensure we are not on the main branch
if [ "$CURRENT_BRANCH" == "$MAIN_BRANCH" ]; then
  echo "❌ ERROR: You cannot run task-finish from the '$MAIN_BRANCH' branch."
  exit 1
fi

# 2. Ensure the working directory is clean
if ! git diff --quiet --exit-code; then
  echo "❌ ERROR: You have uncommitted changes. Please commit or stash them first."
  exit 1
fi

# 3. Ensure GitHub CLI is authenticated
if ! gh auth status > /dev/null 2>&1; then
    echo "❌ ERROR: GitHub CLI ('gh') is not authenticated. Please run 'gh auth login'."
    exit 1
fi

echo "✅ Prerequisites met."
echo ""
echo "--> Syncing '$CURRENT_BRANCH' with '$MAIN_BRANCH'..."
git pull --rebase origin "$MAIN_BRANCH"

echo ""
echo "--> Pushing updated branch to remote..."
# Use --force-with-lease for safety after a rebase
git push --force-with-lease

echo ""
echo "--> Opening browser to create a Pull Request..."
# --fill automatically uses commit history for the title and body
gh pr create --fill --web

echo ""
echo "✅ 'task-finish' complete. Please finalize your PR in the browser."
