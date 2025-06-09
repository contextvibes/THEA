{ pkgs, ... }:
{
  channel = "stable-25.05";
  
  packages = with pkgs; [
    # --- Core Development & Workflow ---
    go
    gotools
    git # Version control system

    # --- Utilities --
    gh
    tree # Directory structure viewer
    nodejs # Added for markdownlint-cli and general node tooling
    nodePackages.markdownlint-cli
  ];

  env = {
    # No global environment variables defined for the workspace itself
  };

  idx = {
    extensions = [
      "golang.go"
      "GitHub.vscode-pull-request-github"
      "DavidAnson.vscode-markdownlint"
    ];

    workspace = {
      onCreate = {
        # Script to install contextvibes CLI into ./bin
        installContextVibesCli = ''
          echo "Attempting to install contextvibes CLI into ./bin ..."

          if ! command -v go &> /dev/null
          then
              echo "Go command could not be found, skipping contextvibes installation."
              # Exit gracefully or 'exit 1' if critical
              # For now, we'll assume Go is present due to pkgs.go
          else
            LOCAL_BIN_DIR="$(pwd)/bin"
            mkdir -p "$LOCAL_BIN_DIR"
            echo "Target directory for contextvibes: $LOCAL_BIN_DIR"

            export GOBIN="$LOCAL_BIN_DIR"
            echo "Running: GOBIN=$GOBIN go install github.com/contextvibes/cli/cmd/contextvibes@latest"

            if go install github.com/contextvibes/cli/cmd/contextvibes@v0.2.0; then
              echo "Successfully installed contextvibes to $LOCAL_BIN_DIR/contextvibes"
              echo "You can run it using: $LOCAL_BIN_DIR/contextvibes"
              echo "Consider adding '$LOCAL_BIN_DIR' to your PATH for convenience (see README)."
              chmod +x "$LOCAL_BIN_DIR/contextvibes" || echo "Note: chmod +x on contextvibes failed."
            else
              echo "ERROR: Failed to install contextvibes."
            fi
            unset GOBIN
          fi
        '';
      };

      onStart = {
        checkContextVibes = ''
          echo "Checking for ContextVibes CLI in ./bin ..."
          WORKSPACE_BIN_DIR="$(pwd)/bin" 
          CONTEXTVIBES_EXE="$WORKSPACE_BIN_DIR/contextvibes"

          if [ -f "$CONTEXTVIBES_EXE" ]; then
            VERSION_OUTPUT="$("$CONTEXTVIBES_EXE" version 2>&1)"
            if [ $? -eq 0 ]; then
              CLEAN_VERSION=$(echo "$VERSION_OUTPUT" | grep "Version:" | sed 's/.*Version: //')
              echo "ContextVibes CLI found. Version: $CLEAN_VERSION"
            else
              echo "ContextVibes CLI found in ./bin, but 'version' command failed. Output: $VERSION_OUTPUT"
            fi
          else
            echo "ContextVibes CLI not found in $WORKSPACE_BIN_DIR. Run 'onCreate' hook or install manually if needed."
          fi
        '';
      };
    };

    previews = {
      enable = false;
    };
  };
}
