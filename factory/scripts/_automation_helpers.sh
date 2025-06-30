#!/bin/bash
# factory/scripts/_automation_helpers.sh
#
# WHAT: A shared library of bash functions and variables used across the
#       automation factory.
# WHY:  Centralizes generic, reusable logic to keep other scripts clean
#       and to avoid code duplication (DRY principle).

# --- Shared Configuration Variables ---
readonly PROMPTS_DIR="factory/prompts"
readonly MAIN_BRANCH="main"
# WHAT: Defines the standard branch naming convention for the project.
# WHY:  Provides a single source of truth for all scripts that need to
#       validate branch names (e.g., start_task, clean).
readonly BRANCH_PATTERN="^((feature|fix|docs|style|refactor|test|chore|factory)/.+)$"


# --- Shared Functions ---

# WHAT: A user-friendly check for uncommitted changes. If the repo is dirty,
#       it interactively prompts the user to stash them.
# WHY:  Provides a consistent, safe way for any script to ensure it's starting
#       from a clean state, without aborting if the user just forgot to save.
# USAGE: STASH_PERFORMED=$(prompt_to_stash_if_dirty)
#        Returns "true" if a stash was performed, otherwise "false".
prompt_to_stash_if_dirty() {
    if ! git diff --quiet --exit-code; then
        gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "⚠️ You have uncommitted changes."
        if gum confirm "Stash them and bring them to the new branch?"; then
            git stash
            echo "true"
            return
        else
            echo "Aborted by user. Please commit or stash your changes."
            exit 1
        fi
    fi
    echo "false"
}


# WHAT: Checks if a given file path points to a text-based file.
# WHY:  This is a crucial safety check to prevent scripts from attempting to
#       print the contents of binary files (like images), which would corrupt
#       any generated reports. It returns 0 (true) for text files and 1 (false) otherwise.
is_text_file() {
  local file_path="$1"
  if [ ! -f "$file_path" ]; then
    return 1
  fi
  local mime_type
  mime_type=$(file --brief --mime-type "$file_path")
  case "$mime_type" in
    text/*|application/json|application/javascript|application/x-sh|application/x-shellscript|application/xml|application/x-yaml|application/x-nix|inode/x-empty)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

# WHAT: Generates a standard header for a report file.
# WHY:  Ensures that all generated context files have a consistent structure.
#       It uses a dedicated prompt file if it exists, otherwise it falls
#       back to a high-quality, built-in default prompt.
generate_report_header() {
  local output_file="$1"
  local prompt_file="$2"
  local default_title="$3"
  local default_task="$4"

  if [ -f "$prompt_file" ]; then
    echo "--> Using custom prompt from: $prompt_file"
    cat "$prompt_file" > "$output_file"
  else
    echo "--> Using improved default built-in prompt."
    local prompt_content
    prompt_content=$(cat <<EOF
# AI Prompt: $default_title

## Your Role & Task
$default_task

---
EOF
)
    echo "$prompt_content" > "$output_file"
  fi
}
