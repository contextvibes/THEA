---
id: "doc:lessons-learned/2025-06-13-repo-docs-frontmatter-exception"
fileExtension: "md"
title: "Lessons Learned: Front Matter Exceptions for GitHub-Rendered Files"
artifactVersion: "1.2.0"
status: "Active"
summary: "Documents the policy that core repository-facing documents (like any README.md, CONTRIBUTING.MD, etc.) must not contain YAML front matter to ensure correct rendering on GitHub."
usageGuidance:
  - "This document clarifies key exceptions to the THEA metadata policy."
  - "Refer to this when auditing documentation standards to understand which files are intentionally excluded from indexing."
owner: "Canon, Scribe"
createdDate: "2025-06-13T04:41:00Z"
lastModifiedDate: "2025-06-13T04:50:00Z" # Updated time
tags:
  - "lessons-learned"
  - "documentation"
  - "standards"
  - "frontmatter"
  - "readme"
  - "github"
  - "policy"
---
# Lessons Learned: Front Matter Exceptions for GitHub-Rendered Files

**Date:** 2025-06-13
**Session Participants (Conceptual):** User, THEA Collective (AI)
**Related Artifacts:**
- `PBI-THEA-002`: Front Matter Audit and Update
- `thea/application-guides/guides/thea-metadata-authoring-guide.md`

## 1. Session Goal

The goal was to begin executing PBI-THEA-002 by applying standard THEA YAML front matter to the project's most critical documents.

## 2. Key Learning & Policy Decision

**Insight:** A critical policy distinction exists between "framework artifacts" (which require metadata for programmatic discovery) and "repository documents" (whose primary consumer is the GitHub UI).

**Decision (THEA Policy):** Files whose primary purpose is to be directly rendered by the GitHub interface **MUST NOT** contain YAML front matter. Including front matter breaks the standard UI rendering by displaying it as a raw code block.

This policy applies to, but is not limited to, the following conventional files:

-   **Any file named `README.md`**, regardless of its location in the repository.
-   The root `CHANGELOG.md`
-   The root `LICENSE` file
-   The root `.github/CONTRIBUTING.MD`

**Rationale:**
1.  **UI Rendering:** GitHub's UI is the primary consumer of these files, and it does not process front matter.
2.  **Implicit Context:** The function of these files is defined by universal convention. Their filename and location provide sufficient context for human developers navigating the repository.
3.  **Exclusion from Indexing:** As a consequence, these files will be intentionally excluded from the `thea-manifest.json` index.

This policy ensures our repository remains clean and professional while allowing our internal framework artifacts to be intelligently indexed.
