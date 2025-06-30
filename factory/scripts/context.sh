#!/bin/bash
# factory/scripts/context.sh
#
# WHAT: A master script for context generation. It contains all logic
#       for generating context for various goals, such as commits, PRs,
#       and full project exports, consolidated into a single file.
# WHY:  Provides a single, maintainable entry point (`task context`) without
#       needing to call external helper scripts.

set -euo pipefail

# --- Configuration & Setup ---
# WHAT: Programmatically finds the absolute path to the project's root directory.
# WHY:  This makes all subsequent paths robust and independent of the execution directory.
GIT_ROOT=$(git rev-parse --show-toplevel)
readonly GIT_ROOT

# WHAT: Imports the single source of truth for all shared helper functions
#       (like `is_text_file` and `generate_report_header`).
# WHY:  This promotes code reuse and keeps this script's logic focused on its main task.
# shellcheck source=./_automation_helpers.sh
source "$(dirname "$0")/_automation_helpers.sh"


# ==============================================================================
# SHARED EXPORT HELPER
# ==============================================================================
# WHAT: Finds all tracked, text-based files in a given set of paths and
#       appends their content to a report file under a "Book" heading.
# WHY:  This is a reusable helper that prevents code duplication across
#       all the different "export-*" actions.
#
# Usage: export_book "Output Filename" "Book Title" "path1" "path2" ...
export_book() {
    local output_file="$1"
    local title="$2"
    shift 2
    local paths=("$@")

    { echo ""; echo "---"; echo "## Book: ${title}"; echo ""; } >> "$output_file"

    git -C "$GIT_ROOT" ls-files -- "${paths[@]}" | while IFS= read -r file; do
        [ -z "$file" ] && continue
        local full_path="$GIT_ROOT/$file"

        if ! is_text_file "$full_path"; then
            echo "--> Skipping non-text/binary file: $file"
            continue
        fi

        {
            echo ""
            echo "======== FILE: ${file} ========"
            echo "\`\`\`${file##*.}"
            cat "$full_path"
            echo "\`\`\`"
            echo "======== END FILE: ${file} ========"
        } >> "$output_file"
    done
}


# ==============================================================================
# SCRIPT ACTIONS
# ==============================================================================
# WHAT: Each function below corresponds to a specific context generation task
#       that can be selected from the menu or called directly.
# WHY:  Encapsulating each action in a function makes the main router logic
#       at the end of the script clean and easy to read.

# --- ACTION: Generate context for a commit message ---
# WHAT: Creates a context file containing the current git status and a diff
#       of all uncommitted changes (staged and unstaged).
# WHY:  This provides an AI with the exact information needed to draft a
#       high-quality, comprehensive commit message.
generate_commit_context() {
    local output_file="$GIT_ROOT/context_commit.md"
    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/generate-commit-message.md"
    
    echo "--> Generating context for commit message..."
    
    generate_report_header \
        "$output_file" \
        "$prompt_file" \
        "Generate Conventional Commit Command" \
        "You are an expert software engineer channeling the **\`Canon\`** persona, the guardian of project standards. Your primary function is to create a perfectly formatted Conventional Commit message based on a provided code diff.

Your goal is to analyze the following 'git status' and 'git diff' output and generate a single, complete 'task commit' command that is ready to be executed in the terminal."

    {
        echo ""
        echo "## Git Status"
        echo "\`\`\`"
        git status
        echo "\`\`\`"
        echo ""
        echo "---"
        echo "## Diff of All Uncommitted Changes"
        echo "\`\`\`diff"
        git diff --staged
        git diff
        echo "\`\`\`"
    } >> "$output_file"

    echo "✅ Commit context generated. File: '$output_file'"
}

