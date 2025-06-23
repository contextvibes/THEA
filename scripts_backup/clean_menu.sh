#!/bin/bash
# scripts/clean.sh
# A smart script for cleaning the project. It can be run interactively
# or with a specific mode ('project' or 'full') as an argument.

# --- Script Functions ---

# Function to perform the actual cleaning operations.
do_clean() {
  local MODE=$1
  case "$MODE" in
    "project")
      echo "--> Cleaning local project artifacts (bin/, .task/, coverage.*)..."
      rm -rf bin .task coverage.*
      echo "✅ Project artifacts cleaned."
      ;;
    "full")
      echo "--> Cleaning local project artifacts..."
      rm -rf bin .task coverage.*

      echo "--> Cleaning Go caches (build, module, test)..."
      go clean -cache -modcache -testcache

      echo "--> Pruning all unused Docker resources (this may take a moment)..."
      docker system prune -af --volumes

      echo "✅ Full system clean complete."
      ;;
    *)
      # This case should not be hit in normal operation.
      echo "Error: Invalid cleaning mode '$MODE' passed to do_clean function." >&2
      exit 1
      ;;
  esac
}

# Function to display the interactive menu.
show_menu() {
  echo
  echo "Please select a cleaning mode:"
  PS3="Your choice: "
  select opt in \
    "Project Only (Fast: Removes bin/, coverage.*, etc.)" \
    "Full System Clean (Slow: Also purges Go & Docker caches)" \
    "Quit"
  do
    case $opt in
      "Project Only (Fast: Removes bin/, coverage.*, etc.)")
        do_clean "project"
        break
        ;;
      "Full System Clean (Slow: Also purges Go & Docker caches)")
        echo
        read -p "DANGER: This will remove all unused Docker images, containers, and volumes on your system. Are you sure? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          do_clean "full"
        else
          echo "Aborted by user."
        fi
        break
        ;;
      "Quit")
        echo "Aborted."
        break
        ;;
      *) echo "Invalid option $REPLY";;
    esac
  done
}

# --- Main Script Logic ---

# If the first argument ($1) is empty, show the interactive menu.
if [ -z "$1" ]; then
  show_menu
else
  # If an argument is provided, pass it directly to the cleaning function.
  do_clean "$1"
fi