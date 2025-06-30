# AI Prompt: Generate Conventional Commit Command

## Your Role & Task
You are an expert software engineer channeling the **`Canon`** persona, the guardian of project standards. Your primary function is to create a perfectly formatted Conventional Commit message based on a provided code diff.

Your goal is to analyze the following On branch feature/factory-pattern
Your branch is up to date with 'origin/feature/factory-pattern'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	deleted:    factory/Taskfile.yml
	modified:   factory/scripts/_automation_helpers.sh
	new file:   factory/scripts/analyze.sh
	new file:   factory/scripts/build.sh
	modified:   factory/scripts/clean.sh
	modified:   factory/scripts/commit.sh
	modified:   factory/scripts/context.sh
	new file:   factory/scripts/context_helpers/context_commit.sh
	new file:   factory/scripts/context_helpers/context_pr.sh
	new file:   factory/scripts/context_helpers/export_all.sh
	new file:   factory/scripts/context_helpers/export_automation.sh
	new file:   factory/scripts/context_helpers/export_code.sh
	new file:   factory/scripts/context_helpers/export_docs.sh
	new file:   factory/scripts/context_helpers/review_changes.sh
	new file:   factory/scripts/deps_update.sh
	new file:   factory/scripts/task_finish.sh
	new file:   factory/scripts/task_start.sh
	new file:   factory/scripts/test.sh
	renamed:    factory/scripts/README.md -> factory/scripts_old/README.md
	new file:   factory/scripts_old/_automation_helpers.sh
	new file:   factory/scripts_old/clean.sh
	new file:   factory/scripts_old/commit.sh
	new file:   factory/scripts_old/context.sh
	renamed:    factory/scripts/context_commit.sh -> factory/scripts_old/context_commit.sh
	renamed:    factory/scripts/context_export.sh -> factory/scripts_old/context_export.sh
	renamed:    factory/scripts/context_export_all.sh -> factory/scripts_old/context_export_all.sh
	renamed:    factory/scripts/context_export_automation.sh -> factory/scripts_old/context_export_automation.sh
	renamed:    factory/scripts/context_export_code.sh -> factory/scripts_old/context_export_code.sh
	renamed:    factory/scripts/context_export_docs.sh -> factory/scripts_old/context_export_docs.sh
	renamed:    factory/scripts/context_pr.sh -> factory/scripts_old/context_pr.sh
	renamed:    factory/scripts/context_verify.sh -> factory/scripts_old/context_verify.sh
	renamed:    factory/scripts/finish_task.sh -> factory/scripts_old/finish_task.sh
	renamed:    factory/scripts/generate_playbook_menu.sh -> factory/scripts_old/generate_playbook_menu.sh
	renamed:    factory/scripts/generate_prompt_menu.sh -> factory/scripts_old/generate_prompt_menu.sh
	renamed:    factory/scripts/start_task.sh -> factory/scripts_old/start_task.sh
	deleted:    factory/tasks/README.md
	modified:   factory/tasks/_analyze.yml
	modified:   factory/tasks/_build.yml
	modified:   factory/tasks/_clean.yml
	modified:   factory/tasks/_commit.yml
	modified:   factory/tasks/_context.yml
	modified:   factory/tasks/_deploy.yml
	new file:   factory/tasks/_deps_update.yml
	modified:   factory/tasks/_destroy.yml
	deleted:    factory/tasks/_init.yml
	modified:   factory/tasks/_provision.yml
	modified:   factory/tasks/_release.yml
	modified:   factory/tasks/_run.yml
	modified:   factory/tasks/_task-finish.yml
	modified:   factory/tasks/_task-start.yml
	modified:   factory/tasks/_test.yml
	deleted:    factory/tasks/_update.yml
	modified:   factory/tasks/_verify.yml

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   .idx/dev.nix
	modified:   Taskfile.yml
	modified:   factory/scripts/_automation_helpers.sh
	modified:   factory/scripts/context.sh
	modified:   factory/scripts/context_helpers/export_all.sh

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	.idx/contextvibes.nix
	context_export_all.md and diff --git a/.idx/dev.nix b/.idx/dev.nix
index 0d908ea..2762cec 100644
--- a/.idx/dev.nix
+++ b/.idx/dev.nix
@@ -1,118 +1,85 @@
+# This file defines the development environment for a Firebase Studio workspace using Nix.
+# It specifies all the packages, services, and editor extensions needed for the project.
 { pkgs, ... }:
+
+let
+  # Imports the custom Nix derivation for the 'contextvibes' tool from a separate file.
+  # This declarative approach makes the tool a first-class package in the environment,
+  # which is more reproducible and cacheable than installing it with an imperative script.
+  contextvibes = import ./contextvibes.nix { pkgs = pkgs; };
+in
 {
-  # Specifies the Nixpkgs channel to ensure a reproducible package set across machines.
+  # Specifies the Nixpkgs channel to use. Pinning to a specific channel like "stable-25.05"
+  # ensures that everyone on the team gets the exact same package versions, leading to a
+  # highly reproducible environment.
   channel = "stable-25.05";
 
   # Defines the packages to be installed in the development environment.
+  # Packages are grouped by function for better readability.
   packages = with pkgs; [
-    # --- Core Dependency for Tooling ---
-    # The Go toolchain is required to build and install Go-based CLI tools,
-    # such as the 'contextvibes' CLI installed in the onCreate hook below.
-    go
-
-    # --- Project Automation ---
-    # A task runner that uses a 'Taskfile.yml' to automate common project commands.
-    go-task
-
-    # --- Code Quality & Linting ---
-    nodejs # The JavaScript runtime, required by markdownlint-cli.
-    nodePackages.markdownlint-cli # A linter to enforce standards in Markdown files.
-
-    # --- Essential Utilities ---
+    # --- Core Language Toolchains ---
+    go # The Go compiler and toolchain.
+    gopls # The official Go language server for IDE features.
+    delve # The standard debugger for Go.
+    nodejs # The JavaScript runtime, required for some linters.
+
+    # --- Project Automation & Task Running ---
+    go-task # A task runner that uses 'Taskfile.yml' to automate common commands.
+
+    # --- Code Quality & Formatting ---
+    shellcheck # Linter for finding bugs in shell scripts.
+    shfmt # Auto-formatter for shell scripts.
+    nodePackages.markdownlint-cli # Linter to enforce standards in Markdown files.
+
+    # --- Data Processing & CLI Tools ---
+    jq # A command-line JSON processor.
+    yq-go # A portable command-line YAML processor (Go version).
+    gum # A tool for creating glamorous shell scripts and interactive menus.
+
+    # --- Version Control & Essential Utilities ---
     git # The version control system for managing source code.
-    gh # The official GitHub CLI for interacting with GitHub from the terminal.
-    tree # A utility to display directory structures.
-    file # For inspecting file types (fixes the immediate error)
-    shellcheck # To find bugs and errors in shell scripts
-    shfmt # To automatically format shell scripts
-
-    # --- Interactive UI/Menus ---
-    gum # For creating beautiful, modern interactive menus and prompts
+    gh # The official GitHub CLI for interacting with GitHub.
+    tree # A utility to display directory structures as a tree.
+    file # A utility to determine file types.
 
-    # --- Data Processing  ---
-    jq # The standard tool for parsing and handling JSON
-    yq # The standa
+    # --- Custom Project Tools ---
+    contextvibes # The custom-built 'contextvibes' CLI tool, managed by its own Nix file.
   ];
 
-  # Sets global environment variables for the Nix shell. This is empty for now.
+  # Sets global environment variables for the Nix shell.
   env = { };
 
   # Configures the IDX workspace environment.
   idx = {
-    # Specifies VS Code extensions to install automatically for a better IDE experience.
+    # Specifies VS Code extensions to install automatically.
+    # This ensures a consistent and fully-featured editor experience for all developers.
     extensions = [
-      # Provides syntax highlighting and management features for Dockerfiles.
-      "ms-azuretools.vscode-docker"
+      # --- Core Language & Framework Support ---
+      "golang.go" # Official Go language support.
+      "task.vscode-task" # Adds support for Go Task ('Taskfile.yml').
 
-      # Integrates GitHub pull requests and issues directly into the editor.
-      "GitHub.vscode-pull-request-github"
+      # --- Code Quality & Linting ---
+      "DavidAnson.vscode-markdownlint" # Integrates markdownlint into the editor.
+      "timonwong.shellcheck" # Integrates shellcheck for live linting of shell scripts.
 
-      # Lints Markdown files to ensure consistent formatting.
-      "DavidAnson.vscode-markdownlint"
+      # --- Version Control ---
+      "GitHub.vscode-pull-request-github" # Integrates GitHub PRs and issues.
+      "eamodio.gitlens" # Supercharges the Git capabilities built into VS Code.
     ];
-
-    # Defines lifecycle hooks that run at different stages of the workspace's life.
-    workspace = {
-      # Runs only ONCE when the workspace is first created to handle initial setup.
-      onCreate = {
-        installContextVibesCli = ''
-          # This script installs a project-specific tool not available in Nixpkgs.
-          echo ">>> Setting up ContextVibes CLI..."
-          LOCAL_BIN_DIR="$(pwd)/bin"
-          mkdir -p "$LOCAL_BIN_DIR"
-          
-          # Use GOBIN to direct 'go install' to the local ./bin directory.
-          export GOBIN="$LOCAL_BIN_DIR"
-          echo "Installing contextvibes@v0.2.0 into $GOBIN..."
-          
-          # Install a specific, known-good version for reproducibility.
-          if go install github.com/contextvibes/cli/cmd/contextvibes@v0.2.0; then
-            echo "✅ Successfully installed contextvibes to $GOBIN/contextvibes"
-            chmod +x "$GOBIN/contextvibes"
-          else
-            # Provide a clear, actionable error message on failure.
-            echo "❌ ERROR: Failed to install contextvibes. Check Go environment and network."
-            exit 1 # Halt further onCreate scripts on failure.
-          fi
-          
-          unset GOBIN
-        '';
-      };
-
-      # Runs EVERY TIME the workspace is started to validate the environment.
-      onStart = {
-        checkContextVibes = ''
-          # This script validates that the ContextVibes CLI is installed and executable.
-          echo ">>> Verifying ContextVibes CLI installation..."
-          EXE_PATH="$(pwd)/bin/contextvibes"
-
-          # Verify that the executable file exists.
-          if [ ! -f "$EXE_PATH" ]; then
-            echo "⚠️ ContextVibes CLI not found at $EXE_PATH. Run the 'onCreate' hook if this is a new workspace."
-            exit 1
-          fi
-
-          # Verify that the file has execute permissions.
-          if [ ! -x "$EXE_PATH" ]; then
-            echo "❌ ERROR: Found contextvibes at $EXE_PATH, but it is not executable. Attempting to fix..."
-            chmod +x "$EXE_PATH" || exit 1
-          fi
-
-          # Verify that the tool is functional by running its version command.
-          if VERSION_OUTPUT=$("$EXE_PATH" version); then
-            echo "✅ ContextVibes CLI is ready. Version: $VERSION_OUTPUT"
-          else
-            echo "❌ ERROR: ContextVibes CLI is present but the 'version' command failed."
-            exit 1
-          fi
-        '';
-      };
-    };
-
-    # Configures web previews for the workspace.
-    previews = {
-      # Previews are disabled as this is primarily a CLI-focused environment.
-      enable = false;
-    };
   };
+
+  # Note on Lifecycle Hooks (`onCreate`, `onStart`):
+  # This configuration intentionally omits lifecycle hooks for package installation,
+  # preferring the declarative `packages` list. This Nix-native approach ensures
+  # reproducibility and leverages caching for faster workspace startups.
+  #
+  # Hooks can still be useful for one-time actions, like initializing a project or
+  # displaying a welcome message. For example:
+  #
+  # idx.workspace.onCreate = [
+  #   ''
+  #     echo "Welcome to the project! Your tools are ready." | gum format -t "code"
+  #     echo "Run 'task --list' to see available commands." | gum format -t "code"
+  #   ''
+  # ];
 }
diff --git a/Taskfile.yml b/Taskfile.yml
index e562e7b..168c411 100644
--- a/Taskfile.yml
+++ b/Taskfile.yml
@@ -1,103 +1,191 @@
-# /.Taskfile.yml
+# Taskfile.yml
 #
-# WHAT: This is the public API for the project's automation framework. It is a
-#       transparent facade that proxies all commands to the real implementation
-#       located in the ./factory directory.
-# WHY:  This provides a single, self-documenting entry point for all developers,
-#       fulfilling our "Taskfile as the Public API" principle.
+# WHAT: This file is the single, user-facing entry point for all project automation.
+# WHY:  It provides a simple, high-level command menu that is easy for developers
+#       to use and understand, hiding the complexity of the underlying scripts and tools.
+#       This approach, called "Menu / Workflow / Action", is designed to reduce cognitive load.
 
 version: '3'
 
-# The dotenv declaration MUST live in this top-level file.
+# ==============================================================================
+#  INCLUDED TASK FILES
+# ==============================================================================
+# WHAT: This block includes all the helper Taskfiles from the ./factory/tasks/ directory.
+# WHY:  Including these files allows this main Taskfile to act as a clean menu,
+#       delegating the actual implementation logic to the included files. This
+#       keeps the project's automation organized and maintainable.
+# ==============================================================================
+includes:
+  # --- Local Development (Inner Loop) ---
+  _task-start:      ./factory/tasks/_task-start.yml
+  _context:         ./factory/tasks/_context.yml
+  _run:             ./factory/tasks/_run.yml
+  _commit:          ./factory/tasks/_commit.yml
+  _task-finish:     ./factory/tasks/_task-finish.yml
+
+  # --- Build & Release Pipeline (Outer Loop) ---
+  _build:           ./factory/tasks/_build.yml
+  _test:            ./factory/tasks/_test.yml
+  _analyze:         ./factory/tasks/_analyze.yml
+  _release:         ./factory/tasks/_release.yml
+  _deploy:          ./factory/tasks/_deploy.yml
+
+  # --- Infrastructure & Utilities ---
+  _provision:       ./factory/tasks/_provision.yml
+  _verify:          ./factory/tasks/_verify.yml
+  _destroy:         ./factory/tasks/_destroy.yml
+  _deps_update:     ./factory/tasks/_deps_update.yml
+  _clean:           ./factory/tasks/_clean.yml
+
+# WHAT: This directive automatically loads environment variables from the .env file.
+# WHY:  This makes project-specific variables (like GCP_PROJECT_ID) available
+#       to all tasks and their underlying scripts without manual sourcing.
 dotenv: [".env"]
 
 tasks:
-  # The default task explicitly calls the 'default' task from the factory's
-  # Taskfile, ensuring the formatted menu is always displayed.
+  # WHAT: This is the default task that runs when 'task' is called without arguments.
+  # WHY:  Its purpose is to display a well-formatted, user-friendly help menu
+  #       that describes all available high-level commands.
   default:
     desc: "Displays the main project command menu."
     silent: true
     cmds:
-      - task --dir ./factory default
-
-  # ---------------------------------------------------------------------------
-  # PROXY TASKS (The Public API)
-  # Each task below is a simple proxy that calls the real task inside the
-  # factory. The description is copied for discoverability (`task --list`),
-  # and {{.CLI_ARGS}} ensures all arguments are passed through.
-  # ---------------------------------------------------------------------------
-
+      - |
+        echo
+        echo "----------------------------------------------------------------------------"
+        echo "          ✨ THEA Command Menu (Cognitively-Refined) ✨"
+        echo "----------------------------------------------------------------------------"
+        echo "Run \`task <command>\` to execute an action. e.g., \`task test\`"
+        echo
+        echo -e "\033[1m--- 💻 Local Development (Inner Loop) ---\033[0m"
+        echo "    Tasks for the core cycle of coding and local iteration."
+        echo
+        echo -e "  \033[32mtask-start\033[0m   - ACTION:   Initiate a new task (e.g., \`git checkout -b new-feature\`)."
+        echo -e "  \033[32mcontext\033[0m      - VIEW:     Generate context for a specific goal (commit, pr, verify, export-*)."
+        echo -e "  \033[32mrun\033[0m          - ACTION:   Execute the application locally on your machine."
+        echo -e "  \033[32mcommit\033[0m       - ACTION:   Save all local changes into a new commit (e.g., \`git commit\`)."
+        echo -e "  \033[32mtask-finish\033[0m  - ACTION:   Finalize a task (e.g., create a pull request)."
+        echo
+        echo -e "\033[1m--- 📦 Build & Release Pipeline (Outer Loop) ---\033[0m"
+        echo "    Tasks for building, testing, and deploying the application."
+        echo
+        echo -e "  \033[32mbuild\033[0m        - ACTION:   Compile source code and create a build artifact."
+        echo -e "  \033[32mtest\033[0m         - ACTION:   Run the application's full suite of automated tests."
+        echo -e "  \033[32manalyze\033[0m      - ACTION:   Inspect code for quality, style, and vulnerabilities."
+        echo -e "  \033[32mrelease\033[0m      - ACTION:   Create and publish a new versioned release artifact."
+        echo -e "  \033[32mdeploy\033[0m       - ACTION:   Deploys the application to the cloud."
+        echo
+        echo -e "\033[1m--- ☁️ Infrastructure & Utilities ---\033[0m"
+        echo "    Tasks for managing cloud resources and local housekeeping."
+        echo
+        echo -e "  \033[32mprovision\033[0m    - GUIDE:    Shows setup checklist for cloud infrastructure."
+        echo -e "  \033[32mverify\033[0m       - VIEW:     Check that provisioned infrastructure is healthy."
+        echo -e "  \033[31mdestroy\033[0m      - ACTION:   Shows checklist for tearing down all infrastructure."
+        echo -e "  \033[32mdeps-update\033[0m  - ACTION:   Update third-party dependencies to their latest versions."
+        echo -e "  \033[32mclean\033[0m        - ACTION:   Remove all local temporary files and build artifacts."
+        echo
+
+  # ============================================================================
+  #  FACADE TASKS
+  # ============================================================================
+  # WHAT: Each task below is a simple "facade" that delegates its execution
+  #       to a corresponding task in an included file from the `tasks/` directory.
+  #
+  # WHY:  This pattern keeps the root Taskfile clean and readable, like a high-level
+  #       API menu. It abstracts away the implementation details and enforces a
+  #       consistent structure across the entire project.
+  #
+  # HOW:  The `vars: { CLI_ARGS: '{{.CLI_ARGS}}' }` block is used universally.
+  #       It captures any arguments passed after a '--' on the command line
+  #       (e.g., `task commit -- -m "msg"`) and forwards them to the
+  #       underlying script, enabling both interactive and parameterized use.
+  # ============================================================================
   task-start:
     desc: "ACTION: Initiate a new task (e.g., git checkout -b new-feature)."
     cmds:
-      - task --dir ./factory task-start -- {{.CLI_ARGS}}
+      - task: _task-start:task-start
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   context:
-    desc: "VIEW: Generate context for a specific goal (commit, pr, verify, export-*)."
+    desc: "VIEW: Generate context for a specific goal (commit, pr, review, export-*)."
     cmds:
-      - task --dir ./factory context -- {{.CLI_ARGS}}
+      - task: _context:context
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   run:
     desc: "ACTION: Execute the application locally on your machine."
     cmds:
-      - task --dir ./factory run -- {{.CLI_ARGS}}
+      - task: _run:run
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   commit:
     desc: "ACTION: Save all local changes into a new commit (e.g., git commit)."
     cmds:
-      - task --dir ./factory commit -- {{.CLI_ARGS}}
+      - task: _commit:commit
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   task-finish:
     desc: "ACTION: Finalize a task (e.g., create a pull request)."
     cmds:
-      - task --dir ./factory task-finish -- {{.CLI_ARGS}}
+      - task: _task-finish:task-finish
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   build:
     desc: "ACTION: Compile source code and create a build artifact."
     cmds:
-      - task --dir ./factory build -- {{.CLI_ARGS}}
+      - task: _build:build
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   test:
     desc: "ACTION: Run the application's full suite of automated tests."
     cmds:
-      - task --dir ./factory test -- {{.CLI_ARGS}}
+      - task: _test:test
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   analyze:
     desc: "ACTION: Inspect code for quality, style, and vulnerabilities."
     cmds:
-      - task --dir ./factory analyze -- {{.CLI_ARGS}}
+      - task: _analyze:analyze
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   release:
     desc: "ACTION: Create and publish a new versioned release artifact."
     cmds:
-      - task --dir ./factory release -- {{.CLI_ARGS}}
+      - task: _release:release
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   deploy:
     desc: "ACTION: Deploys the application to the cloud."
     cmds:
-      - task --dir ./factory deploy -- {{.CLI_ARGS}}
+      - task: _deploy:deploy
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   provision:
     desc: "GUIDE: Shows setup checklist for cloud infrastructure."
     cmds:
-      - task --dir ./factory provision -- {{.CLI_ARGS}}
+      - task: _provision:provision
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   verify:
     desc: "VIEW: Check that provisioned infrastructure is healthy."
     cmds:
-      - task --dir ./factory verify -- {{.CLI_ARGS}}
+      - task: _verify:verify
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   destroy:
-    desc: "ACTION: Shows checklist for tearing down all infrastructure."
+    desc: "ACTION: Permanently destroys ALL cloud infrastructure (requires confirmation)."
     cmds:
-      - task --dir ./factory destroy -- {{.CLI_ARGS}}
+      - task: _destroy:destroy
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   deps-update:
     desc: "ACTION: Update third-party dependencies to their latest versions."
     cmds:
-      - task --dir ./factory deps-update -- {{.CLI_ARGS}}
+      - task: _deps_update:deps-update
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   clean:
     desc: "ACTION: Remove all local temporary files and build artifacts."
     cmds:
-      - task --dir ./factory clean -- {{.CLI_ARGS}}
+      - task: _clean:clean
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
diff --git a/factory/scripts/_automation_helpers.sh b/factory/scripts/_automation_helpers.sh
index ef04dc6..66c9626 100644
--- a/factory/scripts/_automation_helpers.sh
+++ b/factory/scripts/_automation_helpers.sh
@@ -1,59 +1,47 @@
 #!/bin/bash
