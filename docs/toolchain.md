# Project Toolchain

## 1. Philosophy: A Standardized, Declarative Workflow

Our development workflow is built upon a standardized, opinionated toolchain.
The primary goal is to automate common tasks, enforce quality and consistency,
and reduce the cognitive load on developers by favoring declarative
configuration over custom imperative scripts.

This document serves as the manifest for all tools used in this project. The
`.idx/dev.nix` file is the ultimate source of truth for what is installed.

## 2. The Tool Manifest

| Tool                   | Purpose                                                                                    | Key File(s) / Command(s)              |
| :--------------------- | :----------------------------------------------------------------------------------------- | :------------------------------------ |
| **Nix**                | **The Foundation.** Declaratively defines the entire reproducible development environment. | `.idx/dev.nix`                        |
| **Prettier**           | The official code and documentation formatter to ensure consistent style.                  | `.prettierrc.json`, `.prettierignore` |
| **`markdownlint`**     | A linter to enforce structural and stylistic rules in all Markdown documentation.          | `.markdownlint.jsonc`                 |
| **`contextvibes` CLI** | The primary high-level interface for orchestrating development workflows (future).         | `.contextvibes.yaml`                  |
