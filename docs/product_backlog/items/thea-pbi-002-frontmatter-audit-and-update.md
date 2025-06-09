---
# Hugo Standard Fields
title: "PBI: Ensure Standard THEA YAML Front Matter for All Core Markdown Artifacts"
date: 2025-06-09T18:00:00Z # Approximate creation time of this PBI
lastmod: 2025-06-09T18:00:00Z # Approximate creation time of this PBI
draft: false
type: "pbi"

description: "This Product Backlog Item (PBI) outlines the work required to audit, add, and update YAML front matter for all core THEA Markdown artifacts within the 'thea/' directory to ensure consistency, discoverability, and schema compliance after recent structural refactoring."

tags:
  - "documentation"
  - "metadata"
  - "frontmatter"
  - "refactor"
  - "quality-assurance"
  - "thea-core"
  - "maintenance"

params:
  schema_version: "pbi_hugo_thea_v1.2" # Assuming this is still the PBI frontmatter schema
  pbi_id: "THEA-PBI-002"
  status: "To Do" # Initial status
  priority: "Medium" # Can be adjusted
  github_issue_url: "" # Placeholder - Link to a GitHub issue if one is created to track this PBI

  personas_involved:
    - name: Canon
      role: Standards Principal (Lead Reviewer)
    - name: Scribe
      role: Technical Writer (Lead Reviewer)
    - name: Logos
      role: AI Documentation Architect (Consultant)
    - name: Athena
      role: AI Strategy Lead (Oversight)
    - name: User # The developer implementing this PBI
      role: Developer

  primary_thea_artifacts_affected:
    - "doc:thea/**/*.(md|MD)" # Pattern indicating all Markdown files under thea/
    - "doc:thea/foundations/base-schemas/thea-artifact-metadata-schema.json" # Reference schema
    - "doc:thea/foundations/manuals/thea-metadata-authoring-guide.md" # Guidance doc (path to be confirmed post-rename)
    - "doc:thea/thea-manifest.json" # Will be impacted by updated metadata

  # target_sprint: "Sprint YYYY-SXX" # Optional
---

## 1. PBI Goal & Justification

**Goal:** To ensure all core THEA Markdown artifacts located within the `thea/` directory (and its subdirectories) possess complete, accurate, and standardized YAML front matter, conforming to the `thea-artifact-metadata-schema.json`.

**Justification:**
Following a significant structural refactoring of the `thea/` directory (IA Proposal 2 implementation) and a filename standardization pass, a systematic audit and update of YAML front matter is crucial. Correct front matter is essential for:
*   Consistent artifact versioning and status tracking.
*   Accurate machine-readability by `ContextVibes CLI` (especially the `index` command for `thea-manifest.json`).
*   Enhanced discoverability by both human users and AI assistants like the THEA Collective.
*   Maintaining the integrity and professionalism of the THEA framework.

## 2. Detailed Scope & Deliverables

*   **Scope:** All `.md` files within the `thea/` directory tree intended to be formal THEA artifacts (guides, playbooks, research papers, concepts, persona profiles, etc.). This excludes non-Markdown files or Markdown files not considered formal, versioned THEA artifacts (e.g., very temporary scratch notes if any were in `thea/`).
*   **Deliverables:**
    1.  Updated `.md` files within `thea/` with correct and complete YAML front matter.
    2.  Confirmation that `contextvibes index` runs successfully and `thea/thea-manifest.json` reflects the updated metadata accurately.
    3.  A Pull Request containing all front matter changes.

## 3. Acceptance Criteria

*   **AC1:** All `.md` files identified as THEA artifacts within the `thea/` directory possess a valid YAML front matter block.
*   **AC2:** All front matter blocks conform to `thea/foundations/base-schemas/thea-artifact-metadata-schema.json`.
*   **AC3:** The `id` field in each front matter accurately reflects the file's final path (post-refactor and post-rename) and unique identity (e.g., `thea:foundations/concepts/what-is-thea`).
*   **AC4:** Fields `title`, `summary`, `owner`, `tags`, and `usageGuidance` are populated with meaningful, accurate, and standardized information.
*   **AC5:** Fields `artifactVersion`, `status`, `createdDate`, and `lastModifiedDate` are correctly set for each artifact. `lastModifiedDate` reflects the date of this update.
*   **AC6:** The `fileExtension` field is consistently `"md"`.
*   **AC7:** The `contextvibes index` command successfully generates/updates `thea/thea-manifest.json` without errors, and the manifest accurately reflects the metadata of the updated files.
*   **AC8:** The Pull Request with these changes is reviewed and approved by `Canon` and `Scribe`.

## 4. Out of Scope

*   Modifying the content of the Markdown files beyond their front matter (unless a title in the body needs to match the front matter `title`).
*   Updating links *within* the content of these files (this is a separate, larger task, though some minor link corrections in front matter `summary` or `usageGuidance` might occur).
*   Adding front matter to files outside the `thea/` directory in this PBI (unless specified as a dependency).
*   Changing the `thea_artifact_metadata_schema.json` itself (that would be a separate PBI).

## 5. Notes & Open Questions

*   The `thea/foundations/manuals/thea-metadata-authoring-guide.md` (path to be confirmed after its own filename standardization) should be the primary reference for how to write *good quality* content for fields like `summary`, `tags`, and `usageGuidance`.
*   A script or checklist might be useful to systematically track which files have been processed.
*   Consider if `artifactVersion` should be reset to `0.1.0` or `1.0.0` for all files as part of this "clean slate" refactor, or if existing versions should be incremented. (Decision: `Canon`/`Orion` - for now, assume new files get `0.1.0`, existing files being updated get a patch bump if only metadata changes, or minor if content was also adjusted for the new structure).