-# Filename: factory/scripts/_automation_helpers.sh
-
-# --- DEBUG: Confirm this file was sourced successfully ---
-echo "[DEBUG] Helper file '_automation_helpers.sh' was successfully sourced."
-
 readonly PROMPTS_DIR="factory/prompts"
 
 is_text_file() {
   local file_path="$1"
-  local mime_type
-  local result=1 # Default to "not text" (fail)
-
-  echo "[DEBUG] --- Inside is_text_file ---"
-  echo "[DEBUG] Checking file: '$file_path'"
-
   if [ ! -f "$file_path" ]; then
-    echo "[DEBUG] Result: Failure. Path is not a regular file."
-    echo "[DEBUG] --------------------------"
     return 1
   fi
-
+  local mime_type
   mime_type=$(file --brief --mime-type "$file_path")
-  echo "[DEBUG] Detected MIME Type: '$mime_type'"
-
   case "$mime_type" in
     text/*|application/json|application/javascript|application/x-sh|application/x-shellscript|application/xml|application/x-yaml|application/x-nix|inode/x-empty)
-      echo "[DEBUG] Result: Success. MIME type matched the 'allow' list."
-      result=0 # It's a text file
+      return 0
       ;;
     *)
-      echo "[DEBUG] Result: Failure. MIME type did NOT match the 'allow' list."
-      result=1 # It's not a text file
+      return 1
       ;;
   esac
-
-  echo "[DEBUG] --------------------------"
-  return $result
 }
 
+# In factory/scripts/_automation_helpers.sh
+
+# ... (keep the is_text_file function as is) ...
+
+# Generates the header for a report file.
+# Uses a custom prompt file if it exists, otherwise uses the improved default text.
 generate_report_header() {
   local output_file="$1"
   local prompt_file="$2"
   local default_title="$3"
-  local default_task="$4"
+  local default_task="$4" # This will now be the detailed role/task description
 
+  # If a specific prompt file exists, use it.
   if [ -f "$prompt_file" ]; then
     echo "--> Using custom prompt from: $prompt_file"
     cat "$prompt_file" > "$output_file"
   else
-    echo "--> Using default built-in prompt."
+    # --- THIS IS THE IMPROVED FALLBACK LOGIC ---
+    echo "--> Using improved default built-in prompt."
     local prompt_content
     prompt_content=$(cat <<EOF
-# AI INSTRUCTION: $default_title
+# AI Prompt: $default_title
 
-## Your Task
+## Your Role & Task
 $default_task
 
 ---
diff --git a/factory/scripts/context.sh b/factory/scripts/context.sh
index 3a157de..67f8dd7 100755
--- a/factory/scripts/context.sh
+++ b/factory/scripts/context.sh
@@ -1,66 +1,240 @@
 #!/bin/bash
 # factory/scripts/context.sh
 #
-# WHAT: A master script for context generation. It acts as a router, calling
-#       the correct helper script based on the user's goal.
-# WHY:  Provides a single entry point (`task context`) while keeping all
-#       implementation logic in dedicated, single-responsibility files.
+# WHAT: A master script for context generation. It contains all logic
+#       for generating context for various goals, such as commits, PRs,
+#       and full project exports, consolidated into a single file.
+# WHY:  Provides a single, maintainable entry point (`task context`) without
+#       needing to call external helper scripts.
 
-set -e
+set -euo pipefail
 
-# --- Configuration ---
-# Get the absolute path to the project root. This is the most reliable way.
-GIT_ROOT=$(git rev-parse --show-toplevel)
-# Define the helpers directory relative to the known project root.
-HELPERS_DIR="$GIT_ROOT/factory/scripts/context_helpers"
+# --- Configuration & Setup ---
+readonly GIT_ROOT=$(git rev-parse --show-toplevel)
+# All helper functions are now defined locally in this script.
+# shellcheck source=./_automation_helpers.sh
+source "$(dirname "$0")/_automation_helpers.sh"
 
-# --- The Interactive Menu (using gum) ---
-show_menu() {
-  gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "CONTEXT GENERATOR"
-  echo "Please select the type of context you want to generate:"
-
-  CHOICE=$(gum choose \
-    "For a Commit Message" \
-    "For a Pull Request Description" \
-    "For a Local Code Review" \
-    "Export: Full Project (All)" \
-    "Export: Code Only" \
-    "Export: Documentation Only" \
-    "Export: Automation Only" \
-    "Quit")
-
-  case "$CHOICE" in
-    "For a Commit Message")         "$HELPERS_DIR/context_commit.sh" ;;
-    "For a Pull Request Description") "$HELPERS_DIR/context_pr.sh" ;;
-    "For a Local Code Review")      "$HELPERS_DIR/review_changes.sh" ;;
-    "Export: Full Project (All)")   "$HELPERS_DIR/export_all.sh" ;;
-    "Export: Code Only")            "$HELPERS_DIR/export_code.sh" ;;
-    "Export: Documentation Only")     "$HELPERS_DIR/export_docs.sh" ;;
-    "Export: Automation Only")        "$HELPERS_DIR/export_automation.sh" ;;
-    "Quit")                         echo "Aborted."; exit 0 ;;
-    *)                              echo "No selection. Aborting."; exit 1 ;;
-  esac
+# ==============================================================================
+# LOCAL HELPER: CONTEXT GENERATION LOGIC
+# =================================d=============================================
+# WHAT: This local function contains the core logic for exporting files.
+# WHY:  Defining it here avoids repeating code for each export type.
+#
+# Usage: export_book "Output Filename" "Book Title" "path1" "path2" ...
+# ==============================================================================
+export_book() {
+    local output_file="$1"
+    local title="$2"
+    shift 2 # Remove the first two arguments, leaving only the paths
+    local paths=("$@")
+
+    # Append the book header to the main output file.
+    { echo ""; echo "---"; echo "## Book: ${title}"; echo ""; } >> "$output_file"
+
+    # Find all files tracked by git in the given paths.
+    git -C "$GIT_ROOT" ls-files -- "${paths[@]}" | while IFS= read -r file; do
+        [ -z "$file" ] && continue
+        local full_path="$GIT_ROOT/$file"
+
+        # Use the robust is_text_file function from our helper script.
+        if ! is_text_file "$full_path"; then
+            echo "--> Skipping non-text/binary file: $file"
+            continue
+        fi
+
+        # Append the file's content, wrapped in markdown code blocks.
+        {
+            echo ""
+            echo "======== FILE: ${file} ========"
+            echo "\`\`\`${file##*.}"
+            cat "$full_path"
+            echo "\`\`\`"
+            echo "======== END FILE: ${file} ========"
+        } >> "$output_file"
+    done
+}
+
+
+# ==============================================================================
+# CONSOLIDATED ACTIONS
+# All logic from the `context_helpers` directory is now here.
+# ==============================================================================
+
+# --- ACTION: Generate context for a commit message ---
+# In factory/scripts/context.sh
+
+
+# --- ACTION: Generate context for a commit message ---
+generate_commit_context() {
+    local output_file="$GIT_ROOT/context_commit.md"
+    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/generate-commit-message.md"
+    
+    echo "--> Generating context for commit message..."
+    
+    # This now passes a much better, multi-line default prompt text.
+    generate_report_header \
+        "$output_file" \
+        "$prompt_file" \
+        "Generate Conventional Commit Command" \
+        "You are an expert software engineer channeling the **\`Canon\`** persona, the guardian of project standards. Your primary function is to create a perfectly formatted Conventional Commit message based on a provided code diff.
+
+Your goal is to analyze the following `git status` and `git diff` output and generate a single, complete \`task commit\` command that is ready to be executed in the terminal."
+
+    {
+        echo ""
+        echo "## Git Status"
+        echo "\`\`\`"
+        git status
+        echo "\`\`\`"
+        echo ""
+        echo "---"
+        echo "## Diff of All Uncommitted Changes"
+        echo "\`\`\`diff"
+        git diff --staged
+        git diff
+        echo "\`\`\`"
+    } >> "$output_file"
+
+    echo "✅ Commit context generated. File: '$output_file'"
+}
+
+# --- ACTION: Generate context for a Pull Request ---
+generate_pr_context() {
+    # (Implementation for PR context would go here)
+    gum style --bold --foreground 212 "Placeholder for 'Pull Request' context generation."
+}
+
+# --- ACTION: Generate context for code review ---
+generate_review_context() {
+    # (Implementation for review context would go here)
+    gum style --bold --foreground 212 "Placeholder for 'Code Review' context generation."
+}
+
+# --- ACTION: Export the entire project ---
+export_all_project() {
+    local output_file="$GIT_ROOT/context_export_all.md"
+    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/export-project-context.md"
+
+    echo "--> Generating full project export..."
+
+    generate_report_header \
+        "$output_file" \
+        "$prompt_file" \
+        "Full Project Context Analysis" \
+        "You are an expert AI systems architect. Your task is to analyze the following comprehensive project export to build a complete mental model of the repository's architecture, purpose, and implementation."
+
+    # Export architectural components
+    export_book "$output_file" "The Product (Core THEA Guidance)" "thea/"
+    export_book "$output_file" "The Factory (Automation Framework)" "Taskfile.yml" ".github/" "factory/" ".idx/" ".vscode/"
+    export_book "$output_file" "The Library (Project Documentation)" "README.md" "CHANGELOG.md" "LICENSE" "CONTRIBUTING.md" "docs/"
+
+    echo "✅ Full project export complete. Report saved to '$output_file'."
+}
+
+# --- ACTION: Export only the application code ---
+export_code_only() {
+    local output_file="$GIT_ROOT/context_export_code.md"
+    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/export-code-context.md"
+    
+    echo "--> Exporting application code only..."
+
+    generate_report_header \
+      "$output_file" \
+      "$prompt_file" \
+      "Application Code Analysis" \
+      "You are an expert Go developer. Analyze the following application code."
+
+    export_book "$output_file" "The Product (Core THEA Guidance)" "thea/"
+
+    echo "✅ Code export complete. Report saved to '$output_file'."
+}
+
+# --- ACTION: Export only the documentation ---
+export_docs_only() {
+    local output_file="$GIT_ROOT/context_export_docs.md"
+    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/export-docs-context.md"
+    
+    echo "--> Exporting documentation only..."
+
+    generate_report_header \
+      "$output_file" \
+      "$prompt_file" \
+      "Documentation & Guidance Analysis" \
+      "You are a documentation architect. Analyze the following project documentation."
+
+    export_book "$output_file" "The Library (Project Documentation)" "README.md" "CHANGELOG.md" "LICENSE" "CONTRIBUTING.md" "docs/"
+
+    echo "✅ Documentation export complete. Report saved to '$output_file'."
+}
+
+# --- ACTION: Export only the automation framework ---
+export_automation_only() {
+    local output_file="$GIT_ROOT/context_export_automation.md"
+    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/export-automation-context.md"
+    
+    echo "--> Exporting automation framework only..."
+    
+    generate_report_header \
+      "$output_file" \
+      "$prompt_file" \
+      "Automation Framework Analysis" \
+      "You are a lead automation engineer. Analyze the following automation framework."
+
+    export_book "$output_file" "The Factory (Automation Framework)" "Taskfile.yml" ".github/" "factory/" ".idx/" ".vscode/"
+
+    echo "✅ Automation export complete. Report saved to '$output_file'."
 }
 
-# --- Main Controller Logic ---
-MODE=$1
 
-if [ -z "$MODE" ]; then
-  show_menu
-  exit 0
-fi
+# ==============================================================================
+# Main Controller Logic
+# ==============================================================================
+show_menu() {
+    gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "CONTEXT GENERATOR"
+    echo "Please select the type of context you want to generate:"
+
+    # The menu now calls the local functions defined above
+    local CHOICE
+    CHOICE=$(gum choose \
+        "For a Commit Message" \
+        "For a Pull Request Description" \
+        "For a Local Code Review" \
+        "Export: Full Project (All)" \
+        "Export: Code Only" \
+        "Export: Documentation Only" \
+        "Export: Automation Only" \
+        "Quit")
+
+    case "$CHOICE" in
+        "For a Commit Message")         generate_commit_context ;;
+        "For a Pull Request Description") generate_pr_context ;;
+        "For a Local Code Review")      generate_review_context ;;
+        "Export: Full Project (All)")   export_all_project ;;
+        "Export: Code Only")            export_code_only ;;
+        "Export: Documentation Only")     export_docs_only ;;
+        "Export: Automation Only")        export_automation_only ;;
+        "Quit")                         echo "Aborted."; exit 0 ;;
+        *)                              echo "No selection. Aborting."; exit 1 ;;
+    esac
+}
+
+# --- Router ---
+# The first argument passed to the script determines the mode.
+readonly MODE="${1:-menu}" # Default to 'menu' if no argument is provided.
 
 case "$MODE" in
-  commit)            "$HELPERS_DIR/context_commit.sh" ;;
-  pr)                "$HELPERS_DIR/context_pr.sh" ;;
-  review)            "$HELPERS_DIR/review_changes.sh" ;;
-  export-all)        "$HELPERS_DIR/export_all.sh" ;;
-  export-code)       "$HELPERS_DIR/export_code.sh" ;;
-  export-docs)       "$HELPERS_DIR/export_docs.sh" ;;
-  export-automation) "$HELPERS_DIR/export_automation.sh" ;;
-  *)
-    echo "❌ ERROR: Invalid mode '$MODE' provided." >&2
-    echo "   Valid modes are: commit, pr, review, export-all, export-code, export-docs, export-automation" >&2
-    exit 1
-    ;;
-esac
\ No newline at end of file
+    menu)              show_menu ;;
+    commit)            generate_commit_context ;;
+    pr)                generate_pr_context ;;
+    review)            generate_review_context ;;
+    export-all)        export_all_project ;;
+    export-code)       export_code_only ;;
+    export-docs)       export_docs_only ;;
+    export-automation) export_automation_only ;;
+    *)
+        echo "❌ ERROR: Invalid mode '$MODE' provided." >&2
+        echo "   Valid modes are: commit, pr, review, export-all, export-code, export-docs, export-automation" >&2
+        exit 1
+        ;;
+esac
diff --git a/factory/scripts/context_helpers/export_all.sh b/factory/scripts/context_helpers/export_all.sh
index 5269167..c5e4f7c 100755
--- a/factory/scripts/context_helpers/export_all.sh
+++ b/factory/scripts/context_helpers/export_all.sh
@@ -1,43 +1,48 @@
 #!/bin/bash
-readonly PROMPTS_DIR="factory/prompts"
-
-is_text_file() {
-  local file_path="$1"
-  if [ ! -f "$file_path" ]; then
-    return 1
-  fi
-  local mime_type
-  mime_type=$(file --brief --mime-type "$file_path")
-  case "$mime_type" in
-    text/*|application/json|application/javascript|application/x-sh|application/x-shellscript|application/xml|application/x-yaml|application/x-nix|inode/x-empty)
-      return 0
-      ;;
-    *)
-      return 1
-      ;;
-  esac
-}
+set -euo pipefail
+# shellcheck source=../_automation_helpers.sh
+source "$(dirname "$0")/../_automation_helpers.sh"
+
+readonly GIT_ROOT=$(git rev-parse --show-toplevel)
+readonly OUTPUT_FILE="$GIT_ROOT/contextvibes_export_project.md"
+readonly PROMPT_FILE="$GIT_ROOT/$PROMPTS_DIR/export-project-context.md"
+
+append_book_to_report() {
+  local title="$1"
+  shift
+  local paths=("$@")
+
+  { echo ""; echo "---"; echo "## Book: ${title}"; echo ""; } >> "$OUTPUT_FILE"
 
-generate_report_header() {
-  local output_file="$1"
-  local prompt_file="$2"
-  local default_title="$3"
-  local default_task="$4"
-  if [ -f "$prompt_file" ]; then
-    echo "--> Using custom prompt from: $prompt_file"
-    cat "$prompt_file" > "$output_file"
-  else
-    echo "--> Using default built-in prompt."
-    local prompt_content
-    prompt_content=$(cat <<EOF
-# AI INSTRUCTION: $default_title
-
-## Your Task
-$default_task
-
----
-EOF
-)
-    echo "$prompt_content" > "$output_file"
-  fi
+  git -C "$GIT_ROOT" ls-files -- "${paths[@]}" | while IFS= read -r file; do
+    [ -z "$file" ] && continue
+    local full_path="$GIT_ROOT/$file"
+
+    if ! is_text_file "$full_path"; then
+      echo "--> Skipping non-text/binary file: $file"
+      continue
+    fi
+
+    {
+      echo ""
+      echo "======== FILE: ${file} ========"
+      echo "\`\`\`${file##*.}"
+      cat "$full_path"
+      echo "\`\`\`"
+      echo "======== END FILE: ${file} ========"
+    } >> "$OUTPUT_FILE"
+  done
 }
+
+echo "--> Generating full project export..."
+generate_report_header \
+  "$OUTPUT_FILE" \
+  "$PROMPT_FILE" \
+  "Full Project Context Analysis" \
+  "You are an expert AI systems architect..."
+
+echo "--> Exporting architectural components..."
+append_book_to_report "The Product (Core THEA Guidance)" "thea/"
+append_book_to_report "The Factory (Automation Framework & Environment)" "Taskfile.yml" ".github/" "factory/" ".idx/" ".vscode/"
+append_book_to_report "The Library (Project & Process Documentation)" "README.md" "CHANGELOG.md" "LICENSE" "CONTRIBUTING.md" "docs/"
+echo "✅ Full project export complete. Report saved to '$OUTPUT_FILE'." output and generate a single, complete `task commit` command that is ready to be executed in the terminal.

---

## Git Status
```
On branch feature/factory-pattern
Your branch is up to date with 'origin/feature/factory-pattern'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	deleted:    factory/Taskfile.yml
	modified:   factory/scripts/_automation_helpers.sh
	new file:   factory/scripts/analyze.sh
	new file:   factory/scripts/build.sh
	modified:   factory/scripts/clean.sh
	modified:   factory/scripts/commit.sh
	modified:   factory/scripts/context.sh
	new file:   factory/scripts/context_helpers/context_commit.sh
	new file:   factory/scripts/context_helpers/context_pr.sh
	new file:   factory/scripts/context_helpers/export_all.sh
	new file:   factory/scripts/context_helpers/export_automation.sh
	new file:   factory/scripts/context_helpers/export_code.sh
	new file:   factory/scripts/context_helpers/export_docs.sh
	new file:   factory/scripts/context_helpers/review_changes.sh
	new file:   factory/scripts/deps_update.sh
	new file:   factory/scripts/task_finish.sh
	new file:   factory/scripts/task_start.sh
	new file:   factory/scripts/test.sh
	renamed:    factory/scripts/README.md -> factory/scripts_old/README.md
	new file:   factory/scripts_old/_automation_helpers.sh
	new file:   factory/scripts_old/clean.sh
	new file:   factory/scripts_old/commit.sh
	new file:   factory/scripts_old/context.sh
	renamed:    factory/scripts/context_commit.sh -> factory/scripts_old/context_commit.sh
	renamed:    factory/scripts/context_export.sh -> factory/scripts_old/context_export.sh
	renamed:    factory/scripts/context_export_all.sh -> factory/scripts_old/context_export_all.sh
	renamed:    factory/scripts/context_export_automation.sh -> factory/scripts_old/context_export_automation.sh
	renamed:    factory/scripts/context_export_code.sh -> factory/scripts_old/context_export_code.sh
	renamed:    factory/scripts/context_export_docs.sh -> factory/scripts_old/context_export_docs.sh
	renamed:    factory/scripts/context_pr.sh -> factory/scripts_old/context_pr.sh
	renamed:    factory/scripts/context_verify.sh -> factory/scripts_old/context_verify.sh
	renamed:    factory/scripts/finish_task.sh -> factory/scripts_old/finish_task.sh
	renamed:    factory/scripts/generate_playbook_menu.sh -> factory/scripts_old/generate_playbook_menu.sh
	renamed:    factory/scripts/generate_prompt_menu.sh -> factory/scripts_old/generate_prompt_menu.sh
	renamed:    factory/scripts/start_task.sh -> factory/scripts_old/start_task.sh
	deleted:    factory/tasks/README.md
	modified:   factory/tasks/_analyze.yml
	modified:   factory/tasks/_build.yml
	modified:   factory/tasks/_clean.yml
	modified:   factory/tasks/_commit.yml
	modified:   factory/tasks/_context.yml
	modified:   factory/tasks/_deploy.yml
	new file:   factory/tasks/_deps_update.yml
	modified:   factory/tasks/_destroy.yml
	deleted:    factory/tasks/_init.yml
	modified:   factory/tasks/_provision.yml
	modified:   factory/tasks/_release.yml
	modified:   factory/tasks/_run.yml
	modified:   factory/tasks/_task-finish.yml
	modified:   factory/tasks/_task-start.yml
	modified:   factory/tasks/_test.yml
	deleted:    factory/tasks/_update.yml
	modified:   factory/tasks/_verify.yml

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   .idx/dev.nix
	modified:   Taskfile.yml
	modified:   factory/scripts/_automation_helpers.sh
	modified:   factory/scripts/context.sh
	modified:   factory/scripts/context_helpers/export_all.sh

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	.idx/contextvibes.nix
	context_commit.md
	context_export_all.md

```

---
## Diff of All Uncommitted Changes
```diff
diff --git a/factory/Taskfile.yml b/factory/Taskfile.yml
deleted file mode 100644
index 826a306..0000000
--- a/factory/Taskfile.yml
+++ /dev/null
@@ -1,199 +0,0 @@
-# Taskfile.yml
-#
-# WHAT: This file is the single, user-facing entry point for all project automation.
-# WHY:  It provides a simple, high-level command menu that is easy for developers
-#       to use and understand, hiding the complexity of the underlying scripts and tools.
-#       This approach, called "Menu / Workflow / Action", is designed to reduce cognitive load.
-
-version: '3'
-
-# ==============================================================================
-#  INCLUDED TASK FILES
-# ==============================================================================
-# WHAT: This block includes all the helper Taskfiles from the ./tasks/ directory.
-# WHY:  Including these files allows this main Taskfile to act as a clean menu,
-#       delegating the actual implementation logic to the included files. This
-#       keeps the project's automation organized and maintainable.
-# ==============================================================================
-includes:
-  # --- Local Development (Inner Loop) ---
-  _task-start:      ./tasks/_task-start.yml
-  _context:         ./tasks/_context.yml
-  _run:             ./tasks/_run.yml
-  _commit:          ./tasks/_commit.yml
-  _task-finish:     ./tasks/_task-finish.yml
-
-  # --- Build & Release Pipeline (Outer Loop) ---
-  _build:           ./tasks/_build.yml
-  _test:            ./tasks/_test.yml
-  _analyze:         ./tasks/_analyze.yml
-  _release:         ./tasks/_release.yml
-  _deploy:          ./tasks/_deploy.yml
-
-  # --- Infrastructure & Utilities ---
-  _provision:       ./tasks/_provision.yml
-  _verify:          ./tasks/_verify.yml
-  _destroy:         ./tasks/_destroy.yml
-  _update:          ./tasks/_update.yml
-  _clean:           ./tasks/_clean.yml
-
-  # --- Core Internal Utilities ---
-  _init:            ./tasks/_init.yml
-
-tasks:
-  # WHAT: This is the default task that runs when 'task' is called without arguments.
-  # WHY:  Its purpose is to display a well-formatted, user-friendly help menu
-  #       that describes all available high-level commands.
-  default:
-    desc: "Displays the main project command menu."
-    silent: true
-    cmds:
-      - |
-        echo
-        echo "----------------------------------------------------------------------------"
-        echo "          ✨ THEA Command Menu (Cognitively-Refined) ✨"
-        echo "----------------------------------------------------------------------------"
-        echo "Run \`task <command>\` to execute an action. e.g., \`task test\`"
-        echo
-        echo -e "\033[1m--- 💻 Local Development (Inner Loop) ---\033[0m"
-        echo "    Tasks for the core cycle of coding and local iteration."
-        echo
-        echo -e "  \033[32mtask-start\033[0m   - ACTION:   Initiate a new task (e.g., \`git checkout -b new-feature\`)."
-        echo -e "  \033[32mcontext\033[0m      - VIEW:     Generate context for a specific goal (commit, pr, verify, export-*)."
-        echo -e "  \033[32mrun\033[0m          - ACTION:   Execute the application locally on your machine."
-        echo -e "  \033[32mcommit\033[0m       - ACTION:   Save all local changes into a new commit (e.g., \`git commit\`)."
-        echo -e "  \033[32mtask-finish\033[0m  - ACTION:   Finalize a task (e.g., create a pull request)."
-        echo
-        echo -e "\033[1m--- 📦 Build & Release Pipeline (Outer Loop) ---\033[0m"
-        echo "    Tasks for building, testing, and deploying the application."
-        echo
-        echo -e "  \033[32mbuild\033[0m        - ACTION:   Compile source code and create a build artifact."
-        echo -e "  \033[32mtest\033[0m         - ACTION:   Run the application's full suite of automated tests."
-        echo -e "  \033[32manalyze\033[0m      - ACTION:   Inspect code for quality, style, and vulnerabilities."
-        echo -e "  \033[32mrelease\033[0m      - ACTION:   Create and publish a new versioned release artifact."
-        echo -e "  \033[32mdeploy\033[0m       - ACTION:   Deploys the application to the cloud."
-        echo
-        echo -e "\033[1m--- ☁️ Infrastructure & Utilities ---\033[0m"
-        echo "    Tasks for managing cloud resources and local housekeeping."
-        echo
-        echo -e "  \033[32mprovision\033[0m    - GUIDE:    Shows setup checklist for cloud infrastructure."
-        echo -e "  \033[32mverify\033[0m       - VIEW:     Check that provisioned infrastructure is healthy."
-        echo -e "  \033[31mdestroy\033[0m      - ACTION:   Shows checklist for tearing down all infrastructure."
-        echo -e "  \033[32mdeps-update\033[0m  - ACTION:   Update third-party dependencies to their latest versions."
-        echo -e "  \033[32mclean\033[0m        - ACTION:   Remove all local temporary files and build artifacts."
-        echo
-
-  # ============================================================================
-  #  FACADE TASKS
-  # ============================================================================
-  # WHAT: Each task below is a simple "facade" that delegates its execution
-  #       to a corresponding task in an included file from the `tasks/` directory.
-  #
-  # WHY:  This pattern keeps the root Taskfile clean and readable, like a high-level
-  #       API menu. It abstracts away the implementation details and enforces a
-  #       consistent structure across the entire project.
-  #
-  # HOW:  The `vars: { CLI_ARGS: '{{.CLI_ARGS}}' }` block is used universally.
-  #       It captures any arguments passed after a '--' on the command line
-  #       (e.g., `task commit -- -m "msg"`) and forwards them to the
-  #       underlying script, enabling both interactive and parameterized use.
-  # ============================================================================
-  task-start:
-    desc: "ACTION: Initiate a new task (e.g., git checkout -b new-feature)."
-    cmds:
-      - task: _task-start:task-start
-        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
-
-  context:
-    desc: "VIEW: Show a summary of local file changes (e.g., git context)."
-    cmds:
-      - task: _context:helper
-        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
-
-  run:
-    desc: "ACTION: Execute the application locally on your machine."
-    cmds:
-      - task: _run:run
-        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
-
-  commit:
-    desc: "ACTION: Save all local changes into a new commit (e.g., git commit)."
-    cmds:
-      - task: _commit:commit
-        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
-
-  task-finish:
-    desc: "ACTION: Finalize a task (e.g., create a pull request)."
-    cmds:
-      - task: _task-finish:task-finish
-        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
-
-  build:
-    desc: "ACTION: Compile source code and create a build artifact."
-    cmds:
-      - task: _build:build
-        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
-
-  test:
-    desc: "ACTION: Run the application's full suite of automated tests."
-    cmds:
-      - task: _test:test
-        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
-
-  analyze:
-    desc: "ACTION: Inspect code for quality, style, and vulnerabilities."
-    cmds:
-      - task: _analyze:analyze
-        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
-
-  release:
-    desc: "ACTION: Create and publish a new versioned release artifact."
-    cmds:
-      - task: _release:release
-        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
-
-  deploy:
-    desc: "ACTION: Deploys the application to the cloud."
-    cmds:
-      - task: _deploy:deploy
-        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
-
-  provision:
-    desc: "GUIDE: Shows setup checklist for cloud infrastructure."
-    cmds:
-      - task: _provision:provision
-        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
-
-  verify:
-    desc: "VIEW: Check that provisioned infrastructure is healthy."
-    cmds:
-      - task: _verify:verify
-        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
-
-  destroy:
-    desc: "ACTION: Permanently destroys ALL cloud infrastructure (requires confirmation)."
-    cmds:
-      - task: _destroy:destroy
-        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
-
-  deps-update:
-    desc: "ACTION: Update third-party dependencies to their latest versions."
-    cmds:
-      - task: _update:deps-update
-        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
-
-  clean:
-    desc: "ACTION: Remove all local temporary files and build artifacts."
-    cmds:
-      - task: _clean:clean
-        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
-
-  # --- Hidden Utilities ---
-  init:
-    internal: true
-    cmds:
-      - task: _init:init
-  env:
-    internal: true
-    cmds:
-      - task: _init:env
diff --git a/factory/scripts/_automation_helpers.sh b/factory/scripts/_automation_helpers.sh
index 7c85b4c..ef04dc6 100644
--- a/factory/scripts/_automation_helpers.sh
+++ b/factory/scripts/_automation_helpers.sh
@@ -1,205 +1,64 @@
-# -----------------------------------------------------------------------------
-# SECTION: SHARED VARIABLES & CONSTANTS
-# -----------------------------------------------------------------------------
-# WHAT: Define variables here that are used by multiple scripts.
-# WHY:  Centralizing constants prevents "magic strings" and makes global
-#       changes (like renaming the main branch) trivial.
-# -----------------------------------------------------------------------------
-readonly MAIN_BRANCH="main"
-readonly PROMPTS_DIR="docs/prompts"
-readonly CONTEXT_STATUS_FILE="contextvibes_status.md"
-readonly BRANCH_PATTERN="^((feature|fix|docs|format)/.+)$"
+#!/bin/bash
+# Filename: factory/scripts/_automation_helpers.sh
 
+# --- DEBUG: Confirm this file was sourced successfully ---
+echo "[DEBUG] Helper file '_automation_helpers.sh' was successfully sourced."
 
-# -----------------------------------------------------------------------------
-# SECTION: SHARED FUNCTIONS
-# -----------------------------------------------------------------------------
-# WHAT: Reusable functions for common automation tasks.
-# WHY:  Encapsulates logic into named, single-responsibility blocks.
-# -----------------------------------------------------------------------------
+readonly PROMPTS_DIR="factory/prompts"
 
-# ---
-# WHAT:  Checks if the current branch is the main branch and exits if it is.
-# WHY:   A critical safety guard to prevent direct modifications or operations
-#        on the primary branch, enforcing a feature-branch workflow.
-# FROM:  commit.sh, finish_task.sh
-# USAGE: prevent_run_on_main
-# ---
-prevent_run_on_main() {
-  if [ "$(git rev-parse --abbrev-ref HEAD)" == "$MAIN_BRANCH" ]; then
-    echo "❌ ERROR: This command cannot be run on the '$MAIN_BRANCH' branch." >&2
-    exit 1
-  fi
-}
+is_text_file() {
+  local file_path="$1"
+  local mime_type
+  local result=1 # Default to "not text" (fail)
 
-# ---
-# WHAT:  Checks for any uncommitted (staged or unstaged) changes and exits
-#        if the workspace is "dirty".
-# WHY:   Ensures that scripts which perform Git operations start from a clean,
-#        known state, preventing accidental inclusion of unrelated changes.
-# FROM:  finish_task.sh
-# USAGE: ensure_clean_workspace
-# ---
-ensure_clean_workspace() {
-  if ! git diff --quiet --exit-code; then
-    echo "❌ ERROR: You have uncommitted changes. Please commit or stash them first." >&2
-    exit 1
-  fi
-}
+  echo "[DEBUG] --- Inside is_text_file ---"
+  echo "[DEBUG] Checking file: '$file_path'"
 
-# ---
-# WHAT:  A non-fatal version of ensure_clean_workspace that just prints a warning.
-# WHY:   Useful for context-generation scripts where uncommitted changes might
-#        be relevant to the output, but the user should be aware of them.
-# FROM:  context_pr.sh
-# USAGE: warn_if_dirty
-# ---
-warn_if_dirty() {
-  if ! git diff --quiet --exit-code; then
-    echo "⚠️  Warning: You have uncommitted changes that may not be reflected in the output." >&2
+  if [ ! -f "$file_path" ]; then
+    echo "[DEBUG] Result: Failure. Path is not a regular file."
+    echo "[DEBUG] --------------------------"
+    return 1
   fi
-}
 
-# ---
-# WHAT:  A user-friendly version of ensure_clean_workspace. It checks for
-#        uncommitted changes and, if found, interactively prompts the user
-#        to stash them before proceeding.
-# WHY:   Provides a better user experience than simply exiting. It allows the
-#        user to save their work-in-progress and continue the current task
-#        without having to manually run git commands.
-# FROM:  clean.sh, start_task.sh
-# USAGE: STASH_PERFORMED=$(prompt_to_stash_if_dirty)
-#        # ... later in the script ...
-#        if [ "$STASH_PERFORMED" = "true" ]; then git stash pop; fi
-# ---
-prompt_to_stash_if_dirty() {
-  if ! git diff --quiet --exit-code; then
-    echo "⚠️  You have uncommitted changes."
-    read -p "    Stash them and continue? (Y/n) " -n 1 -r
-    echo
-    if [[ $REPLY =~ ^[Nn]$ ]]; then
-      echo "Aborted by user. Please commit or stash your changes before running again."
-      exit 1
-    else
-      git stash
-      echo "✅ Changes stashed."
-      # Return "true" to the calling script to signal a stash was performed
-      echo "true"
-    fi
-  else
-    # Return "false" if no stash was performed
-    echo "false"
-  fi
-}
+  mime_type=$(file --brief --mime-type "$file_path")
+  echo "[DEBUG] Detected MIME Type: '$mime_type'"
 
-# ---
-# WHAT:  Validates a given branch name against the project's convention.
-# WHY:   Enforces consistent branch naming across the project, which helps
-#        with organization and automation.
-# FROM:  start_task.sh, clean.sh
-# USAGE: validate_branch_name "feature/my-new-thing"
-# ---
-validate_branch_name() {
-  local branch_name="$1"
-  if [[ ! "$branch_name" =~ $BRANCH_PATTERN ]]; then
-    echo "❌ ERROR: Invalid branch name: '$branch_name'" >&2
-    echo "   Branches must follow the pattern: type/description" >&2
-    echo "   Valid types are: feature, fix, docs, format" >&2
-    echo "   Example: feature/new-context-menu" >&2
-    exit 1
-  fi
-}
+  case "$mime_type" in
+    text/*|application/json|application/javascript|application/x-sh|application/x-shellscript|application/xml|application/x-yaml|application/x-nix|inode/x-empty)
+      echo "[DEBUG] Result: Success. MIME type matched the 'allow' list."
+      result=0 # It's a text file
+      ;;
+    *)
+      echo "[DEBUG] Result: Failure. MIME type did NOT match the 'allow' list."
+      result=1 # It's not a text file
+      ;;
+  esac
 
-# ---
-# WHAT:  Checks if the GitHub CLI ('gh') is installed and authenticated.
-# WHY:   Ensures that scripts relying on GitHub integration (like creating a
-#        pull request) can function correctly.
-# FROM:  finish_task.sh
-# USAGE: ensure_gh_cli_authenticated
-# ---
-ensure_gh_cli_authenticated() {
-  if ! gh auth status > /dev/null 2>&1; then
-    echo "❌ ERROR: GitHub CLI ('gh') is not authenticated. Please run 'gh auth login'." >&2
-    exit 1
-  fi
+  echo "[DEBUG] --------------------------"
+  return $result
 }
 
-# ---
-# WHAT:  Checks for merge conflicts between the current branch and main without
-#        actually performing a merge.
-# WHY:   A critical pre-flight check before attempting a merge or PR. It allows
-#        the script to fail early with a clear message if conflicts exist.
-# FROM:  finish_task.sh
-# USAGE: check_for_merge_conflicts
-# ---
-check_for_merge_conflicts() {
-  echo "--> Analyzing branch for merge conflicts with '$MAIN_BRANCH'..."
-  git fetch origin "$MAIN_BRANCH"
-  # Uses git merge-tree to simulate a merge and checks for conflict markers
-  if git merge-tree "$(git merge-base "origin/$MAIN_BRANCH" HEAD)" HEAD "origin/$MAIN_BRANCH" | grep -q '<<<<<<<'; then
-    echo "❌ CONFLICT DETECTED: This branch has conflicts with '$MAIN_BRANCH'." >&2
-    echo "   Please resolve them manually (e.g., 'git pull origin $MAIN_BRANCH') before proceeding." >&2
-    exit 1
-  fi
-  echo "✅ No merge conflicts detected."
-}
-
-# ---
-# WHAT:  Checks if a given file is a text-based file and not a binary.
-# WHY:   Prevents scripts from attempting to 'cat' binary files (like images
-#        or executables) into a text-based report, which would corrupt it.
-# FROM:  context_export_all.sh, context_export_docs.sh, context_export.sh
-# USAGE: if is_text_file "path/to/file.md"; then ... fi
-# ---
-is_text_file() {
-  local file_path="$1"
-  # The 'file' command inspects the content, and we grep for keywords
-  # that indicate it's safe to treat as text.
-  if file "$file_path" | grep -E -q 'text|script|JSON|XML|YAML|HTML|CSS|Markdown|empty'; then
-    return 0 # Success (it is a text file)
-  else
-    return 1 # Failure (it is not a text file)
-  fi
-}
-
-# WHAT:  Creates a new report file, prepending it with a custom prompt if one
-#        exists, or a generic default prompt if it does not.
-# WHY:   Standardizes the creation of all context export files, ensuring they
-#        are always formatted correctly for AI analysis.
-# FROM:  context_export_automation.sh, context_export_code.sh, etc.
-# USAGE: generate_report_header "path/to/output.md" "path/to/custom_prompt.md" "Default Prompt Title" "Default Prompt Body"
-# ---
 generate_report_header() {
   local output_file="$1"
-  local custom_prompt_file="$2"
+  local prompt_file="$2"
   local default_title="$3"
-  local default_body="$4"
+  local default_task="$4"
 
-  if [ -f "$custom_prompt_file" ]; then
-    echo "--> Using custom prompt from '$custom_prompt_file'."
-    cat "$custom_prompt_file" > "$output_file"
+  if [ -f "$prompt_file" ]; then
+    echo "--> Using custom prompt from: $prompt_file"
+    cat "$prompt_file" > "$output_file"
   else
-    echo "--> Custom prompt not found. Using default."
-    {
-      echo "# AI Prompt: $default_title"
-      echo ""
-      echo "## Your Role"
-      echo "$default_body"
-      echo ""
-      echo "## The Task"
-      echo "Review the following export to gain a complete understanding of the requested context. Acknowledge that you are up-to-date and ready for the next instruction."
-    } > "$output_file"
-  fi
+    echo "--> Using default built-in prompt."
+    local prompt_content
+    prompt_content=$(cat <<EOF
+# AI INSTRUCTION: $default_title
+
+## Your Task
+$default_task
 
-  # Append the standard export header after the prompt
-  {
-    echo ""
-    echo "---"
-    echo "# Automation Framework Export"
-    echo ""
-    echo "**Branch:** \`$(git rev-parse --abbrev-ref HEAD)\`"
-    echo "**Generated:** $(date)"
-    echo ""
-    echo "---"
-  } >> "$output_file"
+---
+EOF
+)
+    echo "$prompt_content" > "$output_file"
+  fi
 }
diff --git a/factory/scripts/analyze.sh b/factory/scripts/analyze.sh
new file mode 100755
index 0000000..89bd5b1
--- /dev/null
+++ b/factory/scripts/analyze.sh
@@ -0,0 +1,29 @@
+#!/bin/bash
+# Finds and analyzes all Go modules using golangci-lint.
+
+set -e
+
+echo "🔎 Searching for Go modules (go.mod files) to analyze..."
+MODULE_FILES=$(find . -name "go.mod" -not -path "./.idx/*")
+
+if [ -z "$MODULE_FILES" ]; then
+  echo "✅ No Go modules found. Nothing to analyze."
+  exit 0
+fi
+
+echo "$MODULE_FILES" | while read -r mod_file; do
+  module_dir=$(dirname "$mod_file")
+  
+  echo
+  gum style --bold --padding "0 1" "Analyzing module: $module_dir"
+
+  (
+    cd "$module_dir"
+    echo "--> Running golangci-lint..."
+    # golangci-lint will automatically find and use the .golangci.yml config file if it exists.
+    golangci-lint run
+  )
+done
+
+echo
+gum style --bold "✅ Analysis complete."
\ No newline at end of file
diff --git a/factory/scripts/build.sh b/factory/scripts/build.sh
new file mode 100755
index 0000000..7893182
--- /dev/null
+++ b/factory/scripts/build.sh
@@ -0,0 +1,43 @@
+#!/bin/bash
+# Finds and compiles all Go modules within the project.
+
+set -e
+
+echo "🔎 Searching for Go modules (go.mod files) to build..."
+MODULE_FILES=$(find . -name "go.mod" -not -path "./.idx/*")
+
+if [ -z "$MODULE_FILES" ]; then
+  echo "✅ No Go modules found. Nothing to build."
+  exit 0
+fi
+
+# Create a central directory for all output binaries at the project root.
+echo "--> Creating output directory at ./bin"
+mkdir -p ./bin
+
+echo "$MODULE_FILES" | while read -r mod_file; do
+  module_dir=$(dirname "$mod_file")
+  binary_name=$(basename "$module_dir")
+  
+  echo
+  gum style --bold --padding "0 1" "Processing module: $module_dir"
+
+  (
+    cd "$module_dir"
+    
+    # --- START: CRITICAL FIX ---
+    # Check if a 'cmd' directory exists before attempting to build.
+    # This is the correct, convention-based check.
+    if [ ! -d "cmd" ]; then
+        echo "--> No 'cmd' directory found in '$module_dir'. Skipping build."
+    else
+        echo "--> Compiling '$binary_name' from ./cmd directory..."
+        # Build the ./cmd package and output to the root ../bin directory.
+        go build -o "../bin/$binary_name" ./cmd
+    fi
+    # --- END: CRITICAL FIX ---
+  )
+done
+
+echo
+gum style --bold "✅ All modules built successfully. Binaries are in ./bin"
\ No newline at end of file
diff --git a/factory/scripts/clean.sh b/factory/scripts/clean.sh
index 5c28fbd..aded341 100755
--- a/factory/scripts/clean.sh
+++ b/factory/scripts/clean.sh
@@ -1,132 +1,109 @@
 #!/bin/bash
-# scripts/clean.sh (FINAL, STATE-AWARE, ROBUST VERSION)
-#
-# WHY:  Provides a single, smart cleanup command that respects user's work.
-# WHAT: Checks for uncommitted changes and asks the user for permission to
-#       stash them before proceeding with the cleanup workflow.
+# A smart, interactive script for cleaning the project.
+# Supports two modes:
+#   1. Interactive Mode: A user-friendly menu for manual cleaning tasks.
+#   2. Non-Interactive Mode: For use in automated environments like CI/CD.
 
+# Exit immediately if any command fails.
 set -e
 
-# --- Phase 0: Get Original State ---
-ORIGINAL_BRANCH=$(git rev-parse --abbrev-ref HEAD)
+# --- Cleaning Functions ---
+
+# Cleans local project-level artifacts. Fast, common, and safe.
+clean_project_files() {
+  echo "--> Removing compiled binaries (./bin)..."
+  rm -rf ./bin
+  echo "--> Cleaning Go build cache..."
+  go clean
+  echo "--> Removing temporary context files..."
+  rm -f context_*.md
+  rm -f context_*.log
+  rm -f contextvibes_*.md
+  rm -f contextvibes_*.log
+  echo "--> Removing Task runner cache (./.task)..."
+  rm -rf ./.task
+}
 
-# --- Phase 1: State Verification and Orchestrator Decision ---
-STASH_PERFORMED=false
-if ! git diff --quiet --exit-code; then
-  echo "⚠️ You have uncommitted changes."
-  read -p "   Would you like to temporarily stash them to proceed? (y/N) " -n 1 -r
-  echo
-  if [[ $REPLY =~ ^[Yy]$ ]]; then
-    git stash
-    STASH_PERFORMED=true
-    echo "✅ Changes stashed."
-  else
-    echo "Aborted by user. Please commit or stash your changes before running again."
-    exit 1
-  fi
-fi
+# Cleans deeper system-level caches. Slow and destructive.
+clean_system_caches() {
+  echo "--> Cleaning Go module and test caches..."
+  go clean -cache -modcache -testcache
+  echo "--> Pruning all unused Docker resources..."
+  docker system prune -af --volumes
+}
 
-# --- Cleanup function to restore original state ---
-cleanup() {
-  echo ""
-  echo "--> Returning to original state..."
-  # Switch back to the original branch BEFORE popping the stash
-  if [[ "$(git rev-parse --abbrev-ref HEAD)" != "$ORIGINAL_BRANCH" ]]; then
-    echo "--> Switching back to branch '$ORIGINAL_BRANCH'."
-    git checkout "$ORIGINAL_BRANCH"
+# Finds and interactively deletes stale local Git branches.
+# A "stale" branch is one that has been merged into 'main' and deleted from the remote.
+clean_stale_branches() {
+  echo "--> Fetching remote state and pruning tracking branches..."
+  git fetch --prune
+
+  echo "--> Searching for stale local branches..."
+  # Get local branches merged into main, excluding the current branch (*) and main itself.
+  MERGED_LOCAL_BRANCHES=$(git branch --merged main | grep -vE '^\*|main$' | sed 's/^[ \t]*//')
+  # Get remote branches, stripping the 'origin/' prefix for comparison.
+  REMOTE_BRANCHES=$(git branch -r | sed 's|origin/||' | sed 's/^[ \t]*//')
+  # Find branches in the first list but not the second using `comm`.
+  BRANCHES_TO_DELETE=$(comm -23 <(echo "$MERGED_LOCAL_BRANCHES" | sort) <(echo "$REMOTE_BRANCHES" | sort))
+
+  if [ -z "$BRANCHES_TO_DELETE" ]; then
+    gum style --bold "✅ No stale local branches found."
+    return
   fi
 
-  if [ "$STASH_PERFORMED" = true ]; then
-    echo "--> Re-applying your stashed changes..."
-    git stash pop
-    echo "✅ Your work has been restored."
+  gum style --bold "The following stale branches can be safely deleted:"
+  echo "$BRANCHES_TO_DELETE" | gum style --faint
+  echo
+  if gum confirm "Proceed with deletion?"; then
+    echo "$BRANCHES_TO_DELETE" | xargs git branch -d
+    gum style --bold "✅ Stale branches deleted."
+  else
+    gum style --bold "Aborted. No branches were deleted."
   fi
 }
