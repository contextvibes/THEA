# -----------------------------------------------------------------------------
# SECTION: SHARED VARIABLES & CONSTANTS
# -----------------------------------------------------------------------------
# WHAT: Define variables here that are used by multiple scripts.
# WHY:  Centralizing constants prevents "magic strings" and makes global
#       changes (like renaming the main branch) trivial.
# -----------------------------------------------------------------------------
readonly MAIN_BRANCH="main"
readonly PROMPTS_DIR="docs/prompts"
readonly CONTEXT_STATUS_FILE="contextvibes_status.md"
readonly BRANCH_PATTERN="^((feature|fix|docs|format)/.+)$"


# -----------------------------------------------------------------------------
# SECTION: SHARED FUNCTIONS
# -----------------------------------------------------------------------------
# WHAT: Reusable functions for common automation tasks.
# WHY:  Encapsulates logic into named, single-responsibility blocks.
# -----------------------------------------------------------------------------

# ---
# WHAT:  Checks if the current branch is the main branch and exits if it is.
# WHY:   A critical safety guard to prevent direct modifications or operations
#        on the primary branch, enforcing a feature-branch workflow.
# FROM:  commit.sh, finish_task.sh
# USAGE: prevent_run_on_main
# ---
prevent_run_on_main() {
  if [ "$(git rev-parse --abbrev-ref HEAD)" == "$MAIN_BRANCH" ]; then
    echo "❌ ERROR: This command cannot be run on the '$MAIN_BRANCH' branch." >&2
    exit 1
  fi
}

# ---
# WHAT:  Checks for any uncommitted (staged or unstaged) changes and exits
#        if the workspace is "dirty".
# WHY:   Ensures that scripts which perform Git operations start from a clean,
#        known state, preventing accidental inclusion of unrelated changes.
# FROM:  finish_task.sh
# USAGE: ensure_clean_workspace
# ---
ensure_clean_workspace() {
  if ! git diff --quiet --exit-code; then
    echo "❌ ERROR: You have uncommitted changes. Please commit or stash them first." >&2
    exit 1
  fi
}

# ---
# WHAT:  A non-fatal version of ensure_clean_workspace that just prints a warning.
# WHY:   Useful for context-generation scripts where uncommitted changes might
#        be relevant to the output, but the user should be aware of them.
# FROM:  context_pr.sh
# USAGE: warn_if_dirty
# ---
warn_if_dirty() {
  if ! git diff --quiet --exit-code; then
    echo "⚠️  Warning: You have uncommitted changes that may not be reflected in the output." >&2
  fi
}

# ---
# WHAT:  A user-friendly version of ensure_clean_workspace. It checks for
#        uncommitted changes and, if found, interactively prompts the user
#        to stash them before proceeding.
# WHY:   Provides a better user experience than simply exiting. It allows the
#        user to save their work-in-progress and continue the current task
#        without having to manually run git commands.
# FROM:  clean.sh, start_task.sh
# USAGE: STASH_PERFORMED=$(prompt_to_stash_if_dirty)
#        # ... later in the script ...
#        if [ "$STASH_PERFORMED" = "true" ]; then git stash pop; fi
# ---
prompt_to_stash_if_dirty() {
  if ! git diff --quiet --exit-code; then
    echo "⚠️  You have uncommitted changes."
    read -p "    Stash them and continue? (Y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
      echo "Aborted by user. Please commit or stash your changes before running again."
      exit 1
    else
      git stash
      echo "✅ Changes stashed."
      # Return "true" to the calling script to signal a stash was performed
      echo "true"
    fi
  else
    # Return "false" if no stash was performed
    echo "false"
  fi
}

# ---
# WHAT:  Validates a given branch name against the project's convention.
# WHY:   Enforces consistent branch naming across the project, which helps
#        with organization and automation.
# FROM:  start_task.sh, clean.sh
# USAGE: validate_branch_name "feature/my-new-thing"
# ---
validate_branch_name() {
  local branch_name="$1"
  if [[ ! "$branch_name" =~ $BRANCH_PATTERN ]]; then
    echo "❌ ERROR: Invalid branch name: '$branch_name'" >&2
    echo "   Branches must follow the pattern: type/description" >&2
    echo "   Valid types are: feature, fix, docs, format" >&2
    echo "   Example: feature/new-context-menu" >&2
    exit 1
  fi
}

