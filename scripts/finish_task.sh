#!/bin/bash
# scripts/finish_task.sh (ORCHESTRATOR-FOCUSED VERSION)
#
# WHY:  Safely prepares a feature branch for a pull request by analyzing
#       the situation first and presenting a clear decision to the user.
# WHAT: It checks for merge conflicts *before* attempting to merge, and only
#       proceeds with user confirmation.
# HOW:  Uses git commands to simulate the merge and a read prompt for the decision.

set -e

MAIN_BRANCH="main"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "--> Verifying prerequisites..."
if [ "$CURRENT_BRANCH" == "$MAIN_BRANCH" ]; then
  echo "❌ ERROR: You cannot run task-finish from the '$MAIN_BRANCH' branch."
  exit 1
fi
if ! git diff --quiet --exit-code; then
  echo "❌ ERROR: You have uncommitted changes. Please commit or stash them first."
  exit 1
fi
if ! gh auth status > /dev/null 2>&1; then
    echo "❌ ERROR: GitHub CLI ('gh') is not authenticated. Please run 'gh auth login'."
    exit 1
fi
echo "✅ Prerequisites met."
echo ""

# --- Stage 1: Analysis ---
echo "--> Analyzing branch status against '$MAIN_BRANCH'..."
git fetch origin

# Check for potential conflicts without actually merging
if git merge-tree `git merge-base origin/$MAIN_BRANCH HEAD` HEAD origin/$MAIN_BRANCH | grep -q '<<<<<<<'; then
    echo "❌ CONFLICT DETECTED: This branch has conflicts with the latest changes in '$MAIN_BRANCH'."
    echo "   Please resolve these manually before creating a pull request."
    echo "   Recommended Action: Run 'git pull --rebase origin main', fix the conflicts, and then run 'task task-finish' again."
    exit 1
fi

echo "✅ No merge conflicts detected."
echo ""

# --- Stage 2: Orchestrator Decision ---
read -p "This branch can be cleanly updated from 'main'. Proceed to create PR? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted by user."
    exit 1
fi

# --- Stage 3: Execution ---
echo ""
echo "--> Syncing '$CURRENT_BRANCH' with '$MAIN_BRANCH'..."
git merge origin/"$MAIN_BRANCH"

echo ""
echo "--> Pushing updated branch to remote..."
git push -u origin "$CURRENT_BRANCH"

echo ""
echo "--> Opening browser to create a Pull Request..."
gh pr create --fill --web

echo ""
echo "✅ 'task-finish' complete. Please finalize your PR in the browser."