-# Register the cleanup function to run on script exit
-trap cleanup EXIT
-
-# --- Phase 2: Automatic File Cleanup ---
-echo ""
-echo "--> Performing automatic file cleanup..."
-rm -f contextvibes_*.md
-echo "✅ Generated report files cleaned."
-echo ""
-
-# --- Phase 3: Analysis ---
-echo "--> Analyzing repository for branch cleanup opportunities..."
-MAIN_BRANCH="main"
-BRANCH_PATTERN="^((feature|fix|docs|format)/.+)$"
-
-git fetch --all --prune
-
-# Switch to main to get an accurate list of merged branches
-if [[ "$(git rev-parse --abbrev-ref HEAD)" != "$MAIN_BRANCH" ]]; then
-  echo "--> Switching to the '$MAIN_BRANCH' branch..."
-  git checkout "$MAIN_BRANCH"
-fi
-echo "--> Pulling latest changes on '$MAIN_BRANCH'..."
-git pull origin "$MAIN_BRANCH"
-
-# Identify branches for cleanup.
-MERGED_BRANCHES=$(git branch --merged "$MAIN_BRANCH" | grep -v '^\* ' | grep -v " $MAIN_BRANCH$" | sed 's/^[ ]*//' || true)
-ALL_LOCAL_BRANCHES=$(git branch | sed 's/^\* //' | grep -v " $MAIN_BRANCH$" | sed 's/^[ ]*//' || true)
-NON_COMPLIANT_BRANCHES=""
-
-for branch in $ALL_LOCAL_BRANCHES; do
-  if [[ ! "$branch" =~ $BRANCH_PATTERN ]]; then
-    if ! echo "$MERGED_BRANCHES" | grep -q "^$branch$"; then
-      NON_COMPLIANT_BRANCHES="$NON_COMPLIANT_BRANCHES $branch"
-    fi
-  fi
-done
-
-if [ -z "$MERGED_BRANCHES" ] && [ -z "$NON_COMPLIANT_BRANCHES" ]; then
-  echo "✅ No local branches require attention. Repository is clean."
-  exit 0
-fi
-
-# --- Phase 4: Present Decisions ---
-echo "---"
-echo "The following branches require your attention:"
-echo ""
-
-if [ -n "$MERGED_BRANCHES" ]; then
-    echo "--- Merged Branches (Safe to Delete) ---"
-    for branch in $MERGED_BRANCHES; do
-        read -p "Delete local branch '$branch'? (y/N) " -n 1 -r
-        echo
-        if [[ $REPLY =~ ^[Yy]$ ]]; then
-            git branch -d "$branch"
-            echo "    ✅ Deleted local branch '$branch'."
-        else
-            echo "    ☑️  Skipped local branch '$branch'."
-        fi
-    done
-    echo ""
-fi
-
-if [ -n "$NON_COMPLIANT_BRANCHES" ]; then
-    echo "--- Non-Compliant Branches (Review Carefully) ---"
-    for branch in $NON_COMPLIANT_BRANCHES; do
-        read -p "Delete local branch '$branch'? (y/N) " -n 1 -r
-        echo
-        if [[ $REPLY =~ ^[Yy]$ ]]; then
-            git branch -d "$branch"
-            echo "    ✅ Deleted local branch '$branch'."
 