# ---
# WHAT:  Checks if the GitHub CLI ('gh') is installed and authenticated.
# WHY:   Ensures that scripts relying on GitHub integration (like creating a
#        pull request) can function correctly.
# FROM:  finish_task.sh
# USAGE: ensure_gh_cli_authenticated
# ---
ensure_gh_cli_authenticated() {
  if ! gh auth status > /dev/null 2>&1; then
    echo "❌ ERROR: GitHub CLI ('gh') is not authenticated. Please run 'gh auth login'." >&2
    exit 1
  fi
}

# ---
# WHAT:  Checks for merge conflicts between the current branch and main without
#        actually performing a merge.
# WHY:   A critical pre-flight check before attempting a merge or PR. It allows
#        the script to fail early with a clear message if conflicts exist.
# FROM:  finish_task.sh
# USAGE: check_for_merge_conflicts
# ---
check_for_merge_conflicts() {
  echo "--> Analyzing branch for merge conflicts with '$MAIN_BRANCH'..."
  git fetch origin "$MAIN_BRANCH"
  # Uses git merge-tree to simulate a merge and checks for conflict markers
  if git merge-tree "$(git merge-base "origin/$MAIN_BRANCH" HEAD)" HEAD "origin/$MAIN_BRANCH" | grep -q '<<<<<<<'; then
    echo "❌ CONFLICT DETECTED: This branch has conflicts with '$MAIN_BRANCH'." >&2
    echo "   Please resolve them manually (e.g., 'git pull origin $MAIN_BRANCH') before proceeding." >&2
    exit 1
  fi
  echo "✅ No merge conflicts detected."
}

# ---
# WHAT:  Checks if a given file is a text-based file and not a binary.
# WHY:   Prevents scripts from attempting to 'cat' binary files (like images
#        or executables) into a text-based report, which would corrupt it.
# FROM:  context_export_all.sh, context_export_docs.sh, context_export.sh
# USAGE: if is_text_file "path/to/file.md"; then ... fi
# ---
is_text_file() {
  local file_path="$1"
  # The 'file' command inspects the content, and we grep for keywords
  # that indicate it's safe to treat as text.
  if file "$file_path" | grep -E -q 'text|script|JSON|XML|YAML|HTML|CSS|Markdown|empty'; then
    return 0 # Success (it is a text file)
  else
    return 1 # Failure (it is not a text file)
  fi
}

# WHAT:  Creates a new report file, prepending it with a custom prompt if one
#        exists, or a generic default prompt if it does not.
# WHY:   Standardizes the creation of all context export files, ensuring they
#        are always formatted correctly for AI analysis.
# FROM:  context_export_automation.sh, context_export_code.sh, etc.
# USAGE: generate_report_header "path/to/output.md" "path/to/custom_prompt.md" "Default Prompt Title" "Default Prompt Body"
# ---
generate_report_header() {
  local output_file="$1"
  local custom_prompt_file="$2"
  local default_title="$3"
  local default_body="$4"

  if [ -f "$custom_prompt_file" ]; then
    echo "--> Using custom prompt from '$custom_prompt_file'."
    cat "$custom_prompt_file" > "$output_file"
  else
    echo "--> Custom prompt not found. Using default."
    {
      echo "# AI Prompt: $default_title"
      echo ""
      echo "## Your Role"
      echo "$default_body"
      echo ""
      echo "## The Task"
      echo "Review the following export to gain a complete understanding of the requested context. Acknowledge that you are up-to-date and ready for the next instruction."
    } > "$output_file"
  fi

  # Append the standard export header after the prompt
  {
    echo ""
    echo "---"
    echo "# Automation Framework Export"
    echo ""
    echo "**Branch:** \`$(git rev-parse --abbrev-ref HEAD)\`"
    echo "**Generated:** $(date)"
    echo ""
    echo "---"
  } >> "$output_file"
}
