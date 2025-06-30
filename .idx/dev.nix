# This file defines the development environment for a Firebase Studio workspace using Nix.
# It specifies all the packages, services, and editor extensions needed for the project.
{ pkgs, ... }:

let
  # Imports the custom Nix derivation for the 'contextvibes' tool from a separate file.
  # This declarative approach makes the tool a first-class package in the environment,
  # which is more reproducible and cacheable than installing it with an imperative script.
  contextvibes = import ./contextvibes.nix { pkgs = pkgs; };
in
{
  # Specifies the Nixpkgs channel to use. Pinning to a specific channel like "stable-25.05"
  # ensures that everyone on the team gets the exact same package versions, leading to a
  # highly reproducible environment.
  channel = "stable-25.05";

  # Defines the packages to be installed in the development environment.
  # Packages are grouped by function for better readability.
  packages = with pkgs; [
    # --- Core Language Toolchains ---
    go # The Go compiler and toolchain.
    gopls # The official Go language server for IDE features.
    delve # The standard debugger for Go.
    nodejs # The JavaScript runtime, required for some linters.

    # --- Project Automation & Task Running ---
    go-task # A task runner that uses 'Taskfile.yml' to automate common commands.

    # --- Code Quality & Formatting ---
    shellcheck # Linter for finding bugs in shell scripts.
    shfmt # Auto-formatter for shell scripts.
    nodePackages.markdownlint-cli # Linter to enforce standards in Markdown files.

    # --- Data Processing & CLI Tools ---
    jq # A command-line JSON processor.
    yq-go # A portable command-line YAML processor (Go version).
    gum # A tool for creating glamorous shell scripts and interactive menus.

    # --- Version Control & Essential Utilities ---
    git # The version control system for managing source code.
    gh # The official GitHub CLI for interacting with GitHub.
    tree # A utility to display directory structures as a tree.
    file # A utility to determine file types.

    # --- Custom Project Tools ---
    contextvibes # The custom-built 'contextvibes' CLI tool, managed by its own Nix file.
  ];

  # Sets global environment variables for the Nix shell.
  env = { };

  # Configures the IDX workspace environment.
  idx = {
    # Specifies VS Code extensions to install automatically.
    # This ensures a consistent and fully-featured editor experience for all developers.
    extensions = [
      # --- Core Language & Framework Support ---
      "golang.go" # Official Go language support.
      "task.vscode-task" # Adds support for Go Task ('Taskfile.yml').

      # --- Code Quality & Linting ---
      "DavidAnson.vscode-markdownlint" # Integrates markdownlint into the editor.
      "timonwong.shellcheck" # Integrates shellcheck for live linting of shell scripts.

      # --- Version Control ---
      "GitHub.vscode-pull-request-github" # Integrates GitHub PRs and issues.
      "eamodio.gitlens" # Supercharges the Git capabilities built into VS Code.
    ];
  };

  # Note on Lifecycle Hooks (`onCreate`, `onStart`):
  # This configuration intentionally omits lifecycle hooks for package installation,
  # preferring the declarative `packages` list. This Nix-native approach ensures
  # reproducibility and leverages caching for faster workspace startups.
  #
  # Hooks can still be useful for one-time actions, like initializing a project or
  # displaying a welcome message. For example:
  #
  # idx.workspace.onCreate = [
  #   ''
  #     echo "Welcome to the project! Your tools are ready." | gum format -t "code"
  #     echo "Run 'task --list' to see available commands." | gum format -t "code"
  #   ''
  # ];
}
