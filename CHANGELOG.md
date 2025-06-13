# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- 

### Changed
- 

### Fixed
- 

## [v0.2.0] - 2025-06-13

### Added
- **New Governance Playbooks:** Created a comprehensive set of playbooks for core team processes, including:
  - `contribution-and-improvement-playbook.md`: Defines the end-to-end process for community and team contributions.
  - `puzzle-assembly-playbook.md`: Establishes the "Puzzle Philosophy" for understanding the ContextVibes ecosystem.
  - `ai-led-research-playbook.md`: Formalizes the process for commissioning research to inform the framework.
- **New Lessons Learned Process:** Implemented a formal process for capturing key insights, with initial documents on documentation standards and front matter exceptions.

### Changed
- **Metadata Overhaul:** Audited and updated the YAML front matter for nine core framework documents to ensure full compliance with `thea-artifact-metadata-schema.json`, significantly improving the framework's machine-readability for AI tools.
- **Contribution Guidelines:** Refined `CONTRIBUTING.MD` to align with the new, issue-driven contribution playbook.
- **Policy Establishment:** Formalized the policy to exclude repository-facing documents (like `README.md` and `CONTRIBUTING.MD`) from front matter indexing to ensure proper rendering on GitHub.

### Fixed
- **Inconsistent Metadata:** Corrected and completed metadata across numerous key documents, resolving inconsistencies and ensuring all required fields are present.

## [v0.1.0-alpha.1] - 2025-06-08

### Added
- **Initial Framework Documentation:** Created a comprehensive set of foundational documents, including guides, playbooks, and process definitions.
- **THEA Personas:** Defined the initial set of conceptual team personas (`Orion`, `Athena`, `Sparky`, etc.) in the `docs/team/` directory.
- **Dev Environment Standards:** Established a standard for managing `.idx/dev.nix` files in Firebase Studio and created `docs/contributor-guides/managing-dev-nix-environments.md`.
- **Lifecycle Hook Standards:** Created `docs/contributor-guides/managing-lifecycle-hooks.md` to document best practices for `onCreate` and `onStart`.
- **Artifact Metadata Standard:** Implemented a YAML front matter standard for all documentation and created `thea/schemas/thea_artifact_metadata_schema.json`.
- **Release Playbook:** Created `playbooks/process_guidance/framework-release-playbook.md` to standardize the release process.
- **Compliance Scans:** Added a mandatory pre-release compliance scan step to the release playbook to check for PII and historical comments.
- **Automated Formatting:** Established `markdownlint --fix` as the standard for ensuring documentation quality, documented in `playbooks/process_guidance/documentation-finalization-playbook.md`.

### Changed
- **System Instructions (`airules.md`):** Refactored the core system instructions to be language-agnostic and added an initial identity confirmation protocol to improve reliability.
- **File Naming Convention:** Established `lowercase-kebab-case` as the official standard for all new files.

### Fixed
- **Build Failures:** Resolved multiple Nix build failures by correcting syntax (trailing commas) in `dev.nix` files.
- **Markdown Linting:** Corrected numerous `markdownlint` errors across the entire repository to ensure all documents adhere to the defined standard.
