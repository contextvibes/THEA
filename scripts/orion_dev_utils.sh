#!/bin/bash
#
# scripts/orion_dev_utils.sh - v0.1.5 (Cleaned up)
# Utility script for THEA project development

# --- Configuration & Constants ---
SCRIPT_NAME="$(basename "$0")"
ROOT_DIR="$(pwd)"
DOCS_DIR="${ROOT_DIR}/docs"
# TEAM_PERSONAS_DIR="${DOCS_DIR}/team_personas" # This might be less relevant if stubs are generic

# --- Helper Functions ---
log_info() {
    echo "[INFO] ${SCRIPT_NAME}: $1"
}

log_error() {
    echo "[ERROR] ${SCRIPT_NAME}: $1" >&2
}

# --- CORE HELPER: ensure_file_stub ---
ensure_file_stub() {
    local filepath="$1"
    local title="$2"
    if [ -z "$filepath" ]; then log_error "Internal: ensure_file_stub: File path is required."; return 1; fi
    if [ -z "$title" ]; then title="$(basename "$filepath")"; fi
    local parent_dir="$(dirname "$filepath")"
    if [ ! -d "$parent_dir" ]; then
        log_info "Creating parent directory: $parent_dir"
        mkdir -p "$parent_dir" || { log_error "Failed to create parent directory: $parent_dir"; return 1; }
    fi
    if [ ! -f "$filepath" ]; then
        log_info "Creating file stub: $filepath"
        { echo "# ${title}"; echo ""; echo "*(This is a placeholder for ${title}. Content to be added.)*"; } > "$filepath" || { log_error "Failed to create file stub: $filepath"; return 1; }
    else
        log_info "File already exists: $filepath (Skipping stub creation)"
    fi
    return 0
}

# --- Task Implementations ---

task_create_doc_stub() {
    log_info "Starting task: create_doc_stub"
    local target_file_path="$1" 
    local stub_title="$2"     
    if [ -z "$target_file_path" ]; then log_error "create_doc_stub: Target file path argument is required."; log_info "Usage: ${SCRIPT_NAME} create_doc_stub <file_path> \"<stub_title>\""; return 1; fi
    if [ -z "$stub_title" ]; then log_error "create_doc_stub: Stub title argument is required."; log_info "Usage: ${SCRIPT_NAME} create_doc_stub <file_path> \"<stub_title>\""; return 1; fi
    if ! ensure_file_stub "$target_file_path" "$stub_title"; then return 1; fi
    log_info "Stub creation task for '$target_file_path' handled by ensure_file_stub."
    log_info "If a new file was created, it is NOT automatically staged by this task. Please stage manually."
    return 0
}

task_lint_markdown() {
    log_info "Starting task: lint_markdown"
    local target_path="$1" 

    if ! command -v markdownlint > /dev/null 2>&1; then
        log_error "markdownlint-cli (markdownlint command) not found. Please ensure it's installed via .idx/dev.nix and environment is reloaded."
        return 1
    fi

    local lint_config_file="${ROOT_DIR}/.markdownlint.jsonc" 
    local lint_command_base="markdownlint --config ${lint_config_file}"

    if [ ! -f "$lint_config_file" ]; then
        log_error "Markdown lint configuration file not found: ${lint_config_file}"
        return 1
    fi

    if [ -n "$target_path" ]; then
        if [ ! -e "$target_path" ]; then
            log_error "Target path for linting does not exist: $target_path"
            return 1
        fi
        log_info "Linting specified target: $target_path"
        if [ -d "$target_path" ]; then
            if ! find "$target_path" -name '*.md' -print0 | xargs -0 -r ${lint_command_base}; then
                 log_error "Markdown linting failed for one or more files in '$target_path'."
                 return 1 
            fi
        else
            if ! ${lint_command_base} "$target_path"; then
                log_error "Markdown linting failed for '$target_path'."
                return 1 
            fi
        fi
    else
        log_info "Linting all Markdown files (*.md) in the repository root and subdirectories..."
        # Exclude .git directory from find
        if ! find . -path ./.git -prune -o -name '*.md' -print0 | xargs -0 -r ${lint_command_base}; then
            log_error "Markdown linting failed for one or more files."
            return 1 
        fi
    fi

    log_info "Markdown linting completed. If no errors were shown above, all files passed."
    return 0 
}


# --- Main Dispatcher ---
main() {
    if [ -z "$1" ]; then
        log_error "No task specified. Usage: ${SCRIPT_NAME} <task_name> [task_args...]"
        echo "Available tasks:"
        echo "  create_doc_stub <file_path> \"<stub_title>\" - Creates a specific document stub"
        echo "  lint_markdown [target_path]                - Lints Markdown files (all if no target)"
        return 1
    fi

    local task_name="$1"
    shift 

    case "$task_name" in
        create_doc_stub)
            task_create_doc_stub "$@"
            ;;
        lint_markdown) 
            task_lint_markdown "$@"
            ;;
        *)
            log_error "Unknown task: $task_name"
            echo "Run '${SCRIPT_NAME}' without arguments to see available tasks."
            return 1
            ;;
    esac

    return $?
}

# Execute main function
main "$@"