-            read -p "      Delete remote branch 'origin/$branch' as well? (y/N) " -n 1 -r
-            echo
-            if [[ $REPLY =~ ^[Yy]$ ]]; then
-                git push origin --delete "$branch"
-                echo "    ✅ Deleted remote branch 'origin/$branch'."
-            else
-                echo "    ☑️  Skipped remote branch."
-            fi
-        else
-            echo "    ☑️  Skipped local branch '$branch'."
-        fi
-    done
-    echo ""
+# --- Main Script Logic ---
+
+# If run without arguments, show the interactive menu.
+if [ -z "$1" ]; then
+  gum style --bold --padding "1 0" "🧹 What would you like to clean?"
+  CHOICE=$(gum choose \
+    "Project Files (Fast: Binaries, Go build cache)" \
+    "Full System Clean (Slow: Also purges Go & Docker caches)" \
+    "Stale Git Branches" \
+    "Quit")
+
+  case "$CHOICE" in
+    "Project Files (Fast: Binaries, Go build cache)")
+      clean_project_files
+      ;;
+    "Full System Clean (Slow: Also purges Go & Docker caches)")
+      clean_project_files
+      echo
+      if gum confirm "DANGER: This will also remove ALL unused Docker resources on your system. Are you sure?"; then
+        clean_system_caches
+      else
+        gum style --bold "Aborted by user."
+      fi
+      ;;
+    "Stale Git Branches")
+      clean_stale_branches
+      ;;
+    *)
+      gum style --bold "Aborted."
+      exit 0
+      ;;
+  esac
+# If run with an argument, use non-interactive mode.
+else
+  MODE=$1
+  echo "Running clean in non-interactive mode: $MODE"
+  case "$MODE" in
+    "project") clean_project_files ;;
+    "full") clean_project_files && clean_system_caches ;;
+    *) echo "Error: Invalid non-interactive mode '$MODE'. Use 'project' or 'full'." >&2; exit 1 ;;
+  esac
 fi
 
-echo "✅ Branch cleanup complete."
+echo
+gum style --bold "✅ Clean complete."
\ No newline at end of file
diff --git a/factory/scripts/commit.sh b/factory/scripts/commit.sh
index d0d0e50..b730885 100755
--- a/factory/scripts/commit.sh
+++ b/factory/scripts/commit.sh
@@ -1,20 +1,21 @@
 #!/bin/bash
-# scripts/commit.sh
+# factory/scripts/commit.sh
 #
 # WHY:  Handles the logic for committing changes safely.
 # WHAT: Checks that the current branch is not 'main', then stages all
-#       changes and commits them using any arguments passed.
-# HOW:  Uses 'git rev-parse' for the branch check, then 'git add' and 'git commit'.
+#       changes and commits them using the arguments passed from the task.
 
 set -e
 
+# --- Configuration ---
 MAIN_BRANCH="main"
 CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
 
 # --- Safety Check ---
+# Prevent direct commits to the main branch.
 if [ "$CURRENT_BRANCH" == "$MAIN_BRANCH" ]; then
-  echo "❌ ERROR: Direct commits to the '$MAIN_BRANCH' branch are not allowed."
-  echo "   Please use 'task task-start -- <branch-name>' to create a feature branch."
+  gum style --border normal --margin "1" --padding "1 2" --border-foreground 99 "❌ ERROR: Direct commits to the '$MAIN_BRANCH' branch are not allowed."
+  echo "   Please use 'task task-start' to create a feature branch first."
   exit 1
 fi
 
@@ -22,7 +23,8 @@ echo "--> Staging all changes..."
 git add .
 
 echo "--> Committing staged changes..."
-# "$@" passes all arguments from the Taskfile to the git commit command
+# The "$@" special variable passes all arguments from the Taskfile
+# (e.g., -m "My message") directly to the git commit command.
 git commit "$@"
 
-echo "✅ Commit successful."
+gum style --foreground 212 "✅ Commit successful."
\ No newline at end of file
diff --git a/factory/scripts/context.sh b/factory/scripts/context.sh
index 2a96636..3a157de 100755
--- a/factory/scripts/context.sh
+++ b/factory/scripts/context.sh
@@ -1,67 +1,66 @@
 #!/bin/bash
-# scripts/context.sh (v3 - Standalone Script Controller)
+# factory/scripts/context.sh
 #
 # WHAT: A master script for context generation. It acts as a router, calling
-#       the correct standalone script based on the user's goal.
+#       the correct helper script based on the user's goal.
 # WHY:  Provides a single entry point (`task context`) while keeping all
 #       implementation logic in dedicated, single-responsibility files.
 
 set -e
 
-# --- The Interactive Menu ---
-# This function displays the menu and calls the appropriate standalone script.
+# --- Configuration ---
+# Get the absolute path to the project root. This is the most reliable way.
+GIT_ROOT=$(git rev-parse --show-toplevel)
+# Define the helpers directory relative to the known project root.
+HELPERS_DIR="$GIT_ROOT/factory/scripts/context_helpers"
+
+# --- The Interactive Menu (using gum) ---
 show_menu() {
-  echo
-  echo "Please select a context generation goal:"
-  PS3="Your choice: "
-  options=(
-    "For a Commit Message"
-    "For a Pull Request Description"
-    "For Quick Verification"
-    "Export: Code Only"
-    "Export: Automation Only"
-    "Export: Documentation Only"
-    "Export: Full Project (All)"
-    "Quit"
-  )
-  select opt in "${options[@]}"; do
-    case $opt in
-      "For a Commit Message")         ./scripts/context_commit.sh; break ;;
-      "For a Pull Request Description") ./scripts/context_pr.sh; break ;;
-      "For Quick Verification")         ./scripts/context_verify.sh; break ;;
-      "Export: Code Only")            ./scripts/context_export_code.sh; break ;;
-      "Export: Automation Only")        ./scripts/context_export_automation.sh; break ;;
-      "Export: Documentation Only")     ./scripts/context_export_docs.sh; break ;;
-      "Export: Full Project (All)")   ./scripts/context_export_all.sh; break ;;
-      "Quit")                         echo "Aborted."; break ;;
-      *)                              echo "Invalid option $REPLY";;
-    esac
-  done
+  gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "CONTEXT GENERATOR"
+  echo "Please select the type of context you want to generate:"
+
+  CHOICE=$(gum choose \
+    "For a Commit Message" \
+    "For a Pull Request Description" \
+    "For a Local Code Review" \
+    "Export: Full Project (All)" \
+    "Export: Code Only" \
+    "Export: Documentation Only" \
+    "Export: Automation Only" \
+    "Quit")
+
+  case "$CHOICE" in
+    "For a Commit Message")         "$HELPERS_DIR/context_commit.sh" ;;
+    "For a Pull Request Description") "$HELPERS_DIR/context_pr.sh" ;;
+    "For a Local Code Review")      "$HELPERS_DIR/review_changes.sh" ;;
+    "Export: Full Project (All)")   "$HELPERS_DIR/export_all.sh" ;;
+    "Export: Code Only")            "$HELPERS_DIR/export_code.sh" ;;
+    "Export: Documentation Only")     "$HELPERS_DIR/export_docs.sh" ;;
+    "Export: Automation Only")        "$HELPERS_DIR/export_automation.sh" ;;
+    "Quit")                         echo "Aborted."; exit 0 ;;
+    *)                              echo "No selection. Aborting."; exit 1 ;;
+  esac
 }
 
 # --- Main Controller Logic ---
 MODE=$1
-case "$MODE" in
-  # --- Parameterized Modes for Automation ---
-  commit)            ./scripts/context_commit.sh ;;
-  pr)                ./scripts/context_pr.sh ;;
-  verify)            ./scripts/context_verify.sh ;;
-  export-code)       ./scripts/context_export_code.sh ;;
-  export-automation) ./scripts/context_export_automation.sh ;;
-  export-docs)       ./scripts/context_export_docs.sh ;;
-  export-all)        ./scripts/context_export_all.sh ;;
 
-  # --- Interactive Mode ---
-  "")
-    show_menu
-    ;;
+if [ -z "$MODE" ]; then
+  show_menu
+  exit 0
+fi
 
-  # --- Error Case ---
+case "$MODE" in
+  commit)            "$HELPERS_DIR/context_commit.sh" ;;
+  pr)                "$HELPERS_DIR/context_pr.sh" ;;
+  review)            "$HELPERS_DIR/review_changes.sh" ;;
+  export-all)        "$HELPERS_DIR/export_all.sh" ;;
+  export-code)       "$HELPERS_DIR/export_code.sh" ;;
+  export-docs)       "$HELPERS_DIR/export_docs.sh" ;;
+  export-automation) "$HELPERS_DIR/export_automation.sh" ;;
   *)
     echo "❌ ERROR: Invalid mode '$MODE' provided." >&2
-    echo "   Valid modes are: commit, pr, verify, export-code, export-automation, export-docs, export-all" >&2
+    echo "   Valid modes are: commit, pr, review, export-all, export-code, export-docs, export-automation" >&2
     exit 1
     ;;
