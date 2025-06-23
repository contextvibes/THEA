#!/bin/bash
# scripts/export_codebase.sh

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Script Parameters ---
# The output file path is expected as the first argument.
# Default to 'project_context.md' if no argument is provided.
EXPORT_FILE=${1:-project_context.md}

# A pattern of directories to ignore in the tree view for a cleaner layout.
TREE_IGNORE_PATTERN=".git|.task|bin|node_modules|.venv|__pycache__"

# --- Script Logic ---
echo "--> Exporting project context to ${EXPORT_FILE}..."

# Remove the old file to start fresh.
rm -f "${EXPORT_FILE}"

# Generate the report header.
{
  echo "========================================"
  echo "====      PROJECT CONTEXT REPORT      ===="
  echo "========================================"
  echo
  echo "Generated: $(date)"
  echo
  echo "### Git Status (HEAD)"
  echo "\`\`\`"
  git log -1 --pretty="Branch: %D%nCommit: %H%nAuthor: %aN <%aE>%nDate:   %ad%n%n%s"
  echo "\`\`\`"
  echo
  echo "### Project Structure (Top Levels)"
  echo "Directory layout (up to 3 levels deep):"
  echo "\`\`\`"
  tree -L 3 -a -I "${TREE_IGNORE_PATTERN}"
  echo "\`\`\`"
  echo
} >> "${EXPORT_FILE}"

# Append the content of all relevant project files.
git ls-files | grep -vE '\.(png|jpg|jpeg|gif|zip|gz|so|bin|exe|pdf|pyc)$' \
             | grep -vE '(\.env|\.p12|sa-key\.json|crash\..*\.log)' \
             | grep -v "${EXPORT_FILE}" \
             | while read -r file; do
  echo "======== FILE: ${file} ========" >> "${EXPORT_FILE}"
  cat "${file}" >> "${EXPORT_FILE}"
  echo "" >> "${EXPORT_FILE}"
  echo "======== END FILE: ${file} ========" >> "${EXPORT_FILE}"
  echo "" >> "${EXPORT_FILE}"
done

echo "--> Export complete."