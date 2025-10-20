# .idx/dev.nix
#
# A reproducible development environment for the 'public-speaking' project.
{ pkgs, ... }:

let
  contextvibes = import ./contextvibes.nix { pkgs = pkgs; };
in
{
  channel = "stable-25.05";

  # ---------------------------------------------------------------------------
  # System Packages
  # ---------------------------------------------------------------------------
  packages = with pkgs; [
    # --- Core Development & Version Control ---
    git
    gh

    # --- Documentation, Formatting & Linting ---
    nodejs_22
    nodePackages.markdownlint-cli # The linter: enforces structural rules.
    nodePackages.prettier         # The formatter: enforces consistent style.

    # --- Command-Line Utilities ---
    tree

    # --- Project-Specific Tools ---
    contextvibes
  ];

  # ---------------------------------------------------------------------------
  # VS Code Extensions
  # ---------------------------------------------------------------------------
  idx.extensions = [
    # --- Version Control & GitHub Integration ---
    "GitHub.vscode-pull-request-github"

    # --- Markdown, Formatting & Linting ---
    "DavidAnson.vscode-markdownlint" # Integrates markdownlint into the editor.
    "esbenp.prettier-vscode"         # The official Prettier extension for auto-formatting.

    # --- Shell & Scripting ---
    "timonwong.shellcheck"
  ];
}
