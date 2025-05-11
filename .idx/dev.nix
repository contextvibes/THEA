{ pkgs, ... }:

let
  # Define the pinned version of ContextVibes CLI here for easy updating
  contextVibesVersion = "v0.1.1";
in
{
  channel = "stable-24.11";

  packages = [
    pkgs.go
    pkgs.gotools
    pkgs.golangci-lint
    pkgs.git
    pkgs.gh
    pkgs.tree
    pkgs.jq
    pkgs.nodejs # Added for markdownlint-cli and general node tooling
    pkgs.nodePackages.markdownlint-cli # Added for Markdown linting
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
        installContextVibesCli = ''
          echo "Attempting to install ContextVibes CLI (@${contextVibesVersion}) into ./bin ..."
          
          if ! go version > /dev/null 2>&1; then
              echo "ERROR: Go command not found or not working. Cannot install ContextVibes CLI."
              echo "Please ensure 'pkgs.go' is correctly configured in dev.nix."
              exit 1; 
          fi

          LOCAL_BIN_DIR="$(pwd)/bin"
          mkdir -p "$LOCAL_BIN_DIR"
          
          echo "Target directory for contextvibes: $LOCAL_BIN_DIR"
          echo "Attempting to install: github.com/contextvibes/cli/cmd/contextvibes@${contextVibesVersion}"

          if GOBIN="$LOCAL_BIN_DIR" go install "github.com/contextvibes/cli/cmd/contextvibes@${contextVibesVersion}"; then
            echo "Successfully installed contextvibes@${contextVibesVersion} to $LOCAL_BIN_DIR/contextvibes"
            if [ -f "$LOCAL_BIN_DIR/contextvibes" ]; then
              chmod +x "$LOCAL_BIN_DIR/contextvibes" || echo "Warning: chmod +x on contextvibes failed."
            else
              echo "ERROR: contextvibes binary not found at $LOCAL_BIN_DIR/contextvibes after successful 'go install' message."
            fi
          else
            echo "ERROR: Failed to install contextvibes@${contextVibesVersion}."
            echo "Please check Go environment, network connectivity, and the specified CLI version."
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
