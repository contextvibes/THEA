#!/bin/bash
# scripts/commit.sh
#
# WHY:  Handles the logic for committing changes.
# WHAT: Stages all changes and then commits them using any arguments passed.
# HOW:  Uses 'git add' and 'git commit' with "$@", which safely passes
#       all command-line arguments (like -m "message").

set -e

echo "--> Staging all changes..."
git add .

echo "--> Committing staged changes..."
# "$@" passes all arguments from the Taskfile to the git commit command
git commit "$@"

echo "✅ Commit successful."
