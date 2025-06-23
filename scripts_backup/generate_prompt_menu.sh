#!/bin/bash
# scripts/generate_prompt_menu.sh

# This script displays an interactive menu for selecting an AI prompt template.

echo
echo "Please select a prompt template to view:"
PS3="Your choice: "
select opt in \
  "Review Code Quality" \
  "Cleanup and Refactor Code" \
  "Quit"
do
  case $opt in
    "Review Code Quality")
      echo
      echo "--- Displaying prompts/code-quality.md ---"
      cat ./prompts/code-quality.md
      break
      ;;
    "Cleanup and Refactor Code")
      echo
      echo "--- Displaying prompts/cleanup.md ---"
      cat ./prompts/cleanup.md
      break
      ;;
    "Quit")
      echo "Aborted."
      break
      ;;
    *) echo "Invalid option $REPLY";;
  esac
done