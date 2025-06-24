{ pkgs, ... }:
{
  # Specifies the Nixpkgs channel to ensure a reproducible package set across machines.
  channel = "stable-25.05";

  # Defines the packages to be installed in the development environment.
  packages = with pkgs; [
    # --- Core Dependency for Tooling ---
    # The Go toolchain is required to build and install Go-based CLI tools,
    # such as the 'contextvibes' CLI installed in the onCreate hook below.
    go

    # --- Project Automation ---
    # A task runner that uses a 'Taskfile.yml' to automate common project commands.
    go-task

    # --- Code Quality & Linting ---
    nodejs # The JavaScript runtime, required by markdownlint-cli.
    nodePackages.markdownlint-cli # A linter to enforce standards in Markdown files.

    # --- Essential Utilities ---
    git # The version control system for managing source code.
    gh # The official GitHub CLI for interacting with GitHub from the terminal.
    tree # A utility to display directory structures.
    file # For inspecting file types (fixes the immediate error)
    shellcheck # To find bugs and errors in shell scripts
    shfmt # To automatically format shell scripts

    # --- Interactive UI/Menus ---
    gum # For creating beautiful, modern interactive menus and prompts

    # --- Data Processing  ---
    jq # The standard tool for parsing and handling JSON
    yq # The standa
  ];

  # Sets global environment variables for the Nix shell. This is empty for now.
  env = { };

  # Configures the IDX workspace environment.
  idx = {
    # Specifies VS Code extensions to install automatically for a better IDE experience.
    extensions = [
      # Provides syntax highlighting and management features for Dockerfiles.
      "ms-azuretools.vscode-docker"

      # Integrates GitHub pull requests and issues directly into the editor.
      "GitHub.vscode-pull-request-github"

      # Lints Markdown files to ensure consistent formatting.
      "DavidAnson.vscode-markdownlint"
    ];

    # Defines lifecycle hooks that run at different stages of the workspace's life.
    workspace = {
      # Runs only ONCE when the workspace is first created to handle initial setup.
      onCreate = {
        installContextVibesCli = ''
          # This script installs a project-specific tool not available in Nixpkgs.
          echo ">>> Setting up ContextVibes CLI..."
          LOCAL_BIN_DIR="$(pwd)/bin"
          mkdir -p "$LOCAL_BIN_DIR"
          
          # Use GOBIN to direct 'go install' to the local ./bin directory.
          export GOBIN="$LOCAL_BIN_DIR"
          echo "Installing contextvibes@v0.2.0 into $GOBIN..."
          
          # Install a specific, known-good version for reproducibility.
          if go install github.com/contextvibes/cli/cmd/contextvibes@v0.2.0; then
            echo "✅ Successfully installed contextvibes to $GOBIN/contextvibes"
            chmod +x "$GOBIN/contextvibes"
          else
            # Provide a clear, actionable error message on failure.
            echo "❌ ERROR: Failed to install contextvibes. Check Go environment and network."
            exit 1 # Halt further onCreate scripts on failure.
          fi
          
          unset GOBIN
        '';
      };

      # Runs EVERY TIME the workspace is started to validate the environment.
      onStart = {
        checkContextVibes = ''
          # This script validates that the ContextVibes CLI is installed and executable.
          echo ">>> Verifying ContextVibes CLI installation..."
          EXE_PATH="$(pwd)/bin/contextvibes"

          # Verify that the executable file exists.
          if [ ! -f "$EXE_PATH" ]; then
            echo "⚠️ ContextVibes CLI not found at $EXE_PATH. Run the 'onCreate' hook if this is a new workspace."
            exit 1
          fi

          # Verify that the file has execute permissions.
          if [ ! -x "$EXE_PATH" ]; then
            echo "❌ ERROR: Found contextvibes at $EXE_PATH, but it is not executable. Attempting to fix..."
            chmod +x "$EXE_PATH" || exit 1
          fi

          # Verify that the tool is functional by running its version command.
          if VERSION_OUTPUT=$("$EXE_PATH" version); then
            echo "✅ ContextVibes CLI is ready. Version: $VERSION_OUTPUT"
          else
            echo "❌ ERROR: ContextVibes CLI is present but the 'version' command failed."
            exit 1
          fi
        '';
      };
    };

    # Configures web previews for the workspace.
    previews = {
      # Previews are disabled as this is primarily a CLI-focused environment.
      enable = false;
    };
  };
}