# --- ACTION: Generate context for a Pull Request ---
# WHAT: Creates a context file containing the commit history and a full diff
#       of the current branch against the 'main' branch.
# WHY:  This gives an AI a complete picture of all the changes in a feature
#       branch, allowing it to write a thorough PR description.
generate_pr_context() {
    local output_file="$GIT_ROOT/context_pr.md"
    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/generate-pr-description.md"
    local main_branch="main"

    echo "--> Generating context for Pull Request description..."

    if ! git diff --quiet --exit-code; then
        gum style --foreground 212 "⚠️  Warning: You have uncommitted changes. They will not be included in the PR context."
    fi

    local merge_base
    merge_base=$(git merge-base "$main_branch" HEAD)

    generate_report_header \
        "$output_file" \
        "$prompt_file" \
        "Generate Pull Request Description" \
        "You are an expert software engineer writing a clear and comprehensive description for a pull request. Analyze the following git commit history and aggregated diff for the entire feature branch against the '$main_branch' branch. Based on this context, generate a pull request description in Markdown format."

    {
        echo ""
        echo "## Commit History on This Branch"
        echo "\`\`\`"
        git log --pretty=format:'%h %s (%an, %cr)' "$merge_base"..HEAD
        echo "\`\`\`"
    } >> "$output_file"

    {
        echo ""
        echo "---"
        echo "## Full Diff for Branch (vs. $main_branch)"
        echo "\`\`\`diff"
        git diff "$merge_base"..HEAD
        echo "\`\`\`"
    } >> "$output_file"

    echo "✅ Pull Request context report saved to '$output_file'."
}

# --- ACTION: Generate context for local code review/verification ---
# WHAT: Creates a comprehensive report of all changes on the current branch,
#       including both committed changes against 'main' and any uncommitted work.
# WHY:  This file is used to provide an AI with a full snapshot of the branch's
#       state for verification, review, or analysis tasks.
generate_review_context() {
    local output_file="$GIT_ROOT/context_review.md"
    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/review-changes.md"
    local main_branch="main"
    local current_branch
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    echo "--> Generating comprehensive review context..."

    generate_report_header \
        "$output_file" \
        "$prompt_file" \
        "Verification of Changes" \
        "You are an expert AI pair programmer acting as a code reviewer. Carefully analyze the following git status and aggregated diff. Verify that the changes accurately reflect the instructions I just gave you. Confirm if the implementation is correct or point out any discrepancies."

    {
        echo "# Verification Report"
        echo ""
        echo "**Branch:** \`$current_branch\`"
        echo "**Generated:** $(date -u)"
        echo "---"
        echo ""
        echo "## 1. Uncommitted Local Changes"
        echo "\`\`\`"
        if [[ -z $(git status --porcelain) ]]; then
            echo "No uncommitted local changes."
        else
            git status
        fi
        echo "\`\`\`"
        echo ""
        echo "---"
        echo "## 2. Aggregated Diff of All Changes vs \`$main_branch\`"
        echo "\`\`\`diff"
        
        local merge_base
        merge_base=$(git merge-base "$main_branch" HEAD)
        
        git diff "$merge_base"..HEAD
        git diff HEAD
        
        echo "\`\`\`"
    } >> "$output_file"

    echo "✅ Review context report generated. Saved to '$output_file'."
}

# --- ACTION: Export the entire project ---
# WHAT: Exports a comprehensive snapshot of the entire project, organized by
#       the "Product, Library, Factory" architectural model.
# WHY:  Provides a complete, structured context file for high-level AI analysis,
#       onboarding, or architectural review.
export_all_project() {
    local output_file="$GIT_ROOT/contextvibes_export_project.md"
    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/export-project-context.md"

    echo "--> Generating full project export..."

    generate_report_header \
        "$output_file" \
        "$prompt_file" \
        "Full Project Context Analysis" \
        "You are an expert AI systems architect. Your task is to analyze the following comprehensive project export to build a complete mental model of the repository's architecture, purpose, and implementation."

    export_book "$output_file" "The Product (Core THEA Guidance)" "thea/"
    export_book "$output_file" "The Factory (Automation Framework)" "Taskfile.yml" ".github/" "factory/" ".idx/" ".vscode/"
    export_book "$output_file" "The Library (Project Documentation)" "README.md" "CHANGELOG.md" "LICENSE" "CONTRIBUTING.md" "docs/"

    echo "✅ Full project export complete. Report saved to '$output_file'."
}