-esac
-
-exit 0
\ No newline at end of file
+esac
\ No newline at end of file
diff --git a/factory/scripts/context_helpers/context_commit.sh b/factory/scripts/context_helpers/context_commit.sh
new file mode 100755
index 0000000..0462ba2
--- /dev/null
+++ b/factory/scripts/context_helpers/context_commit.sh
@@ -0,0 +1,49 @@
+#!/bin/bash
+# factory/scripts/context_helpers/context_commit.sh
+#
+# WHAT: Generates context specifically for writing a commit message.
+# WHY:  It captures the git status and the diff of all pending changes
+#       to provide an AI with the necessary information to draft a message.
+
+set -e
+
+# --- Configuration ---
+OUTPUT_FILE="context_commit.md"
+
+echo "--> Generating context for commit message..."
+
+# --- Main Logic ---
+
+# 1. Start the report with a clear, hardcoded prompt.
+cat <<EOF > "$OUTPUT_FILE"
+# AI Prompt: Generate Conventional Commit Command
+
+## Your Role
+You are an expert software engineer channeling the **\`Canon\`** persona, the guardian of project standards. Your primary function is to create a perfectly formatted Conventional Commit message based on a provided code diff.
+
+## Your Task
+You will be given the output of \`git status\` and \`git diff\`. Your goal is to analyze these changes and generate a single, complete \`task commit\` command that is ready to be executed in the terminal.
+---
+EOF
+
+# 2. Append the git status.
+{
+  echo ""
+  echo "## Uncommitted Local Changes"
+  echo "\`\`\`"
+  git status
+  echo "\`\`\`"
+} >> "$OUTPUT_FILE"
+
+# 3. Append the diff of all staged and unstaged changes.
+{
+  echo ""
+  echo "---"
+  echo "## Diff of Uncommitted Changes"
+  echo "\`\`\`diff"
+  git diff --staged
+  git diff
+  echo "\`\`\`"
+} >> "$OUTPUT_FILE"
+
+echo "✅ Commit context report saved to '$OUTPUT_FILE'."
diff --git a/factory/scripts/context_helpers/context_pr.sh b/factory/scripts/context_helpers/context_pr.sh
new file mode 100755
index 0000000..bae300c
--- /dev/null
+++ b/factory/scripts/context_helpers/context_pr.sh
@@ -0,0 +1,57 @@
+#!/bin/bash
+# factory/scripts/context_helpers/context_pr.sh
+#
+# WHAT: Generates context for writing a Pull Request description by diffing
+#       the current branch against the 'main' branch.
+
+set -e
+
+# --- Configuration ---
+OUTPUT_FILE="context_pr.md"
+MAIN_BRANCH="main" # Assuming 'main' is your primary branch
+
+echo "--> Generating context for Pull Request description..."
+
+# --- Main Logic ---
+
+# 1. Check for uncommitted changes and warn the user.
+if ! git diff --quiet --exit-code; then
+  gum style --foreground 212 "⚠️  Warning: You have uncommitted changes. They will not be included in the PR context."
+fi
+
+# 2. Find the common ancestor to create a clean diff.
+MERGE_BASE=$(git merge-base $MAIN_BRANCH HEAD)
+
+# 3. Start the report with a clear, hardcoded prompt.
+cat <<EOF > "$OUTPUT_FILE"
+# AI Prompt: Generate Pull Request Description
+
+## Your Role
+You are an expert software engineer writing a clear and comprehensive description for a pull request.
+
+## The Task
+Analyze the following git commit history and aggregated diff for the entire feature branch against the \`$MAIN_BRANCH\` branch. Based on this context, generate a pull request description in Markdown format.
+---
+EOF
+
+# 4. Append the commit history for the current branch.
+{
+  echo ""
+  echo "## Commit History on This Branch"
+  echo "\`\`\`"
+  # Use a clean format for the log
+  git log --pretty=format:'%h %s (%an, %cr)' $MERGE_BASE..HEAD
+  echo "\`\`\`"
+} >> "$OUTPUT_FILE"
+
+# 5. Append the full diff against the main branch.
+{
+  echo ""
+  echo "---"
+  echo "## Full Diff for Branch (vs. $MAIN_BRANCH)"
+  echo "\`\`\`diff"
+  git diff $MERGE_BASE..HEAD
+  echo "\`\`\`"
+} >> "$OUTPUT_FILE"
+
+echo "✅ Pull Request context report saved to '$OUTPUT_FILE'."
diff --git a/factory/scripts/context_helpers/export_all.sh b/factory/scripts/context_helpers/export_all.sh
new file mode 100755
index 0000000..5269167
--- /dev/null
+++ b/factory/scripts/context_helpers/export_all.sh
@@ -0,0 +1,43 @@
+#!/bin/bash
+readonly PROMPTS_DIR="factory/prompts"
+
+is_text_file() {
+  local file_path="$1"
+  if [ ! -f "$file_path" ]; then
+    return 1
+  fi
+  local mime_type
+  mime_type=$(file --brief --mime-type "$file_path")
+  case "$mime_type" in
+    text/*|application/json|application/javascript|application/x-sh|application/x-shellscript|application/xml|application/x-yaml|application/x-nix|inode/x-empty)
+      return 0
+      ;;
+    *)
+      return 1
+      ;;
+  esac
+}
+
+generate_report_header() {
+  local output_file="$1"
+  local prompt_file="$2"
+  local default_title="$3"
+  local default_task="$4"
+  if [ -f "$prompt_file" ]; then
+    echo "--> Using custom prompt from: $prompt_file"
+    cat "$prompt_file" > "$output_file"
+  else
+    echo "--> Using default built-in prompt."
+    local prompt_content
+    prompt_content=$(cat <<EOF
+# AI INSTRUCTION: $default_title
+
+## Your Task
+$default_task
+
+---
+EOF
+)
+    echo "$prompt_content" > "$output_file"
+  fi
+}
diff --git a/factory/scripts/context_helpers/export_automation.sh b/factory/scripts/context_helpers/export_automation.sh
new file mode 100755
index 0000000..8c9bae4
--- /dev/null
+++ b/factory/scripts/context_helpers/export_automation.sh
@@ -0,0 +1,49 @@
+#!/bin/bash
+# factory/scripts/context_helpers/export_automation.sh
+# Exports only the factory automation files.
+
+set -e
+
+# --- Configuration ---
+OUTPUT_FILE="context_export_automation.md"
+
+# --- Helper Function ---
+is_text_file() {
+  local mime_type
+  mime_type=$(file --brief --mime-type "$1")
+  [[ "$mime_type" == text/* || "$mime_type" == application/json || "$mime_type" == application/javascript || "$mime_type" == application/x-yaml ]]
+}
+
+echo "--> Generating automation-only export to $OUTPUT_FILE..."
+
+# --- Main Logic ---
+
+# 1. Start the report with a clear, hardcoded prompt.
+cat <<EOF > "$OUTPUT_FILE"
+# AI INSTRUCTION: Automation Framework Analysis
+
+## Your Role
+Assume the role of an expert DevOps engineer and automation specialist. Your memory is being initialized with the project's automation framework.
+
+## Your Task
+The content immediately following this prompt is an export of the project's automation files. Your primary task is to **fully ingest and internalize this context** to understand how the project is built, tested, and managed.
+---
+EOF
+
+# 2. Append all text files from factory/ and the root Taskfile.yml
+git ls-files "factory/" "Taskfile.yml" "idx-template.json" "idx-template.nix" ".idx/" ".vscode" | while read -r file; do
+  if ! is_text_file "$file"; then
+    echo "--> Skipping non-text file: $file (MIME: $(file --brief --mime-type "$file"))"
+    continue
+  fi
+  {
+    echo ""
+    echo "======== FILE: ${file} ========"
+    echo "\`\`\`${file##*.}"
+    cat "$file"
+    echo "\`\`\`"
+    echo "======== END FILE: ${file} ========"
+  } >> "$OUTPUT_FILE"
+done
+
+echo "✅ Automation export complete. Report saved to '$OUTPUT_FILE'."
diff --git a/factory/scripts/context_helpers/export_code.sh b/factory/scripts/context_helpers/export_code.sh
new file mode 100755
index 0000000..597a0a8
--- /dev/null
+++ b/factory/scripts/context_helpers/export_code.sh
@@ -0,0 +1,65 @@
+#!/bin/bash
+# factory/scripts/context_helpers/export_code.sh
+# Exports the source code for a interactively selected product.
+
+set -e
+
+# --- Configuration ---
+OUTPUT_FILE="context_export_code.md"
+
+# --- Helper Function ---
+# Checks if a file is text-based by examining its MIME type.
+is_text_file() {
+  local mime_type
+  mime_type=$(file --brief --mime-type "$1")
+  # Returns true (exit code 0) if the MIME type starts with 'text/' OR is 'application/json' or 'application/javascript'.
+  [[ "$mime_type" == text/* || "$mime_type" == application/json || "$mime_type" == application/javascript ]]
+}
+
+# --- Main Logic ---
+
+# 1. Interactively select the product to export.
+echo "Please select the product to export:"
+PRODUCT_CHOICE=$(gum choose "cli-tool" "cloud-run-api")
+
+# Exit gracefully if the user cancels.
+if [ -z "$PRODUCT_CHOICE" ]; then
+  echo "No selection made. Aborting."
+  exit 1
+fi
+
+echo "--> Generating code-only export for '$PRODUCT_CHOICE' to $OUTPUT_FILE..."
+
+# 2. Start the report with a clear, hardcoded prompt.
+cat <<EOF > "$OUTPUT_FILE"
+# AI INSTRUCTION: Code Context Analysis
+
+## Your Role
+Assume the role of a senior software engineer. Your memory is being initialized with the application source code for the project.
+
+## Your Task
+The content immediately following this prompt is an export of the project's product source code. Your primary task is to **fully ingest and internalize this code**.
+---
+EOF
+
+# 3. Append all text files from the selected product's directory.
+# We use 'git ls-files' to ensure we only include files tracked by git.
+git ls-files "$PRODUCT_CHOICE/" | while read -r file; do
+  # Use the robust helper function to check the file type.
+  if ! is_text_file "$file"; then
+    echo "--> Skipping non-text file: $file (MIME: $(file --brief --mime-type "$file"))"
+    continue
+  fi
+
+  # Append the file's content, wrapped in a markdown code block.
+  {
+    echo ""
+    echo "======== FILE: ${file} ========"
+    echo "\`\`\`${file##*.}"
+    cat "$file"
+    echo "\`\`\`"
+    echo "======== END FILE: ${file} ========"
+  } >> "$OUTPUT_FILE"
+done
+
+echo "✅ Code export for '$PRODUCT_CHOICE' complete. Report saved to '$OUTPUT_FILE'."
\ No newline at end of file
diff --git a/factory/scripts/context_helpers/export_docs.sh b/factory/scripts/context_helpers/export_docs.sh
new file mode 100755
index 0000000..8980b8a
--- /dev/null
+++ b/factory/scripts/context_helpers/export_docs.sh
@@ -0,0 +1,45 @@
+#!/bin/bash
+# factory/scripts/context_helpers/export_docs.sh
+# Exports only the documentation and project management files.
+
+set -e
+
+# --- Configuration ---
+OUTPUT_FILE="context_export_docs.md"
+
+echo "--> Generating docs-only export to $OUTPUT_FILE..."
+
+# --- Main Logic ---
+
+# 1. Start the report with a clear, hardcoded prompt.
+cat <<EOF > "$OUTPUT_FILE"
+# AI INSTRUCTION: Documentation Context Analysis
+
+## Your Role
+Assume the role of a technical writer and project manager. Your memory is being initialized with the project's documentation, changelog, and license.
+
+## Your Task
+The content immediately following this prompt is an export of the project's documentation. Your primary task is to **fully ingest and internalize this content**.
+---
+EOF
+
+# 2. Append all text files from docs/, plus root documentation files.
+git ls-files "docs/" "README.md" "CHANGELOG.md" "LICENSE" "CONTRIBUTING.md" | while read -r file; do
+  # A simple check to skip binary/non-text files.
+  if ! file --brief --mime-type "$file" | grep -q 'text'; then
+    echo "--> Skipping non-text file: $file"
+    continue
+  fi
+
+  # Append the file's content, wrapped in a markdown code block.
+  {
+    echo ""
+    echo "======== FILE: ${file} ========"
+    echo "\`\`\`${file##*.}"
+    cat "$file"
+    echo "\`\`\`"
+    echo "======== END FILE: ${file} ========"
+  } >> "$OUTPUT_FILE"
+done
+
+echo "✅ Docs export complete. Report saved to '$OUTPUT_FILE'."
diff --git a/factory/scripts/context_helpers/review_changes.sh b/factory/scripts/context_helpers/review_changes.sh
new file mode 100755
index 0000000..977443e
--- /dev/null
+++ b/factory/scripts/context_helpers/review_changes.sh
@@ -0,0 +1,68 @@
+#!/bin/bash
+# factory/scripts/context_helpers/review_changes.sh
+#
+# WHAT: Generates a focused report of all recent changes for AI verification.
+#       This includes uncommitted changes and new commits on the current branch.
+
+set -e
+
+# --- Configuration ---
+OUTPUT_FILE="context_review.md"
+MAIN_BRANCH="main"
+CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
+
+echo "--> Generating comprehensive review context..."
+
+# --- Main Logic ---
+
+# 1. Start the report with a clear, hardcoded prompt.
+cat <<EOF > "$OUTPUT_FILE"
+# AI Prompt: Verification of Changes
+
+## Your Role
+You are an expert AI pair programmer acting as a code reviewer.
+
+## The Task
+Carefully analyze the following git status and aggregated diff. Verify that the changes accurately reflect the instructions I just gave you. Confirm if the implementation is correct or point out any discrepancies.
+---
+# Verification Report
+
+**Branch:** \`$CURRENT_BRANCH\`
+**Generated:** $(date -u)
+---
+EOF
+
+# 2. Append a summary of uncommitted changes.
+{
+  echo ""
+  echo "## 1. Uncommitted Local Changes"
+  echo "\`\`\`"
+  # Check if there are any changes, otherwise print a clean message.
+  if [[ -z $(git status --porcelain) ]]; then
+    echo "No uncommitted local changes."
+  else
+    git status
+  fi
+  echo "\`\`\`"
+} >> "$OUTPUT_FILE"
+
+# 3. Append the full aggregated diff (committed on branch + uncommitted).
+{
+  echo ""
+  echo "---"
+  echo "## 2. Aggregated Diff of All Changes vs \`$MAIN_BRANCH\`"
+  echo "\`\`\`diff"
+
+  # Find the common ancestor commit to compare against.
+  MERGE_BASE=$(git merge-base $MAIN_BRANCH HEAD)
+
+  # First, show the diff of all committed changes on this branch.
+  git diff $MERGE_BASE..HEAD
+
+  # Second, show the diff of all uncommitted (staged and unstaged) changes.
+  git diff HEAD
+
+  echo "\`\`\`"
+} >> "$OUTPUT_FILE"
+
+echo "✅ Review context report generated. Saved to '$OUTPUT_FILE'."
\ No newline at end of file
diff --git a/factory/scripts/deps_update.sh b/factory/scripts/deps_update.sh
new file mode 100755
index 0000000..1385409
--- /dev/null
+++ b/factory/scripts/deps_update.sh
@@ -0,0 +1,37 @@
+#!/bin/bash
+# Finds all Go modules in the project and updates their dependencies.
+
+set -e
+
+echo "🔎 Searching for Go modules (go.mod files) to update..."
+
+# Find all 'go.mod' files, excluding the .idx directory which contains environment configs.
+MODULE_FILES=$(find . -name "go.mod" -not -path "./.idx/*")
+
+if [ -z "$MODULE_FILES" ]; then
+  gum style --bold "✅ No Go modules found. Nothing to do."
+  exit 0
+fi
+
+echo "$MODULE_FILES" | while read -r mod_file; do
+  # Get the directory containing the go.mod file.
+  module_dir=$(dirname "$mod_file")
+  
+  echo
+  gum style --bold --padding "0 1" "Processing module: $module_dir"
+
+  # Use a subshell `()` to safely run commands in the module's directory
+  # without needing to manually change back.
+  (
+    cd "$module_dir"
+    echo "🧹 Tidying go.mod and go.sum files..."
+    go mod tidy
+    echo "⬆️  Updating dependencies to latest versions..."
+    go get -u ./...
+    echo "🧹 Tidying again after updates..."
+    go mod tidy
+  )
+done
+
+echo
+gum style --bold "✅ All Go modules updated successfully."
\ No newline at end of file
diff --git a/factory/scripts/task_finish.sh b/factory/scripts/task_finish.sh
new file mode 100755
index 0000000..9779e2e
--- /dev/null
+++ b/factory/scripts/task_finish.sh
@@ -0,0 +1,46 @@
+#!/bin/bash
+# factory/scripts/task_finish.sh
+#
+# WHY:  Standardizes the process of finalizing a feature branch.
+# WHAT: Pushes the current branch and uses the GitHub CLI to create a pull request.
+
+set -e
+
+# --- Phase 1: State Verification ---
+CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
+
+if [[ "$CURRENT_BRANCH" == "main" || "$CURRENT_BRANCH" == "master" ]]; then
+  gum style --bold --foreground "9" "Error: You cannot create a pull request from the main branch."
+  exit 1
+fi
+
+gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "🚀 Ready to finish task on branch '$CURRENT_BRANCH'?"
+
+# --- Phase 2: Push to Remote ---
+if gum confirm "Push branch to remote repository?"; then
+  gum spin --spinner dot --title "Pushing '$CURRENT_BRANCH' to origin..." -- git push -u origin "$CURRENT_BRANCH"
+  echo "✅ Branch pushed successfully."
+else
+  echo "Aborted. Your branch was not pushed."
+  exit 0
+fi
+
+# --- Phase 3: Create Pull Request ---
+# Check for the GitHub CLI `gh`
+if ! command -v gh &> /dev/null; then
+  gum style --bold --foreground "9" "Warning: GitHub CLI ('gh') not found." >&2
+  echo "Cannot create the PR automatically. Please install 'gh' or create the PR manually on the GitHub website." >&2
+  exit 1
+fi
+
+gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "Next, let's create the Pull Request."
+
+# Use `gh pr create`. It's interactive and powerful.
+# --fill: pre-fills title and body from commits.
+# --web: opens the new PR in the browser after creation.
+if gum confirm "Create a Pull Request on GitHub now?"; then
+  gh pr create --fill --web
+  gum style --bold "✅ Pull Request created and opened in your browser."
+else
+  echo "Aborted. You can create the PR later by running 'gh pr create'."
+fi
\ No newline at end of file
diff --git a/factory/scripts/task_start.sh b/factory/scripts/task_start.sh
new file mode 100755
index 0000000..cbeca11
--- /dev/null
+++ b/factory/scripts/task_start.sh
@@ -0,0 +1,61 @@
+#!/bin/bash
+# factory/scripts/start_task.sh
+#
+# WHY:  Handles starting a new feature branch safely.
+# WHAT: Supports both interactive and parameterized branch creation.
+#       - Interactive: `task task-start`
+#       - Parameterized: `task task-start -- <type> <scope> <description>`
+
+set -e
+
+# --- Phase 1: State Verification ---
+STASH_PERFORMED=false
+# Check for uncommitted changes, but only if not running in a CI environment
+if [ -z "$CI" ] && ! git diff --quiet --exit-code; then
+  gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "⚠️ You have uncommitted changes."
+  if gum confirm "Stash them and bring them to the new branch?"; then
+    git stash
+    STASH_PERFORMED=true
+    echo "✅ Changes stashed."
+  else
+    echo "Aborted by user. Please commit or stash your changes."
+    exit 1
+  fi
+fi
+
+# --- Phase 2: Branch Creation (Interactive or Parameterized) ---
+BRANCH_TYPE=$1
+PBI_ID=$2
+DESCRIPTION=$3
+
+# If arguments are not provided, enter interactive mode.
+if [ -z "$BRANCH_TYPE" ] || [ -z "$PBI_ID" ] || [ -z "$DESCRIPTION" ]; then
+  gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "🌿 Let's create a new branch."
+
+  echo "Select a branch type:"
+  BRANCH_TYPE=$(gum choose "feature" "fix" "docs" "style" "refactor" "test" "chore" "factory")
+  if [ -z "$BRANCH_TYPE" ]; then exit 1; fi
+
+  echo "Enter the PBI number or scope (e.g., SFB-003):"
+  PBI_ID=$(gum input --placeholder "SFB-XXX")
+  if [ -z "$PBI_ID" ]; then exit 1; fi
+
+  echo "Enter a short description (use-kebab-case):"
+  DESCRIPTION=$(gum input --placeholder "implement-new-feature")
+  if [ -z "$DESCRIPTION" ]; then exit 1; fi
+fi
+
+BRANCH_NAME="${BRANCH_TYPE}/${PBI_ID}/${DESCRIPTION}"
+gum confirm "Create branch '$BRANCH_NAME'?" || exit 0
+
+# --- Phase 3: Git Operation ---
+gum spin --spinner dot --title "Creating branch..." -- git checkout -b "$BRANCH_NAME"
+
+# --- Phase 4: Restore Stashed Changes (if any) ---
+if [ "$STASH_PERFORMED" = true ]; then
+  echo "--> Re-applying your stashed changes..."
+  git stash pop
+  echo "✅ Your work has been restored."
+fi
+
+gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "✅ Success! You are now on branch '$BRANCH_NAME'."
\ No newline at end of file
diff --git a/factory/scripts/test.sh b/factory/scripts/test.sh
new file mode 100755
index 0000000..2598702
--- /dev/null
+++ b/factory/scripts/test.sh
@@ -0,0 +1,31 @@
+#!/bin/bash
+# Finds and runs tests for all Go modules within the project.
+
+set -e
+
+echo "🔎 Searching for Go modules (go.mod files) to test..."
+MODULE_FILES=$(find . -name "go.mod" -not -path "./.idx/*")
+
+if [ -z "$MODULE_FILES" ]; then
+  echo "✅ No Go modules found. Nothing to test."
+  exit 0
+fi
+
+echo "$MODULE_FILES" | while read -r mod_file; do
+  module_dir=$(dirname "$mod_file")
+  
+  echo
+  gum style --bold --padding "0 1" "Testing module: $module_dir"
+
+  (
+    cd "$module_dir"
+    echo "--> Running tests with coverage..."
+    # -v: verbose output to see individual test results.
+    # -cover: generate a coverage report.
+    # ./...: run tests in the current directory and all subdirectories.
+    go test -v -cover ./...
+  )
+done
+
+echo
+gum style --bold "✅ All tests completed."
\ No newline at end of file
diff --git a/factory/scripts/README.md b/factory/scripts_old/README.md
similarity index 100%
rename from factory/scripts/README.md
rename to factory/scripts_old/README.md
diff --git a/factory/scripts_old/_automation_helpers.sh b/factory/scripts_old/_automation_helpers.sh
new file mode 100644
index 0000000..7c85b4c
--- /dev/null
+++ b/factory/scripts_old/_automation_helpers.sh
@@ -0,0 +1,205 @@
+# -----------------------------------------------------------------------------
+# SECTION: SHARED VARIABLES & CONSTANTS
+# -----------------------------------------------------------------------------
+# WHAT: Define variables here that are used by multiple scripts.
+# WHY:  Centralizing constants prevents "magic strings" and makes global
+#       changes (like renaming the main branch) trivial.
+# -----------------------------------------------------------------------------
+readonly MAIN_BRANCH="main"
+readonly PROMPTS_DIR="docs/prompts"
+readonly CONTEXT_STATUS_FILE="contextvibes_status.md"
+readonly BRANCH_PATTERN="^((feature|fix|docs|format)/.+)$"
+
+
+# -----------------------------------------------------------------------------
+# SECTION: SHARED FUNCTIONS
+# -----------------------------------------------------------------------------
+# WHAT: Reusable functions for common automation tasks.
+# WHY:  Encapsulates logic into named, single-responsibility blocks.
+# -----------------------------------------------------------------------------
+
+# ---
+# WHAT:  Checks if the current branch is the main branch and exits if it is.
+# WHY:   A critical safety guard to prevent direct modifications or operations
+#        on the primary branch, enforcing a feature-branch workflow.
+# FROM:  commit.sh, finish_task.sh
+# USAGE: prevent_run_on_main
+# ---
+prevent_run_on_main() {
+  if [ "$(git rev-parse --abbrev-ref HEAD)" == "$MAIN_BRANCH" ]; then
+    echo "❌ ERROR: This command cannot be run on the '$MAIN_BRANCH' branch." >&2
+    exit 1
+  fi
+}
+
+# ---
+# WHAT:  Checks for any uncommitted (staged or unstaged) changes and exits
+#        if the workspace is "dirty".
+# WHY:   Ensures that scripts which perform Git operations start from a clean,
+#        known state, preventing accidental inclusion of unrelated changes.
+# FROM:  finish_task.sh
+# USAGE: ensure_clean_workspace
+# ---
+ensure_clean_workspace() {
+  if ! git diff --quiet --exit-code; then
+    echo "❌ ERROR: You have uncommitted changes. Please commit or stash them first." >&2
+    exit 1
+  fi
+}
+
+# ---
+# WHAT:  A non-fatal version of ensure_clean_workspace that just prints a warning.
+# WHY:   Useful for context-generation scripts where uncommitted changes might
+#        be relevant to the output, but the user should be aware of them.
+# FROM:  context_pr.sh
+# USAGE: warn_if_dirty
+# ---
+warn_if_dirty() {
+  if ! git diff --quiet --exit-code; then
+    echo "⚠️  Warning: You have uncommitted changes that may not be reflected in the output." >&2
+  fi
+}
+
+# ---
+# WHAT:  A user-friendly version of ensure_clean_workspace. It checks for
+#        uncommitted changes and, if found, interactively prompts the user
+#        to stash them before proceeding.
+# WHY:   Provides a better user experience than simply exiting. It allows the
+#        user to save their work-in-progress and continue the current task
+#        without having to manually run git commands.
+# FROM:  clean.sh, start_task.sh
+# USAGE: STASH_PERFORMED=$(prompt_to_stash_if_dirty)
+#        # ... later in the script ...
+#        if [ "$STASH_PERFORMED" = "true" ]; then git stash pop; fi
+# ---
+prompt_to_stash_if_dirty() {
+  if ! git diff --quiet --exit-code; then
+    echo "⚠️  You have uncommitted changes."
+    read -p "    Stash them and continue? (Y/n) " -n 1 -r
+    echo
+    if [[ $REPLY =~ ^[Nn]$ ]]; then
+      echo "Aborted by user. Please commit or stash your changes before running again."
+      exit 1
+    else
+      git stash
+      echo "✅ Changes stashed."
+      # Return "true" to the calling script to signal a stash was performed
+      echo "true"
+    fi
+  else
+    # Return "false" if no stash was performed
+    echo "false"
+  fi
+}
+
+# ---
+# WHAT:  Validates a given branch name against the project's convention.
+# WHY:   Enforces consistent branch naming across the project, which helps
+#        with organization and automation.
+# FROM:  start_task.sh, clean.sh
+# USAGE: validate_branch_name "feature/my-new-thing"
+# ---
+validate_branch_name() {
+  local branch_name="$1"
+  if [[ ! "$branch_name" =~ $BRANCH_PATTERN ]]; then
+    echo "❌ ERROR: Invalid branch name: '$branch_name'" >&2
+    echo "   Branches must follow the pattern: type/description" >&2
+    echo "   Valid types are: feature, fix, docs, format" >&2
+    echo "   Example: feature/new-context-menu" >&2
+    exit 1
+  fi
+}
+
+# ---
+# WHAT:  Checks if the GitHub CLI ('gh') is installed and authenticated.
+# WHY:   Ensures that scripts relying on GitHub integration (like creating a
+#        pull request) can function correctly.
+# FROM:  finish_task.sh
+# USAGE: ensure_gh_cli_authenticated
+# ---
+ensure_gh_cli_authenticated() {
+  if ! gh auth status > /dev/null 2>&1; then
+    echo "❌ ERROR: GitHub CLI ('gh') is not authenticated. Please run 'gh auth login'." >&2
+    exit 1
+  fi
+}
+
+# ---
+# WHAT:  Checks for merge conflicts between the current branch and main without
+#        actually performing a merge.
+# WHY:   A critical pre-flight check before attempting a merge or PR. It allows
+#        the script to fail early with a clear message if conflicts exist.
+# FROM:  finish_task.sh
+# USAGE: check_for_merge_conflicts
+# ---
+check_for_merge_conflicts() {
+  echo "--> Analyzing branch for merge conflicts with '$MAIN_BRANCH'..."
+  git fetch origin "$MAIN_BRANCH"
+  # Uses git merge-tree to simulate a merge and checks for conflict markers
+  if git merge-tree "$(git merge-base "origin/$MAIN_BRANCH" HEAD)" HEAD "origin/$MAIN_BRANCH" | grep -q '<<<<<<<'; then
+    echo "❌ CONFLICT DETECTED: This branch has conflicts with '$MAIN_BRANCH'." >&2
+    echo "   Please resolve them manually (e.g., 'git pull origin $MAIN_BRANCH') before proceeding." >&2
+    exit 1
+  fi
+  echo "✅ No merge conflicts detected."
+}
+
+# ---
+# WHAT:  Checks if a given file is a text-based file and not a binary.
+# WHY:   Prevents scripts from attempting to 'cat' binary files (like images
+#        or executables) into a text-based report, which would corrupt it.
+# FROM:  context_export_all.sh, context_export_docs.sh, context_export.sh
+# USAGE: if is_text_file "path/to/file.md"; then ... fi
+# ---
+is_text_file() {
+  local file_path="$1"
+  # The 'file' command inspects the content, and we grep for keywords
+  # that indicate it's safe to treat as text.
+  if file "$file_path" | grep -E -q 'text|script|JSON|XML|YAML|HTML|CSS|Markdown|empty'; then
+    return 0 # Success (it is a text file)
+  else
+    return 1 # Failure (it is not a text file)
+  fi
+}
+
+# WHAT:  Creates a new report file, prepending it with a custom prompt if one
+#        exists, or a generic default prompt if it does not.
+# WHY:   Standardizes the creation of all context export files, ensuring they
+#        are always formatted correctly for AI analysis.
+# FROM:  context_export_automation.sh, context_export_code.sh, etc.
+# USAGE: generate_report_header "path/to/output.md" "path/to/custom_prompt.md" "Default Prompt Title" "Default Prompt Body"
+# ---
+generate_report_header() {
+  local output_file="$1"
+  local custom_prompt_file="$2"
+  local default_title="$3"
+  local default_body="$4"
+
+  if [ -f "$custom_prompt_file" ]; then
+    echo "--> Using custom prompt from '$custom_prompt_file'."
+    cat "$custom_prompt_file" > "$output_file"
+  else
+    echo "--> Custom prompt not found. Using default."
+    {
+      echo "# AI Prompt: $default_title"
+      echo ""
+      echo "## Your Role"
+      echo "$default_body"
+      echo ""
+      echo "## The Task"
+      echo "Review the following export to gain a complete understanding of the requested context. Acknowledge that you are up-to-date and ready for the next instruction."
+    } > "$output_file"
+  fi
+
+  # Append the standard export header after the prompt
+  {
+    echo ""
+    echo "---"
+    echo "# Automation Framework Export"
+    echo ""
+    echo "**Branch:** \`$(git rev-parse --abbrev-ref HEAD)\`"
+    echo "**Generated:** $(date)"
+    echo ""
+    echo "---"
+  } >> "$output_file"
+}
diff --git a/factory/scripts_old/clean.sh b/factory/scripts_old/clean.sh
new file mode 100755
index 0000000..5c28fbd
--- /dev/null
+++ b/factory/scripts_old/clean.sh
@@ -0,0 +1,132 @@
+#!/bin/bash
+# scripts/clean.sh (FINAL, STATE-AWARE, ROBUST VERSION)
+#
+# WHY:  Provides a single, smart cleanup command that respects user's work.
+# WHAT: Checks for uncommitted changes and asks the user for permission to
+#       stash them before proceeding with the cleanup workflow.
+
+set -e
+
+# --- Phase 0: Get Original State ---
+ORIGINAL_BRANCH=$(git rev-parse --abbrev-ref HEAD)
+
+# --- Phase 1: State Verification and Orchestrator Decision ---
+STASH_PERFORMED=false
+if ! git diff --quiet --exit-code; then
+  echo "⚠️ You have uncommitted changes."
+  read -p "   Would you like to temporarily stash them to proceed? (y/N) " -n 1 -r
+  echo
+  if [[ $REPLY =~ ^[Yy]$ ]]; then
+    git stash
+    STASH_PERFORMED=true
+    echo "✅ Changes stashed."
+  else
+    echo "Aborted by user. Please commit or stash your changes before running again."
+    exit 1
+  fi
+fi
+
+# --- Cleanup function to restore original state ---
+cleanup() {
+  echo ""
+  echo "--> Returning to original state..."
+  # Switch back to the original branch BEFORE popping the stash
+  if [[ "$(git rev-parse --abbrev-ref HEAD)" != "$ORIGINAL_BRANCH" ]]; then
+    echo "--> Switching back to branch '$ORIGINAL_BRANCH'."
+    git checkout "$ORIGINAL_BRANCH"
+  fi
+
+  if [ "$STASH_PERFORMED" = true ]; then
+    echo "--> Re-applying your stashed changes..."
+    git stash pop
+    echo "✅ Your work has been restored."
+  fi
+}
+# Register the cleanup function to run on script exit
+trap cleanup EXIT
+
+# --- Phase 2: Automatic File Cleanup ---
+echo ""
+echo "--> Performing automatic file cleanup..."
+rm -f contextvibes_*.md
+echo "✅ Generated report files cleaned."
+echo ""
+
+# --- Phase 3: Analysis ---
+echo "--> Analyzing repository for branch cleanup opportunities..."
+MAIN_BRANCH="main"
+BRANCH_PATTERN="^((feature|fix|docs|format)/.+)$"
+
+git fetch --all --prune
+
+# Switch to main to get an accurate list of merged branches
+if [[ "$(git rev-parse --abbrev-ref HEAD)" != "$MAIN_BRANCH" ]]; then
+  echo "--> Switching to the '$MAIN_BRANCH' branch..."
+  git checkout "$MAIN_BRANCH"
+fi
+echo "--> Pulling latest changes on '$MAIN_BRANCH'..."
+git pull origin "$MAIN_BRANCH"
+
+# Identify branches for cleanup.
+MERGED_BRANCHES=$(git branch --merged "$MAIN_BRANCH" | grep -v '^\* ' | grep -v " $MAIN_BRANCH$" | sed 's/^[ ]*//' || true)
+ALL_LOCAL_BRANCHES=$(git branch | sed 's/^\* //' | grep -v " $MAIN_BRANCH$" | sed 's/^[ ]*//' || true)
+NON_COMPLIANT_BRANCHES=""
+
+for branch in $ALL_LOCAL_BRANCHES; do
+  if [[ ! "$branch" =~ $BRANCH_PATTERN ]]; then
+    if ! echo "$MERGED_BRANCHES" | grep -q "^$branch$"; then
+      NON_COMPLIANT_BRANCHES="$NON_COMPLIANT_BRANCHES $branch"
+    fi
+  fi
+done
+
+if [ -z "$MERGED_BRANCHES" ] && [ -z "$NON_COMPLIANT_BRANCHES" ]; then
+  echo "✅ No local branches require attention. Repository is clean."
+  exit 0
+fi
+
+# --- Phase 4: Present Decisions ---
+echo "---"
+echo "The following branches require your attention:"
+echo ""
+
+if [ -n "$MERGED_BRANCHES" ]; then
+    echo "--- Merged Branches (Safe to Delete) ---"
+    for branch in $MERGED_BRANCHES; do
+        read -p "Delete local branch '$branch'? (y/N) " -n 1 -r
+        echo
+        if [[ $REPLY =~ ^[Yy]$ ]]; then
+            git branch -d "$branch"
+            echo "    ✅ Deleted local branch '$branch'."
+        else
+            echo "    ☑️  Skipped local branch '$branch'."
+        fi
+    done
+    echo ""
+fi
+
+if [ -n "$NON_COMPLIANT_BRANCHES" ]; then
+    echo "--- Non-Compliant Branches (Review Carefully) ---"
+    for branch in $NON_COMPLIANT_BRANCHES; do
+        read -p "Delete local branch '$branch'? (y/N) " -n 1 -r
+        echo
+        if [[ $REPLY =~ ^[Yy]$ ]]; then
+            git branch -d "$branch"
+            echo "    ✅ Deleted local branch '$branch'."
+
+            read -p "      Delete remote branch 'origin/$branch' as well? (y/N) " -n 1 -r
+            echo
+            if [[ $REPLY =~ ^[Yy]$ ]]; then
+                git push origin --delete "$branch"
+                echo "    ✅ Deleted remote branch 'origin/$branch'."
+            else
+                echo "    ☑️  Skipped remote branch."
+            fi
+        else
+            echo "    ☑️  Skipped local branch '$branch'."
+        fi
+    done
+    echo ""
+fi
+
+echo "✅ Branch cleanup complete."
diff --git a/factory/scripts_old/commit.sh b/factory/scripts_old/commit.sh
new file mode 100755
index 0000000..d0d0e50
--- /dev/null
+++ b/factory/scripts_old/commit.sh
@@ -0,0 +1,28 @@
+#!/bin/bash
+# scripts/commit.sh
+#
+# WHY:  Handles the logic for committing changes safely.
+# WHAT: Checks that the current branch is not 'main', then stages all
+#       changes and commits them using any arguments passed.
+# HOW:  Uses 'git rev-parse' for the branch check, then 'git add' and 'git commit'.
+
+set -e
+
+MAIN_BRANCH="main"
+CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
+
+# --- Safety Check ---
+if [ "$CURRENT_BRANCH" == "$MAIN_BRANCH" ]; then
+  echo "❌ ERROR: Direct commits to the '$MAIN_BRANCH' branch are not allowed."
+  echo "   Please use 'task task-start -- <branch-name>' to create a feature branch."
+  exit 1
+fi
+
+echo "--> Staging all changes..."
+git add .
+
+echo "--> Committing staged changes..."
+# "$@" passes all arguments from the Taskfile to the git commit command
+git commit "$@"
+
+echo "✅ Commit successful."
diff --git a/factory/scripts_old/context.sh b/factory/scripts_old/context.sh
new file mode 100755
index 0000000..2a96636
--- /dev/null
+++ b/factory/scripts_old/context.sh
@@ -0,0 +1,67 @@
+#!/bin/bash
+# scripts/context.sh (v3 - Standalone Script Controller)
+#
+# WHAT: A master script for context generation. It acts as a router, calling
+#       the correct standalone script based on the user's goal.
+# WHY:  Provides a single entry point (`task context`) while keeping all
+#       implementation logic in dedicated, single-responsibility files.
+
+set -e
+
+# --- The Interactive Menu ---
+# This function displays the menu and calls the appropriate standalone script.
+show_menu() {
+  echo
+  echo "Please select a context generation goal:"
+  PS3="Your choice: "
+  options=(
+    "For a Commit Message"
+    "For a Pull Request Description"
+    "For Quick Verification"
+    "Export: Code Only"
+    "Export: Automation Only"
+    "Export: Documentation Only"
+    "Export: Full Project (All)"
+    "Quit"
+  )
+  select opt in "${options[@]}"; do
+    case $opt in
+      "For a Commit Message")         ./scripts/context_commit.sh; break ;;
+      "For a Pull Request Description") ./scripts/context_pr.sh; break ;;
+      "For Quick Verification")         ./scripts/context_verify.sh; break ;;
+      "Export: Code Only")            ./scripts/context_export_code.sh; break ;;
+      "Export: Automation Only")        ./scripts/context_export_automation.sh; break ;;
+      "Export: Documentation Only")     ./scripts/context_export_docs.sh; break ;;
+      "Export: Full Project (All)")   ./scripts/context_export_all.sh; break ;;
+      "Quit")                         echo "Aborted."; break ;;
+      *)                              echo "Invalid option $REPLY";;
+    esac
+  done
+}
+
+# --- Main Controller Logic ---
+MODE=$1
+case "$MODE" in
+  # --- Parameterized Modes for Automation ---
+  commit)            ./scripts/context_commit.sh ;;
+  pr)                ./scripts/context_pr.sh ;;
+  verify)            ./scripts/context_verify.sh ;;
+  export-code)       ./scripts/context_export_code.sh ;;
+  export-automation) ./scripts/context_export_automation.sh ;;
+  export-docs)       ./scripts/context_export_docs.sh ;;
+  export-all)        ./scripts/context_export_all.sh ;;
+
+  # --- Interactive Mode ---
+  "")
+    show_menu
+    ;;
+
+  # --- Error Case ---
+  *)
+    echo "❌ ERROR: Invalid mode '$MODE' provided." >&2
+    echo "   Valid modes are: commit, pr, verify, export-code, export-automation, export-docs, export-all" >&2
+    exit 1
+    ;;
+esac
+
+exit 0
\ No newline at end of file
diff --git a/factory/scripts/context_commit.sh b/factory/scripts_old/context_commit.sh
similarity index 100%
rename from factory/scripts/context_commit.sh
rename to factory/scripts_old/context_commit.sh
diff --git a/factory/scripts/context_export.sh b/factory/scripts_old/context_export.sh
similarity index 100%
rename from factory/scripts/context_export.sh
rename to factory/scripts_old/context_export.sh
diff --git a/factory/scripts/context_export_all.sh b/factory/scripts_old/context_export_all.sh
similarity index 100%
rename from factory/scripts/context_export_all.sh
rename to factory/scripts_old/context_export_all.sh
diff --git a/factory/scripts/context_export_automation.sh b/factory/scripts_old/context_export_automation.sh
similarity index 100%
rename from factory/scripts/context_export_automation.sh
rename to factory/scripts_old/context_export_automation.sh
diff --git a/factory/scripts/context_export_code.sh b/factory/scripts_old/context_export_code.sh
similarity index 100%
rename from factory/scripts/context_export_code.sh
rename to factory/scripts_old/context_export_code.sh
diff --git a/factory/scripts/context_export_docs.sh b/factory/scripts_old/context_export_docs.sh
similarity index 100%
rename from factory/scripts/context_export_docs.sh
rename to factory/scripts_old/context_export_docs.sh
diff --git a/factory/scripts/context_pr.sh b/factory/scripts_old/context_pr.sh
similarity index 100%
rename from factory/scripts/context_pr.sh
rename to factory/scripts_old/context_pr.sh
diff --git a/factory/scripts/context_verify.sh b/factory/scripts_old/context_verify.sh
similarity index 100%
rename from factory/scripts/context_verify.sh
rename to factory/scripts_old/context_verify.sh
diff --git a/factory/scripts/finish_task.sh b/factory/scripts_old/finish_task.sh
similarity index 100%
rename from factory/scripts/finish_task.sh
rename to factory/scripts_old/finish_task.sh
diff --git a/factory/scripts/generate_playbook_menu.sh b/factory/scripts_old/generate_playbook_menu.sh
similarity index 100%
rename from factory/scripts/generate_playbook_menu.sh
rename to factory/scripts_old/generate_playbook_menu.sh
diff --git a/factory/scripts/generate_prompt_menu.sh b/factory/scripts_old/generate_prompt_menu.sh
similarity index 100%
rename from factory/scripts/generate_prompt_menu.sh
rename to factory/scripts_old/generate_prompt_menu.sh
diff --git a/factory/scripts/start_task.sh b/factory/scripts_old/start_task.sh
similarity index 100%
rename from factory/scripts/start_task.sh
rename to factory/scripts_old/start_task.sh
diff --git a/factory/tasks/README.md b/factory/tasks/README.md
deleted file mode 100644
index f54d09b..0000000
--- a/factory/tasks/README.md
+++ /dev/null
@@ -1,63 +0,0 @@
-Excellent point, Kernel. A project of this complexity requires clear documentation at every level. The `tasks/` directory is the crucial link between the user-facing `Taskfile.yml` and the implementation logic in `scripts/`, so it absolutely deserves its own `README.md`.
-
-This file will complete our documentation hierarchy, ensuring that any developer can understand the framework's design from top to bottom.
-
-Here is a `README.md` crafted for the `tasks/` directory. It is designed to work in concert with the root and `scripts/` READMEs.
-
----
-
-### `tasks/README.md`
-
-```markdown
-# Tasks Directory
-
-## 1. Purpose
-
-This directory contains the individual `Taskfile` configurations that are included by the root `Taskfile.yml`. Each file in this directory corresponds to a high-level command available to the user (e.g., `_commit.yml` implements the `task commit` command).
-
-## 2. Role in the Automation Framework
-
-Our framework follows a "Menu / Workflow / Action" design pattern to ensure clarity and separation of concerns. This directory represents the **"Workflow"** layer.
-
-*   **Menu (`/Taskfile.yml`):** The user-facing command menu. It defines *what* commands are available. It acts as a clean, high-level facade.
-*   **Workflow (`tasks/*.yml`):** This directory. It defines *how* a menu command is connected to its implementation. It's the bridge between the user's intent and the underlying logic.
-*   **Action (`scripts/*.sh`):** The implementation layer. The shell scripts contain the actual logic that performs the work.
-
-This structure keeps the root `Taskfile.yml` simple and readable, while the files in this directory provide the necessary wiring to the scripts.
-
-## 3. File Naming and Structure
-
-*   **Naming Convention:** All files must be prefixed with an underscore (e.g., `_commit.yml`, `_context.yml`). This is a standard `Task` convention that prevents the tasks within these files from appearing in the main `task --list` output, keeping the user-facing menu clean.
-*   **Structure:** Each file is a standard `Taskfile` that defines one or more tasks. Typically, a file like `_commit.yml` will define a single task named `commit`.
-
-## 4. Passing Arguments to Scripts
-
-A critical responsibility of the tasks defined in this directory is to forward any command-line arguments to the underlying scripts. We use a standard pattern for this.
-
-**The Pattern:**
-```yaml
-# tasks/_commit.yml
-version: '3'
-
-tasks:
-  commit:
-    desc: "(Action) Stages all changes and then commits them via a script."
-    silent: true
-    cmds:
-      # Call the script, passing all command-line arguments through.
-      - ./scripts/commit.sh {{.CLI_ARGS}}
-```
-
-The `{{.CLI_ARGS}}` variable is a feature of Go Task that captures all arguments passed after a `--` on the command line. This allows a user to run `task commit -- -m "My commit message"` and have the `-m "..."` part passed directly to `scripts/commit.sh`.
-
-## 5. How to Add a New Task
-
-To add a new command to the framework:
-
-1.  **Create the Script:** Implement the core logic in a new shell script in the `scripts/` directory.
-2.  **Create the Task File:** Create a new file in this directory, named `_your_task_name.yml`.
-3.  **Define the Task:** Inside your new `.yml` file, define the task that calls your script, ensuring you pass `{{.CLI_ARGS}}`.
-4.  **Include the Task File:** Open the root `Taskfile.yml` and add your new file to the `includes:` block.
-5.  **Create the Facade:** In the root `Taskfile.yml`, add the user-facing facade task that delegates to your new task (e.g., `your-task: task: _your_task_name:your-task`).
-6.  **Update the Help Menu:** Add your new command to the `default` task's help menu in the root `Taskfile.yml` so it is discoverable by users.
-```
diff --git a/factory/tasks/_analyze.yml b/factory/tasks/_analyze.yml
index 72541a1..0e511ca 100644
--- a/factory/tasks/_analyze.yml
+++ b/factory/tasks/_analyze.yml
@@ -1,12 +1,11 @@
-# tasks/_analyze.yml
+# factory/tasks/_analyze.yml
 version: '3'
+
 tasks:
   analyze:
-    desc: "(Info) Explains that this is a placeholder for code analysis."
+    desc: "ACTION: Inspects code for quality, style, and vulnerabilities."
+    long: "Finds all Go modules and runs 'golangci-lint run' for each one."
     silent: true
     cmds:
-      - |
-        echo
-        echo "--> INFO: This is a placeholder for a code analysis task."
-        echo "    The original implementation can be found in the git history if needed."
-        echo
+      - chmod +x ./factory/scripts/analyze.sh
+      - ./factory/scripts/analyze.sh
\ No newline at end of file
diff --git a/factory/tasks/_build.yml b/factory/tasks/_build.yml
index 9d5602c..6022cbb 100644
--- a/factory/tasks/_build.yml
+++ b/factory/tasks/_build.yml
@@ -1,12 +1,11 @@
-# tasks/_build.yml
+# factory/tasks/_build.yml
 version: '3'
+
 tasks:
   build:
-    desc: "(Info) Explains that this is a placeholder for a build task."
+    desc: "ACTION: Compiles all Go modules and places binaries in ./bin."
+    long: "Finds all Go modules in the project and compiles them, placing the output binaries in the root ./bin directory."
     silent: true
     cmds:
-      - |
-        echo
-        echo "--> INFO: This is a placeholder for a build task."
-        echo "    The original implementation can be found in the git history if needed."
-        echo
+      - chmod +x ./factory/scripts/build.sh
+      - ./factory/scripts/build.sh
\ No newline at end of file
diff --git a/factory/tasks/_clean.yml b/factory/tasks/_clean.yml
index 3051ac6..af75c4d 100644
--- a/factory/tasks/_clean.yml
+++ b/factory/tasks/_clean.yml
@@ -1,10 +1,17 @@
-# tasks/_clean.yml
-# Implements the high-level 'clean' command.
+# factory/tasks/_clean.yml
 version: '3'
 
 tasks:
   clean:
-    desc: "Cleans generated files and interactively prompts for branch cleanup."
+    desc: "Interactively cleans project artifacts, caches, and stale git branches."
+    long: |
+      Runs a smart, interactive script to clean the project.
+
+      Usage:
+        task clean          - Show the interactive menu for manual cleaning.
+        task clean project  - (Non-interactive) Clean project files only.
+        task clean full     - (Non-interactive) Perform a full system clean including Docker.
     silent: true
     cmds:
-      - ./scripts/clean.sh
+      - chmod +x ./factory/scripts/clean.sh
+      - ./factory/scripts/clean.sh {{.CLI_ARGS}}
\ No newline at end of file
diff --git a/factory/tasks/_commit.yml b/factory/tasks/_commit.yml
index 83b71a4..d596263 100644
--- a/factory/tasks/_commit.yml
+++ b/factory/tasks/_commit.yml
@@ -1,11 +1,20 @@
-# tasks/_commit.yml
-# Implements the high-level 'commit' command.
+# factory/tasks/_commit.yml
 version: '3'
 
 tasks:
   commit:
-    desc: "(Action) Stages all changes and then commits them via a script."
+    desc: "ACTION: Save all local changes into a new commit (e.g., git commit)."
+    long: |
+      A wrapper around 'git commit' that adds safety and convenience.
+      1. Prevents direct commits to the 'main' branch.
+      2. Automatically stages all tracked changes ('git add .').
+      3. Passes all arguments directly to 'git commit'.
+
+      Usage:
+        task commit -m "feat: a descriptive commit message"
+        task commit --amend --no-edit
     silent: true
     cmds:
-      # Call the script, passing all command-line arguments through.
-      - ./scripts/commit.sh {{.CLI_ARGS}}
+      - chmod +x ./factory/scripts/commit.sh
+      # {{.CLI_ARGS}} forwards all arguments (like -m "...") to the script.
+      - ./factory/scripts/commit.sh {{.CLI_ARGS}}
\ No newline at end of file
diff --git a/factory/tasks/_context.yml b/factory/tasks/_context.yml
index 286fe57..2938970 100644
--- a/factory/tasks/_context.yml
+++ b/factory/tasks/_context.yml
@@ -1,14 +1,16 @@
-# tasks/_context.yml
-# WHAT: This file is the facade for all context-generation commands.
-# WHY:  It provides a single, consistent helper task that forwards all
-#       arguments to the main context controller script.
-
+# factory/tasks/_context.yml
 version: '3'
 
 tasks:
-  # This single helper task is called by all `context:*` tasks in the root Taskfile.
-  # It receives the specific mode (e.g., 'commit', 'export-code') via CLI_ARGS.
-  helper:
-    internal: true
+  context:
+    desc: "VIEW: Generate context for a specific goal (commit, pr, etc.)."
+    long: |
+      Runs the main context generation script.
+
+      Usage:
+        task context          - Shows an interactive menu to choose the context type.
+        task context -- <type> - Directly generates the specified context (e.g., 'commit', 'pr').
+    silent: true
     cmds:
-      - ./scripts/context.sh {{.CLI_ARGS}}
\ No newline at end of file
+      - chmod +x -R ./factory/scripts/context*
+      - ./factory/scripts/context.sh {{.CLI_ARGS}}
\ No newline at end of file
diff --git a/factory/tasks/_deploy.yml b/factory/tasks/_deploy.yml
index a0c716c..58914ad 100644
--- a/factory/tasks/_deploy.yml
+++ b/factory/tasks/_deploy.yml
@@ -1,12 +1,9 @@
-# tasks/_deploy.yml
+# factory/tasks/_deploy.yml
 version: '3'
 tasks:
   deploy:
-    desc: "(Info) Explains that this is a placeholder for a deployment task."
+    desc: "ACTION: Deploys the application to the cloud (Not Yet Implemented)."
+    long: "This is a placeholder for deploying a compiled binary to a service like Google Cloud Run."
     silent: true
     cmds:
-      - |
-        echo
-        echo "--> WARNING: This is a placeholder. The real 'deploy' task is destructive."
-        echo "    The original implementation can be found in the git history if needed."
-        echo
+      - gum style --bold --foreground 212 "Placeholder for 'deploy'. A real implementation would use 'gcloud run deploy' or similar."
\ No newline at end of file
diff --git a/factory/tasks/_deps_update.yml b/factory/tasks/_deps_update.yml
new file mode 100644
index 0000000..efe7f4e
--- /dev/null
+++ b/factory/tasks/_deps_update.yml
@@ -0,0 +1,14 @@
+# factory/tasks/_update.yml
+version: '3'
+
+tasks:
+  deps-update:
+    desc: "Finds all Go modules in the project and updates their dependencies."
+    long: |
+      This task intelligently searches for all 'go.mod' files and runs 'go mod tidy'
+      and 'go get -u ./...' for each module found. It is safe to run from the
+      project root and will not fail if no Go modules are found.
+    silent: true
+    cmds:
+      - chmod +x ./factory/scripts/deps_update.sh
+      - ./factory/scripts/deps_update.sh
\ No newline at end of file
diff --git a/factory/tasks/_destroy.yml b/factory/tasks/_destroy.yml
index 05f1e36..c605e8d 100644
--- a/factory/tasks/_destroy.yml
+++ b/factory/tasks/_destroy.yml
@@ -1,12 +1,9 @@
-# tasks/_destroy.yml
+# factory/tasks/_destroy.yml
 version: '3'
 tasks:
   destroy:
-    desc: "(Info) Explains that this task is a placeholder for infrastructure teardown."
+    desc: "Destroys all provisioned cloud infrastructure (Not Yet Implemented)."
+    long: "This is a placeholder for tearing down all cloud resources created by the 'provision' task."
     silent: true
     cmds:
-      - |
-        echo
-        echo "--> WARNING: This is a placeholder. The real 'destroy' task is destructive."
-        echo "    The original implementation can be found in the git history if needed."
-        echo
+      - gum style --bold --foreground 212 "Placeholder for 'destroy'. A real implementation would use 'terraform destroy' or similar."
\ No newline at end of file
diff --git a/factory/tasks/_init.yml b/factory/tasks/_init.yml
deleted file mode 100644
index 0d467ab..0000000
--- a/factory/tasks/_init.yml
+++ /dev/null
@@ -1,29 +0,0 @@
-# tasks/_init.yml
-# This file contains the foundational Action for initializing the project.
-# It ensures the .env file exists and is properly configured.
-version: '3'
-
-tasks:
-  init:
-    desc: "(Action) Verifies .env exists and is configured, creating it if needed."
-    silent: true
-    cmds:
-      - |
-        # Why: The .env file is critical for all subsequent tasks.
-        # If it doesn't exist, we should create it for the user to reduce friction.
-        if [ ! -f .env ]; then
-          echo "--> .env file not found. Creating one from .env.example..."
-          cp .env.example .env
-          echo "✅ .env file created. Please edit it with your project values."
-          # Why: We exit here because the user MUST configure the new file.
-          exit 1
-        fi
-      - |
-        # Why: To prevent errors, we must ensure the user has replaced all
-        # placeholder values from the example file. This grep is a safety net.
-        if grep -q "your-" .env; then
-          echo "❌ CONFIGURATION INCOMPLETE: Your .env file still contains placeholder values." >&2
-          echo "   Please edit the .env file and replace all 'your-...' placeholders." >&2
-          exit 1
-        fi
-        echo "✅ .env file is present and correctly configured."
diff --git a/factory/tasks/_provision.yml b/factory/tasks/_provision.yml
index c134d2c..6a96b08 100644
--- a/factory/tasks/_provision.yml
+++ b/factory/tasks/_provision.yml
@@ -1,12 +1,9 @@
-# tasks/_provision.yml
+# factory/tasks/_provision.yml
 version: '3'
 tasks:
   provision:
-    desc: "(Info) Explains that this task provides a setup guide."
+    desc: "Provisions necessary cloud infrastructure (Not Yet Implemented)."
+    long: "This is a placeholder for provisioning cloud resources using tools like Terraform or gcloud."
     silent: true
     cmds:
-      - |
-        echo
-        echo "--> INFO: This task is intended to show a checklist for provisioning cloud infrastructure."
-        echo "    The original implementation can be found in the git history if needed."
-        echo
+      - gum style --bold --foreground 212 "Placeholder for 'provision'. A real implementation would use 'terraform apply' or similar."
\ No newline at end of file
diff --git a/factory/tasks/_release.yml b/factory/tasks/_release.yml
index 40d2a1d..d812a1a 100644
--- a/factory/tasks/_release.yml
+++ b/factory/tasks/_release.yml
@@ -1,19 +1,9 @@
-# tasks/_release.yml (PLACEHOLDER)
-# This file defines the placeholder task for creating a new versioned release.
+# factory/tasks/_release.yml
 version: '3'
-
 tasks:
   release:
-    desc: "(Info) Explains that this is a placeholder for the release process."
-    # This task is internal because the user-facing command is in the root Taskfile.
-    internal: true
+    desc: "ACTION: Creates and publishes a new versioned release artifact (Not Yet Implemented)."
+    long: "This is a placeholder for creating a git tag, building binaries, and creating a GitHub Release."
     silent: true
     cmds:
-      - |
-        echo
-        echo "--> INFO: This is a placeholder for the 'release' task."
-        echo "    The full release process, including building and publishing artifacts,"
-        echo "    will be implemented here."
-        echo
-        echo "    It would receive arguments like: {{.CLI_ARGS}}"
-        echo
+      - gum style --bold --foreground 212 "Placeholder for 'release'. A real implementation would automate git tagging and GitHub releases."
\ No newline at end of file
diff --git a/factory/tasks/_run.yml b/factory/tasks/_run.yml
index 579e433..9f22a29 100644
--- a/factory/tasks/_run.yml
+++ b/factory/tasks/_run.yml
@@ -1,16 +1,13 @@
-# tasks/_run.yml
-# Implements the 'run' command to display an informational message.
-
+# factory/tasks/_run.yml
 version: '3'
 
 tasks:
   run:
-    desc: "(Info) Explains why there is no local run command for this project."
+    desc: "ACTION: Execute the application locally on your machine (Not Yet Implemented)."
+    long: |
+      This is a placeholder for running a compiled application locally.
+      A full implementation would likely execute a binary from the './bin' directory
+      after a successful 'task build'.
     silent: true
     cmds:
-      - |
-        echo
-        echo "--> INFO: No 'run' action is defined for this project."
-        echo "    This repository contains an automation framework and development"
-        echo "    environment, not a runnable application."
-        echo
+      - gum style --bold --foreground 212 "Placeholder for 'run'. A real implementation would execute the compiled binary, e.g., './bin/cloud-run-api'."
\ No newline at end of file
diff --git a/factory/tasks/_task-finish.yml b/factory/tasks/_task-finish.yml
index e0b19a4..16c841b 100644
--- a/factory/tasks/_task-finish.yml
+++ b/factory/tasks/_task-finish.yml
@@ -1,10 +1,10 @@
-# tasks/_task-finish.yml
-# Implements the high-level 'task-finish' command.
+# factory/tasks/_task-finish.yml
 version: '3'
 
 tasks:
   task-finish:
-    desc: "(Action) Syncs the branch and opens a browser to create a PR."
+    desc: "Syncs the current branch and opens a browser to create a PR."
     silent: true
     cmds:
-      - ./scripts/finish_task.sh
+      - chmod +x ./factory/scripts/task_finish.sh
+      - ./factory/scripts/task_finish.sh
\ No newline at end of file
diff --git a/factory/tasks/_task-start.yml b/factory/tasks/_task-start.yml
index 67fe149..ef98062 100644
--- a/factory/tasks/_task-start.yml
+++ b/factory/tasks/_task-start.yml
@@ -1,11 +1,25 @@
-# tasks/_task-start.yml
-# Implements the high-level 'task-start' command.
+# factory/tasks/_task-start.yml
 version: '3'
 
 tasks:
   task-start:
-    desc: "(Action) Creates and checks out a new feature branch."
+    desc: "ACTION: Initiate a new task by creating a structured feature branch."
+    long: |
+      Handles starting a new feature branch safely. It checks for uncommitted
+      changes and offers to stash them first.
+
+      It supports two modes:
+
+      1. Interactive Mode:
+         Run without arguments to be guided through creating a branch name.
+         $ task task-start
+
+      2. Parameterized Mode:
+         Provide the branch components as arguments to create it directly.
+         The format is: <type> <scope> <description>
+         $ task task-start -- feature SFB-007 implement-new-api
     silent: true
     cmds:
-      # Call the script, passing all command-line arguments through.
-      - ./scripts/start_task.sh {{.CLI_ARGS}}
+      # The '--' is used to pass all subsequent arguments to the script.
+      - chmod +x ./factory/scripts/task_start.sh
+      - ./factory/scripts/task_start.sh {{.CLI_ARGS}}
\ No newline at end of file
diff --git a/factory/tasks/_test.yml b/factory/tasks/_test.yml
index fdcee8c..7a27f38 100644
--- a/factory/tasks/_test.yml
+++ b/factory/tasks/_test.yml
@@ -1,12 +1,11 @@
-# tasks/_test.yml
+# factory/tasks/_test.yml
 version: '3'
+
 tasks:
   test:
-    desc: "(Info) Explains that this is a placeholder for a test suite."
+    desc: "ACTION: Runs the full suite of automated tests for all Go modules."
+    long: "Finds all Go modules and runs 'go test -v -cover ./...' for each one."
     silent: true
     cmds:
-      - |
-        echo
-        echo "--> INFO: This is a placeholder for a test suite."
-        echo "    The original implementation can be found in the git history if needed."
-        echo
+      - chmod +x ./factory/scripts/test.sh
+      - ./factory/scripts/test.sh
\ No newline at end of file
diff --git a/factory/tasks/_update.yml b/factory/tasks/_update.yml
deleted file mode 100644
index 5a15066..0000000
--- a/factory/tasks/_update.yml
+++ /dev/null
@@ -1,12 +0,0 @@
-# tasks/_update.yml
-version: '3'
-tasks:
-  deps-update:
-    desc: "(Info) Explains that this task updates third-party dependencies."
-    silent: true
-    cmds:
-      - |
-        echo
-        echo "--> INFO: This task is intended to update third-party dependencies."
-        echo "    The original implementation can be found in the git history if needed."
-        echo
diff --git a/factory/tasks/_verify.yml b/factory/tasks/_verify.yml
index 25eb0ac..f6c81df 100644
--- a/factory/tasks/_verify.yml
+++ b/factory/tasks/_verify.yml
@@ -1,12 +1,9 @@
-# tasks/_verify.yml
+# factory/tasks/_verify.yml
 version: '3'
 tasks:
   verify:
-    desc: "(Info) Explains that this task checks infrastructure health."
+    desc: "Verifies the health of a deployed service (Not Yet Implemented)."
+    long: "This is a placeholder for running post-deployment checks, like hitting a /health endpoint."
     silent: true
     cmds:
-      - |
-        echo
-        echo "--> INFO: This task is intended to verify that provisioned infrastructure is healthy."
-        echo "    The original implementation can be found in the git history if needed."
-        echo
+      - gum style --bold --foreground 212 "Placeholder for 'verify'. A real implementation would curl a health check endpoint."
\ No newline at end of file
diff --git a/.idx/dev.nix b/.idx/dev.nix
index 0d908ea..2762cec 100644
--- a/.idx/dev.nix
+++ b/.idx/dev.nix
@@ -1,118 +1,85 @@
+# This file defines the development environment for a Firebase Studio workspace using Nix.
+# It specifies all the packages, services, and editor extensions needed for the project.
 { pkgs, ... }:
+
+let
+  # Imports the custom Nix derivation for the 'contextvibes' tool from a separate file.
+  # This declarative approach makes the tool a first-class package in the environment,
+  # which is more reproducible and cacheable than installing it with an imperative script.
+  contextvibes = import ./contextvibes.nix { pkgs = pkgs; };
+in
 {
-  # Specifies the Nixpkgs channel to ensure a reproducible package set across machines.
+  # Specifies the Nixpkgs channel to use. Pinning to a specific channel like "stable-25.05"
+  # ensures that everyone on the team gets the exact same package versions, leading to a
+  # highly reproducible environment.
   channel = "stable-25.05";
 
   # Defines the packages to be installed in the development environment.
+  # Packages are grouped by function for better readability.
   packages = with pkgs; [
-    # --- Core Dependency for Tooling ---
-    # The Go toolchain is required to build and install Go-based CLI tools,
-    # such as the 'contextvibes' CLI installed in the onCreate hook below.
-    go
-
-    # --- Project Automation ---
-    # A task runner that uses a 'Taskfile.yml' to automate common project commands.
-    go-task
-
-    # --- Code Quality & Linting ---
-    nodejs # The JavaScript runtime, required by markdownlint-cli.
-    nodePackages.markdownlint-cli # A linter to enforce standards in Markdown files.
-
-    # --- Essential Utilities ---
+    # --- Core Language Toolchains ---
+    go # The Go compiler and toolchain.
+    gopls # The official Go language server for IDE features.
+    delve # The standard debugger for Go.
+    nodejs # The JavaScript runtime, required for some linters.
+
+    # --- Project Automation & Task Running ---
+    go-task # A task runner that uses 'Taskfile.yml' to automate common commands.
+
+    # --- Code Quality & Formatting ---
+    shellcheck # Linter for finding bugs in shell scripts.
+    shfmt # Auto-formatter for shell scripts.
+    nodePackages.markdownlint-cli # Linter to enforce standards in Markdown files.
+
+    # --- Data Processing & CLI Tools ---
+    jq # A command-line JSON processor.
+    yq-go # A portable command-line YAML processor (Go version).
+    gum # A tool for creating glamorous shell scripts and interactive menus.
+
+    # --- Version Control & Essential Utilities ---
     git # The version control system for managing source code.
-    gh # The official GitHub CLI for interacting with GitHub from the terminal.
-    tree # A utility to display directory structures.
-    file # For inspecting file types (fixes the immediate error)
-    shellcheck # To find bugs and errors in shell scripts
-    shfmt # To automatically format shell scripts
-
-    # --- Interactive UI/Menus ---
-    gum # For creating beautiful, modern interactive menus and prompts
+    gh # The official GitHub CLI for interacting with GitHub.
+    tree # A utility to display directory structures as a tree.
+    file # A utility to determine file types.
 
-    # --- Data Processing  ---
-    jq # The standard tool for parsing and handling JSON
-    yq # The standa
+    # --- Custom Project Tools ---
+    contextvibes # The custom-built 'contextvibes' CLI tool, managed by its own Nix file.
   ];
 
-  # Sets global environment variables for the Nix shell. This is empty for now.
+  # Sets global environment variables for the Nix shell.
   env = { };
 
   # Configures the IDX workspace environment.
   idx = {
-    # Specifies VS Code extensions to install automatically for a better IDE experience.
+    # Specifies VS Code extensions to install automatically.
+    # This ensures a consistent and fully-featured editor experience for all developers.
     extensions = [
-      # Provides syntax highlighting and management features for Dockerfiles.
-      "ms-azuretools.vscode-docker"
+      # --- Core Language & Framework Support ---
+      "golang.go" # Official Go language support.
+      "task.vscode-task" # Adds support for Go Task ('Taskfile.yml').
 
-      # Integrates GitHub pull requests and issues directly into the editor.
-      "GitHub.vscode-pull-request-github"
+      # --- Code Quality & Linting ---
+      "DavidAnson.vscode-markdownlint" # Integrates markdownlint into the editor.
+      "timonwong.shellcheck" # Integrates shellcheck for live linting of shell scripts.
 
-      # Lints Markdown files to ensure consistent formatting.
-      "DavidAnson.vscode-markdownlint"
+      # --- Version Control ---
+      "GitHub.vscode-pull-request-github" # Integrates GitHub PRs and issues.
+      "eamodio.gitlens" # Supercharges the Git capabilities built into VS Code.
     ];
-
-    # Defines lifecycle hooks that run at different stages of the workspace's life.
-    workspace = {
-      # Runs only ONCE when the workspace is first created to handle initial setup.
-      onCreate = {
-        installContextVibesCli = ''
-          # This script installs a project-specific tool not available in Nixpkgs.
-          echo ">>> Setting up ContextVibes CLI..."
-          LOCAL_BIN_DIR="$(pwd)/bin"
-          mkdir -p "$LOCAL_BIN_DIR"
-          
-          # Use GOBIN to direct 'go install' to the local ./bin directory.
-          export GOBIN="$LOCAL_BIN_DIR"
-          echo "Installing contextvibes@v0.2.0 into $GOBIN..."
-          
-          # Install a specific, known-good version for reproducibility.
-          if go install github.com/contextvibes/cli/cmd/contextvibes@v0.2.0; then
-            echo "✅ Successfully installed contextvibes to $GOBIN/contextvibes"
-            chmod +x "$GOBIN/contextvibes"
-          else
-            # Provide a clear, actionable error message on failure.
-            echo "❌ ERROR: Failed to install contextvibes. Check Go environment and network."
-            exit 1 # Halt further onCreate scripts on failure.
-          fi
-          
-          unset GOBIN
-        '';
-      };
-
-      # Runs EVERY TIME the workspace is started to validate the environment.
-      onStart = {
-        checkContextVibes = ''
-          # This script validates that the ContextVibes CLI is installed and executable.
-          echo ">>> Verifying ContextVibes CLI installation..."
-          EXE_PATH="$(pwd)/bin/contextvibes"
-
-          # Verify that the executable file exists.
-          if [ ! -f "$EXE_PATH" ]; then
-            echo "⚠️ ContextVibes CLI not found at $EXE_PATH. Run the 'onCreate' hook if this is a new workspace."
-            exit 1
-          fi
-
-          # Verify that the file has execute permissions.
-          if [ ! -x "$EXE_PATH" ]; then
-            echo "❌ ERROR: Found contextvibes at $EXE_PATH, but it is not executable. Attempting to fix..."
-            chmod +x "$EXE_PATH" || exit 1
-          fi
-
-          # Verify that the tool is functional by running its version command.
-          if VERSION_OUTPUT=$("$EXE_PATH" version); then
-            echo "✅ ContextVibes CLI is ready. Version: $VERSION_OUTPUT"
-          else
-            echo "❌ ERROR: ContextVibes CLI is present but the 'version' command failed."
-            exit 1
-          fi
-        '';
-      };
-    };
-
-    # Configures web previews for the workspace.
-    previews = {
-      # Previews are disabled as this is primarily a CLI-focused environment.
-      enable = false;
-    };
   };
+
+  # Note on Lifecycle Hooks (`onCreate`, `onStart`):
+  # This configuration intentionally omits lifecycle hooks for package installation,
+  # preferring the declarative `packages` list. This Nix-native approach ensures
+  # reproducibility and leverages caching for faster workspace startups.
+  #
+  # Hooks can still be useful for one-time actions, like initializing a project or
+  # displaying a welcome message. For example:
+  #
+  # idx.workspace.onCreate = [
+  #   ''
+  #     echo "Welcome to the project! Your tools are ready." | gum format -t "code"
+  #     echo "Run 'task --list' to see available commands." | gum format -t "code"
+  #   ''
+  # ];
 }
diff --git a/Taskfile.yml b/Taskfile.yml
index e562e7b..168c411 100644
--- a/Taskfile.yml
+++ b/Taskfile.yml
@@ -1,103 +1,191 @@
-# /.Taskfile.yml
+# Taskfile.yml
 #
-# WHAT: This is the public API for the project's automation framework. It is a
-#       transparent facade that proxies all commands to the real implementation
-#       located in the ./factory directory.
-# WHY:  This provides a single, self-documenting entry point for all developers,
-#       fulfilling our "Taskfile as the Public API" principle.
+# WHAT: This file is the single, user-facing entry point for all project automation.
+# WHY:  It provides a simple, high-level command menu that is easy for developers
+#       to use and understand, hiding the complexity of the underlying scripts and tools.
+#       This approach, called "Menu / Workflow / Action", is designed to reduce cognitive load.
 
 version: '3'
 
-# The dotenv declaration MUST live in this top-level file.
+# ==============================================================================
+#  INCLUDED TASK FILES
+# ==============================================================================
+# WHAT: This block includes all the helper Taskfiles from the ./factory/tasks/ directory.
+# WHY:  Including these files allows this main Taskfile to act as a clean menu,
+#       delegating the actual implementation logic to the included files. This
+#       keeps the project's automation organized and maintainable.
+# ==============================================================================
+includes:
+  # --- Local Development (Inner Loop) ---
+  _task-start:      ./factory/tasks/_task-start.yml
+  _context:         ./factory/tasks/_context.yml
+  _run:             ./factory/tasks/_run.yml
+  _commit:          ./factory/tasks/_commit.yml
+  _task-finish:     ./factory/tasks/_task-finish.yml
+
+  # --- Build & Release Pipeline (Outer Loop) ---
+  _build:           ./factory/tasks/_build.yml
+  _test:            ./factory/tasks/_test.yml
+  _analyze:         ./factory/tasks/_analyze.yml
+  _release:         ./factory/tasks/_release.yml
+  _deploy:          ./factory/tasks/_deploy.yml
+
+  # --- Infrastructure & Utilities ---
+  _provision:       ./factory/tasks/_provision.yml
+  _verify:          ./factory/tasks/_verify.yml
+  _destroy:         ./factory/tasks/_destroy.yml
+  _deps_update:     ./factory/tasks/_deps_update.yml
+  _clean:           ./factory/tasks/_clean.yml
+
+# WHAT: This directive automatically loads environment variables from the .env file.
+# WHY:  This makes project-specific variables (like GCP_PROJECT_ID) available
+#       to all tasks and their underlying scripts without manual sourcing.
 dotenv: [".env"]
 
 tasks:
-  # The default task explicitly calls the 'default' task from the factory's
-  # Taskfile, ensuring the formatted menu is always displayed.
+  # WHAT: This is the default task that runs when 'task' is called without arguments.
+  # WHY:  Its purpose is to display a well-formatted, user-friendly help menu
+  #       that describes all available high-level commands.
   default:
     desc: "Displays the main project command menu."
     silent: true
     cmds:
-      - task --dir ./factory default
-
-  # ---------------------------------------------------------------------------
-  # PROXY TASKS (The Public API)
-  # Each task below is a simple proxy that calls the real task inside the
-  # factory. The description is copied for discoverability (`task --list`),
-  # and {{.CLI_ARGS}} ensures all arguments are passed through.
-  # ---------------------------------------------------------------------------
-
+      - |
+        echo
+        echo "----------------------------------------------------------------------------"
+        echo "          ✨ THEA Command Menu (Cognitively-Refined) ✨"
+        echo "----------------------------------------------------------------------------"
+        echo "Run \`task <command>\` to execute an action. e.g., \`task test\`"
+        echo
+        echo -e "\033[1m--- 💻 Local Development (Inner Loop) ---\033[0m"
+        echo "    Tasks for the core cycle of coding and local iteration."
+        echo
+        echo -e "  \033[32mtask-start\033[0m   - ACTION:   Initiate a new task (e.g., \`git checkout -b new-feature\`)."
+        echo -e "  \033[32mcontext\033[0m      - VIEW:     Generate context for a specific goal (commit, pr, verify, export-*)."
+        echo -e "  \033[32mrun\033[0m          - ACTION:   Execute the application locally on your machine."
+        echo -e "  \033[32mcommit\033[0m       - ACTION:   Save all local changes into a new commit (e.g., \`git commit\`)."
+        echo -e "  \033[32mtask-finish\033[0m  - ACTION:   Finalize a task (e.g., create a pull request)."
+        echo
+        echo -e "\033[1m--- 📦 Build & Release Pipeline (Outer Loop) ---\033[0m"
+        echo "    Tasks for building, testing, and deploying the application."
+        echo
+        echo -e "  \033[32mbuild\033[0m        - ACTION:   Compile source code and create a build artifact."
+        echo -e "  \033[32mtest\033[0m         - ACTION:   Run the application's full suite of automated tests."
+        echo -e "  \033[32manalyze\033[0m      - ACTION:   Inspect code for quality, style, and vulnerabilities."
+        echo -e "  \033[32mrelease\033[0m      - ACTION:   Create and publish a new versioned release artifact."
+        echo -e "  \033[32mdeploy\033[0m       - ACTION:   Deploys the application to the cloud."
+        echo
+        echo -e "\033[1m--- ☁️ Infrastructure & Utilities ---\033[0m"
+        echo "    Tasks for managing cloud resources and local housekeeping."
+        echo
+        echo -e "  \033[32mprovision\033[0m    - GUIDE:    Shows setup checklist for cloud infrastructure."
+        echo -e "  \033[32mverify\033[0m       - VIEW:     Check that provisioned infrastructure is healthy."
+        echo -e "  \033[31mdestroy\033[0m      - ACTION:   Shows checklist for tearing down all infrastructure."
+        echo -e "  \033[32mdeps-update\033[0m  - ACTION:   Update third-party dependencies to their latest versions."
+        echo -e "  \033[32mclean\033[0m        - ACTION:   Remove all local temporary files and build artifacts."
+        echo
+
+  # ============================================================================
+  #  FACADE TASKS
+  # ============================================================================
+  # WHAT: Each task below is a simple "facade" that delegates its execution
+  #       to a corresponding task in an included file from the `tasks/` directory.
+  #
+  # WHY:  This pattern keeps the root Taskfile clean and readable, like a high-level
+  #       API menu. It abstracts away the implementation details and enforces a
+  #       consistent structure across the entire project.
+  #
+  # HOW:  The `vars: { CLI_ARGS: '{{.CLI_ARGS}}' }` block is used universally.
+  #       It captures any arguments passed after a '--' on the command line
+  #       (e.g., `task commit -- -m "msg"`) and forwards them to the
+  #       underlying script, enabling both interactive and parameterized use.
+  # ============================================================================
   task-start:
     desc: "ACTION: Initiate a new task (e.g., git checkout -b new-feature)."
     cmds:
-      - task --dir ./factory task-start -- {{.CLI_ARGS}}
+      - task: _task-start:task-start
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   context:
-    desc: "VIEW: Generate context for a specific goal (commit, pr, verify, export-*)."
+    desc: "VIEW: Generate context for a specific goal (commit, pr, review, export-*)."
     cmds:
-      - task --dir ./factory context -- {{.CLI_ARGS}}
+      - task: _context:context
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   run:
     desc: "ACTION: Execute the application locally on your machine."
     cmds:
-      - task --dir ./factory run -- {{.CLI_ARGS}}
+      - task: _run:run
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   commit:
     desc: "ACTION: Save all local changes into a new commit (e.g., git commit)."
     cmds:
-      - task --dir ./factory commit -- {{.CLI_ARGS}}
+      - task: _commit:commit
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   task-finish:
     desc: "ACTION: Finalize a task (e.g., create a pull request)."
     cmds:
-      - task --dir ./factory task-finish -- {{.CLI_ARGS}}
+      - task: _task-finish:task-finish
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   build:
     desc: "ACTION: Compile source code and create a build artifact."
     cmds:
-      - task --dir ./factory build -- {{.CLI_ARGS}}
+      - task: _build:build
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   test:
     desc: "ACTION: Run the application's full suite of automated tests."
     cmds:
-      - task --dir ./factory test -- {{.CLI_ARGS}}
+      - task: _test:test
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   analyze:
     desc: "ACTION: Inspect code for quality, style, and vulnerabilities."
     cmds:
-      - task --dir ./factory analyze -- {{.CLI_ARGS}}
+      - task: _analyze:analyze
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   release:
     desc: "ACTION: Create and publish a new versioned release artifact."
     cmds:
-      - task --dir ./factory release -- {{.CLI_ARGS}}
+      - task: _release:release
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   deploy:
     desc: "ACTION: Deploys the application to the cloud."
     cmds:
-      - task --dir ./factory deploy -- {{.CLI_ARGS}}
+      - task: _deploy:deploy
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   provision:
     desc: "GUIDE: Shows setup checklist for cloud infrastructure."
     cmds:
-      - task --dir ./factory provision -- {{.CLI_ARGS}}
+      - task: _provision:provision
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   verify:
     desc: "VIEW: Check that provisioned infrastructure is healthy."
     cmds:
-      - task --dir ./factory verify -- {{.CLI_ARGS}}
+      - task: _verify:verify
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   destroy:
-    desc: "ACTION: Shows checklist for tearing down all infrastructure."
+    desc: "ACTION: Permanently destroys ALL cloud infrastructure (requires confirmation)."
     cmds:
-      - task --dir ./factory destroy -- {{.CLI_ARGS}}
+      - task: _destroy:destroy
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   deps-update:
     desc: "ACTION: Update third-party dependencies to their latest versions."
     cmds:
-      - task --dir ./factory deps-update -- {{.CLI_ARGS}}
+      - task: _deps_update:deps-update
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
 
   clean:
     desc: "ACTION: Remove all local temporary files and build artifacts."
     cmds:
-      - task --dir ./factory clean -- {{.CLI_ARGS}}
+      - task: _clean:clean
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
diff --git a/factory/scripts/_automation_helpers.sh b/factory/scripts/_automation_helpers.sh
index ef04dc6..66c9626 100644
--- a/factory/scripts/_automation_helpers.sh
+++ b/factory/scripts/_automation_helpers.sh
@@ -1,59 +1,47 @@
 #!/bin/bash
-# Filename: factory/scripts/_automation_helpers.sh
-
-# --- DEBUG: Confirm this file was sourced successfully ---
-echo "[DEBUG] Helper file '_automation_helpers.sh' was successfully sourced."
-
 readonly PROMPTS_DIR="factory/prompts"
 
 is_text_file() {
   local file_path="$1"
-  local mime_type
-  local result=1 # Default to "not text" (fail)
-
-  echo "[DEBUG] --- Inside is_text_file ---"
-  echo "[DEBUG] Checking file: '$file_path'"
-
   if [ ! -f "$file_path" ]; then
-    echo "[DEBUG] Result: Failure. Path is not a regular file."
-    echo "[DEBUG] --------------------------"
     return 1
   fi
-
+  local mime_type
   mime_type=$(file --brief --mime-type "$file_path")
-  echo "[DEBUG] Detected MIME Type: '$mime_type'"
-
   case "$mime_type" in
     text/*|application/json|application/javascript|application/x-sh|application/x-shellscript|application/xml|application/x-yaml|application/x-nix|inode/x-empty)
-      echo "[DEBUG] Result: Success. MIME type matched the 'allow' list."
-      result=0 # It's a text file
+      return 0
       ;;
     *)
-      echo "[DEBUG] Result: Failure. MIME type did NOT match the 'allow' list."
-      result=1 # It's not a text file
+      return 1
       ;;
   esac
-
-  echo "[DEBUG] --------------------------"
-  return $result
 }
 
+# In factory/scripts/_automation_helpers.sh
+
+# ... (keep the is_text_file function as is) ...
+
+# Generates the header for a report file.
+# Uses a custom prompt file if it exists, otherwise uses the improved default text.
 generate_report_header() {
   local output_file="$1"
   local prompt_file="$2"
   local default_title="$3"
-  local default_task="$4"
+  local default_task="$4" # This will now be the detailed role/task description
 
+  # If a specific prompt file exists, use it.
   if [ -f "$prompt_file" ]; then
     echo "--> Using custom prompt from: $prompt_file"
     cat "$prompt_file" > "$output_file"
   else
-    echo "--> Using default built-in prompt."
+    # --- THIS IS THE IMPROVED FALLBACK LOGIC ---
+    echo "--> Using improved default built-in prompt."
     local prompt_content
     prompt_content=$(cat <<EOF
-# AI INSTRUCTION: $default_title
+# AI Prompt: $default_title
 
-## Your Task
+## Your Role & Task
 $default_task
 
 ---
diff --git a/factory/scripts/context.sh b/factory/scripts/context.sh
index 3a157de..67f8dd7 100755
--- a/factory/scripts/context.sh
+++ b/factory/scripts/context.sh
@@ -1,66 +1,240 @@
 #!/bin/bash
 # factory/scripts/context.sh
 #
-# WHAT: A master script for context generation. It acts as a router, calling
-#       the correct helper script based on the user's goal.
-# WHY:  Provides a single entry point (`task context`) while keeping all
-#       implementation logic in dedicated, single-responsibility files.
+# WHAT: A master script for context generation. It contains all logic
+#       for generating context for various goals, such as commits, PRs,
+#       and full project exports, consolidated into a single file.
+# WHY:  Provides a single, maintainable entry point (`task context`) without
+#       needing to call external helper scripts.
 
-set -e
+set -euo pipefail
 
-# --- Configuration ---
-# Get the absolute path to the project root. This is the most reliable way.
-GIT_ROOT=$(git rev-parse --show-toplevel)
-# Define the helpers directory relative to the known project root.
-HELPERS_DIR="$GIT_ROOT/factory/scripts/context_helpers"
+# --- Configuration & Setup ---
+readonly GIT_ROOT=$(git rev-parse --show-toplevel)
+# All helper functions are now defined locally in this script.
+# shellcheck source=./_automation_helpers.sh
+source "$(dirname "$0")/_automation_helpers.sh"
 
-# --- The Interactive Menu (using gum) ---
-show_menu() {
-  gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "CONTEXT GENERATOR"
-  echo "Please select the type of context you want to generate:"
-
-  CHOICE=$(gum choose \
-    "For a Commit Message" \
-    "For a Pull Request Description" \
-    "For a Local Code Review" \
-    "Export: Full Project (All)" \
-    "Export: Code Only" \
-    "Export: Documentation Only" \
-    "Export: Automation Only" \
-    "Quit")
-
-  case "$CHOICE" in
-    "For a Commit Message")         "$HELPERS_DIR/context_commit.sh" ;;
-    "For a Pull Request Description") "$HELPERS_DIR/context_pr.sh" ;;
-    "For a Local Code Review")      "$HELPERS_DIR/review_changes.sh" ;;
-    "Export: Full Project (All)")   "$HELPERS_DIR/export_all.sh" ;;
-    "Export: Code Only")            "$HELPERS_DIR/export_code.sh" ;;
-    "Export: Documentation Only")     "$HELPERS_DIR/export_docs.sh" ;;
-    "Export: Automation Only")        "$HELPERS_DIR/export_automation.sh" ;;
-    "Quit")                         echo "Aborted."; exit 0 ;;
-    *)                              echo "No selection. Aborting."; exit 1 ;;
-  esac
+# ==============================================================================
+# LOCAL HELPER: CONTEXT GENERATION LOGIC
+# =================================d=============================================
+# WHAT: This local function contains the core logic for exporting files.
+# WHY:  Defining it here avoids repeating code for each export type.
+#
+# Usage: export_book "Output Filename" "Book Title" "path1" "path2" ...
+# ==============================================================================
+export_book() {
+    local output_file="$1"
+    local title="$2"
+    shift 2 # Remove the first two arguments, leaving only the paths
+    local paths=("$@")
+
+    # Append the book header to the main output file.
+    { echo ""; echo "---"; echo "## Book: ${title}"; echo ""; } >> "$output_file"
+
+    # Find all files tracked by git in the given paths.
+    git -C "$GIT_ROOT" ls-files -- "${paths[@]}" | while IFS= read -r file; do
+        [ -z "$file" ] && continue
+        local full_path="$GIT_ROOT/$file"
+
+        # Use the robust is_text_file function from our helper script.
+        if ! is_text_file "$full_path"; then
+            echo "--> Skipping non-text/binary file: $file"
+            continue
+        fi
+
+        # Append the file's content, wrapped in markdown code blocks.
+        {
+            echo ""
+            echo "======== FILE: ${file} ========"
+            echo "\`\`\`${file##*.}"
+            cat "$full_path"
+            echo "\`\`\`"
+            echo "======== END FILE: ${file} ========"
+        } >> "$output_file"
+    done
+}
+
+
+# ==============================================================================
+# CONSOLIDATED ACTIONS
+# All logic from the `context_helpers` directory is now here.
+# ==============================================================================
+
+# --- ACTION: Generate context for a commit message ---
+# In factory/scripts/context.sh
+
+
+# --- ACTION: Generate context for a commit message ---
+generate_commit_context() {
+    local output_file="$GIT_ROOT/context_commit.md"
+    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/generate-commit-message.md"
+    
+    echo "--> Generating context for commit message..."
+    
+    # This now passes a much better, multi-line default prompt text.
+    generate_report_header \
+        "$output_file" \
+        "$prompt_file" \
+        "Generate Conventional Commit Command" \
+        "You are an expert software engineer channeling the **\`Canon\`** persona, the guardian of project standards. Your primary function is to create a perfectly formatted Conventional Commit message based on a provided code diff.
+
+Your goal is to analyze the following `git status` and `git diff` output and generate a single, complete \`task commit\` command that is ready to be executed in the terminal."
+
+    {
+        echo ""
+        echo "## Git Status"
+        echo "\`\`\`"
+        git status
+        echo "\`\`\`"
+        echo ""
+        echo "---"
+        echo "## Diff of All Uncommitted Changes"
+        echo "\`\`\`diff"
+        git diff --staged
+        git diff
+        echo "\`\`\`"
+    } >> "$output_file"
+
+    echo "✅ Commit context generated. File: '$output_file'"
+}
+
+# --- ACTION: Generate context for a Pull Request ---
+generate_pr_context() {
+    # (Implementation for PR context would go here)
+    gum style --bold --foreground 212 "Placeholder for 'Pull Request' context generation."
+}
+
+# --- ACTION: Generate context for code review ---
+generate_review_context() {
+    # (Implementation for review context would go here)
+    gum style --bold --foreground 212 "Placeholder for 'Code Review' context generation."
+}
+
+# --- ACTION: Export the entire project ---
+export_all_project() {
+    local output_file="$GIT_ROOT/context_export_all.md"
+    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/export-project-context.md"
+
+    echo "--> Generating full project export..."
+
+    generate_report_header \
+        "$output_file" \
+        "$prompt_file" \
+        "Full Project Context Analysis" \
+        "You are an expert AI systems architect. Your task is to analyze the following comprehensive project export to build a complete mental model of the repository's architecture, purpose, and implementation."
+
+    # Export architectural components
+    export_book "$output_file" "The Product (Core THEA Guidance)" "thea/"
+    export_book "$output_file" "The Factory (Automation Framework)" "Taskfile.yml" ".github/" "factory/" ".idx/" ".vscode/"
+    export_book "$output_file" "The Library (Project Documentation)" "README.md" "CHANGELOG.md" "LICENSE" "CONTRIBUTING.md" "docs/"
+
+    echo "✅ Full project export complete. Report saved to '$output_file'."
+}
+
+# --- ACTION: Export only the application code ---
+export_code_only() {
+    local output_file="$GIT_ROOT/context_export_code.md"
+    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/export-code-context.md"
+    
+    echo "--> Exporting application code only..."
+
+    generate_report_header \
+      "$output_file" \
+      "$prompt_file" \
+      "Application Code Analysis" \
+      "You are an expert Go developer. Analyze the following application code."
+
+    export_book "$output_file" "The Product (Core THEA Guidance)" "thea/"
+
+    echo "✅ Code export complete. Report saved to '$output_file'."
+}
+
+# --- ACTION: Export only the documentation ---
+export_docs_only() {
+    local output_file="$GIT_ROOT/context_export_docs.md"
+    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/export-docs-context.md"
+    
+    echo "--> Exporting documentation only..."
+
+    generate_report_header \
+      "$output_file" \
+      "$prompt_file" \
+      "Documentation & Guidance Analysis" \
+      "You are a documentation architect. Analyze the following project documentation."
+
+    export_book "$output_file" "The Library (Project Documentation)" "README.md" "CHANGELOG.md" "LICENSE" "CONTRIBUTING.md" "docs/"
+
+    echo "✅ Documentation export complete. Report saved to '$output_file'."
+}
+
+# --- ACTION: Export only the automation framework ---
+export_automation_only() {
+    local output_file="$GIT_ROOT/context_export_automation.md"
+    local prompt_file="$GIT_ROOT/$PROMPTS_DIR/export-automation-context.md"
+    
+    echo "--> Exporting automation framework only..."
+    
+    generate_report_header \
+      "$output_file" \
+      "$prompt_file" \
+      "Automation Framework Analysis" \
+      "You are a lead automation engineer. Analyze the following automation framework."
+
+    export_book "$output_file" "The Factory (Automation Framework)" "Taskfile.yml" ".github/" "factory/" ".idx/" ".vscode/"
+
+    echo "✅ Automation export complete. Report saved to '$output_file'."
 }
 
-# --- Main Controller Logic ---
-MODE=$1
 
-if [ -z "$MODE" ]; then
-  show_menu
-  exit 0
-fi
+# ==============================================================================
+# Main Controller Logic
+# ==============================================================================
+show_menu() {
+    gum style --border normal --margin "1" --padding "1 2" --border-foreground 212 "CONTEXT GENERATOR"
+    echo "Please select the type of context you want to generate:"
+
+    # The menu now calls the local functions defined above
+    local CHOICE
+    CHOICE=$(gum choose \
+        "For a Commit Message" \
+        "For a Pull Request Description" \
+        "For a Local Code Review" \
+        "Export: Full Project (All)" \
+        "Export: Code Only" \
+        "Export: Documentation Only" \
+        "Export: Automation Only" \
+        "Quit")
+
+    case "$CHOICE" in
+        "For a Commit Message")         generate_commit_context ;;
+        "For a Pull Request Description") generate_pr_context ;;
+        "For a Local Code Review")      generate_review_context ;;
+        "Export: Full Project (All)")   export_all_project ;;
+        "Export: Code Only")            export_code_only ;;
+        "Export: Documentation Only")     export_docs_only ;;
+        "Export: Automation Only")        export_automation_only ;;
+        "Quit")                         echo "Aborted."; exit 0 ;;
+        *)                              echo "No selection. Aborting."; exit 1 ;;
+    esac
+}
+
+# --- Router ---
+# The first argument passed to the script determines the mode.
+readonly MODE="${1:-menu}" # Default to 'menu' if no argument is provided.
 
 case "$MODE" in
-  commit)            "$HELPERS_DIR/context_commit.sh" ;;
-  pr)                "$HELPERS_DIR/context_pr.sh" ;;
-  review)            "$HELPERS_DIR/review_changes.sh" ;;
-  export-all)        "$HELPERS_DIR/export_all.sh" ;;
-  export-code)       "$HELPERS_DIR/export_code.sh" ;;
-  export-docs)       "$HELPERS_DIR/export_docs.sh" ;;
-  export-automation) "$HELPERS_DIR/export_automation.sh" ;;
-  *)
-    echo "❌ ERROR: Invalid mode '$MODE' provided." >&2
-    echo "   Valid modes are: commit, pr, review, export-all, export-code, export-docs, export-automation" >&2
-    exit 1
-    ;;
-esac
\ No newline at end of file
+    menu)              show_menu ;;
+    commit)            generate_commit_context ;;
+    pr)                generate_pr_context ;;
+    review)            generate_review_context ;;
+    export-all)        export_all_project ;;
+    export-code)       export_code_only ;;
+    export-docs)       export_docs_only ;;
+    export-automation) export_automation_only ;;
+    *)
+        echo "❌ ERROR: Invalid mode '$MODE' provided." >&2
+        echo "   Valid modes are: commit, pr, review, export-all, export-code, export-docs, export-automation" >&2
+        exit 1
+        ;;
+esac
diff --git a/factory/scripts/context_helpers/export_all.sh b/factory/scripts/context_helpers/export_all.sh
index 5269167..c5e4f7c 100755
--- a/factory/scripts/context_helpers/export_all.sh
+++ b/factory/scripts/context_helpers/export_all.sh
@@ -1,43 +1,48 @@
 #!/bin/bash
-readonly PROMPTS_DIR="factory/prompts"
-
-is_text_file() {
-  local file_path="$1"
-  if [ ! -f "$file_path" ]; then
-    return 1
-  fi
-  local mime_type
-  mime_type=$(file --brief --mime-type "$file_path")
-  case "$mime_type" in
-    text/*|application/json|application/javascript|application/x-sh|application/x-shellscript|application/xml|application/x-yaml|application/x-nix|inode/x-empty)
-      return 0
-      ;;
-    *)
-      return 1
-      ;;
-  esac
-}
+set -euo pipefail
+# shellcheck source=../_automation_helpers.sh
+source "$(dirname "$0")/../_automation_helpers.sh"
+
+readonly GIT_ROOT=$(git rev-parse --show-toplevel)
+readonly OUTPUT_FILE="$GIT_ROOT/contextvibes_export_project.md"
+readonly PROMPT_FILE="$GIT_ROOT/$PROMPTS_DIR/export-project-context.md"
+
+append_book_to_report() {
+  local title="$1"
+  shift
+  local paths=("$@")
+
+  { echo ""; echo "---"; echo "## Book: ${title}"; echo ""; } >> "$OUTPUT_FILE"
 
-generate_report_header() {
-  local output_file="$1"
-  local prompt_file="$2"
-  local default_title="$3"
-  local default_task="$4"
-  if [ -f "$prompt_file" ]; then
-    echo "--> Using custom prompt from: $prompt_file"
-    cat "$prompt_file" > "$output_file"
-  else
-    echo "--> Using default built-in prompt."
-    local prompt_content
-    prompt_content=$(cat <<EOF
-# AI INSTRUCTION: $default_title
-
-## Your Task
-$default_task
-
----
-EOF
-)
-    echo "$prompt_content" > "$output_file"
-  fi
+  git -C "$GIT_ROOT" ls-files -- "${paths[@]}" | while IFS= read -r file; do
+    [ -z "$file" ] && continue
+    local full_path="$GIT_ROOT/$file"
+
+    if ! is_text_file "$full_path"; then
+      echo "--> Skipping non-text/binary file: $file"
+      continue
+    fi
+
+    {
+      echo ""
+      echo "======== FILE: ${file} ========"
+      echo "\`\`\`${file##*.}"
+      cat "$full_path"
+      echo "\`\`\`"
+      echo "======== END FILE: ${file} ========"
+    } >> "$OUTPUT_FILE"
+  done
 }
+
+echo "--> Generating full project export..."
+generate_report_header \
+  "$OUTPUT_FILE" \
+  "$PROMPT_FILE" \
+  "Full Project Context Analysis" \
+  "You are an expert AI systems architect..."
+
+echo "--> Exporting architectural components..."
+append_book_to_report "The Product (Core THEA Guidance)" "thea/"
+append_book_to_report "The Factory (Automation Framework & Environment)" "Taskfile.yml" ".github/" "factory/" ".idx/" ".vscode/"
+append_book_to_report "The Library (Project & Process Documentation)" "README.md" "CHANGELOG.md" "LICENSE" "CONTRIBUTING.md" "docs/"
+echo "✅ Full project export complete. Report saved to '$OUTPUT_FILE'."
```
