#!/bin/bash
# scripts/generate_playbook_menu.sh

# This script displays an interactive menu for selecting a playbook.

echo
echo "Please select a playbook to view:"
PS3="Your choice: "
select opt in \
  "Standard Feature Workflow" \
  "Hotfix Release Workflow" \
  "Quit"
do
  case $opt in
    "Standard Feature Workflow")
      echo
      echo "--- Displaying playbooks/new-feature-workflow.md ---"
      cat ./playbooks/new-feature-workflow.md
      break
      ;;
    "Hotfix Release Workflow")
      echo
      echo "--- Displaying playbooks/hotfix-release.md ---"
      cat ./playbooks/hotfix-release.md
      break
      ;;
    "Quit")
      echo "Aborted."
      break
      ;;
    *) echo "Invalid option $REPLY";;
  esac
done