# --- ACTION: Export only the application code ---
# WHAT: Exports only the files that constitute the core "Product" of the
#       repository (the contents of the 'thea/' directory).
# WHY:  Creates a focused context file for tasks related specifically to
#       analyzing or refactoring the main application code.
export_code_only() {
    local output_file="$GIT_ROOT/context_export_code.md"
    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/export-code-context.md"
    
    echo "--> Exporting application code only..."

    generate_report_header \
      "$output_file" \
      "$prompt_file" \
      "Application Code Analysis" \
      "You are an expert Go developer. Analyze the following application code."

    export_book "$output_file" "The Product (Core THEA Guidance)" "thea/"

    echo "✅ Code export complete. Report saved to '$output_file'."
}

# --- ACTION: Export only the documentation ---
# WHAT: Exports only the files that constitute the "Library" of the project,
#       including root documentation and the contents of the 'docs/' directory.
# WHY:  Creates a focused context file for tasks related to understanding
#       or updating the project's processes and documentation.
export_docs_only() {
    local output_file="$GIT_ROOT/context_export_docs.md"
    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/export-docs-context.md"
    
    echo "--> Exporting documentation only..."

    generate_report_header \
      "$output_file" \
      "$prompt_file" \
      "Documentation & Guidance Analysis" \
      "You are a documentation architect. Analyze the following project documentation."

    export_book "$output_file" "The Library (Project Documentation)" "README.md" "CHANGELOG.md" "LICENSE" "CONTRIBUTING.md" "docs/"

    echo "✅ Documentation export complete. Report saved to '$output_file'."
}

# --- ACTION: Export only the automation framework ---
# WHAT: Exports only the files that constitute the "Factory" of the project,
#       including Taskfiles, scripts, and environment configurations.
# WHY:  Creates a focused context file for tasks related to analyzing or
#       improving the project's automation and CI/CD framework.
export_automation_only() {
    local output_file="$GIT_ROOT/context_export_automation.md"
    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/export-automation-context.md"
    
    echo "--> Exporting automation framework only..."
    
    generate_report_header \
      "$output_file" \
      "$prompt_file" \
      "Automation Framework Analysis" \
      "You are a lead automation engineer. Analyze the following automation framework."

    export_book "$output_file" "The Factory (Automation Framework)" "Taskfile.yml" ".github/" "factory/" ".idx/" ".vscode/"

    echo "✅ Automation export complete. Report saved to '$output_file'."
}


# ==============================================================================
# MAIN CONTROLLER
# ==============================================================================
# WHAT: Displays an interactive menu using 'gum' for the user to select which
#       context generation action to perform.
# WHY:  Provides a user-friendly, discoverable interface for the script's
#       various capabilities when run without arguments.
show_menu() {
    gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "CONTEXT GENERATOR"
    echo "Please select the type of context you want to generate:"

    local CHOICE
    CHOICE=$(gum choose \
        "For a Commit Message" \
        "For a Pull Request Description" \
        "For a Local Code Review" \
        "Export: Full Project (All)" \
        "Export: Code Only" \
        "Export: Documentation Only" \
        "Export: Automation Only" \
        "Quit")

    case "$CHOICE" in
        "For a Commit Message")         generate_commit_context ;;
        "For a Pull Request Description") generate_pr_context ;;
        "For a Local Code Review")      generate_review_context ;;
        "Export: Full Project (All)")   export_all_project ;;
        "Export: Code Only")            export_code_only ;;
        "Export: Documentation Only")     export_docs_only ;;
        "Export: Automation Only")        export_automation_only ;;
        "Quit")                         echo "Aborted."; exit 0 ;;
        *)                              echo "No selection. Aborting."; exit 1 ;;
    esac
}

# --- Main Router ---
# WHAT: Determines which action to run based on the first command-line argument.
#       If no argument is provided, it defaults to showing the interactive menu.
# WHY:  This allows the script to be used both interactively (`task context`)
#       and directly in automated workflows (`task context -- pr`).
readonly MODE="${1:-menu}"

case "$MODE" in
    menu)              show_menu ;;
    commit)            generate_commit_context ;;
    pr)                generate_pr_context ;;
    review)            generate_review_context ;;
    export-all)        export_all_project ;;
    export-code)       export_code_only ;;
    export-docs)       export_docs_only ;;
    export-automation) export_automation_only ;;
    *)
        echo "❌ ERROR: Invalid mode '$MODE' provided." >&2
        echo "   Valid modes are: commit, pr, review, export-all, export-code, export-docs, export-automation" >&2
        exit 1
        ;;
esac
