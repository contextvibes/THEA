---
id: "thea:README"
fileExtension: "md"
title: "THEA Core Framework Overview (Contents of thea/)"
artifactVersion: "0.1.0"
status: "Active"
summary: "Provides an overview of the subdirectories and purpose of the core THEA framework assets located within the 'thea/' directory."
usageGuidance:
  - "Use this document as the primary entry point to understand the structure and contents of the 'thea/' directory."
  - "Refer to this for high-level descriptions of prompts, schemas, playbooks, research, and other core THEA artifacts."
owner: "Scribe, Canon"
createdDate: "2025-06-09T15:00:00Z" # Updated to reflect approximate creation time
lastModifiedDate: "2025-06-09T15:00:00Z" # Updated to reflect approximate creation time
tags:
  - "readme"
  - "thea-core"
  - "navigation"
  - "framework-overview"
  - "documentation"
---
# THEA Core Framework (`thea/`)

This directory contains the core intellectual property and distributable assets of the THEA (Tooling & Heuristics for Efficient AI-Development) guidance system. These artifacts are designed to be consumed by developers and AI assistants (like the THEA Collective and ContextVibes CLI) to enhance software development quality and efficiency.

The contents of this directory are versioned and intended to be packageable for consumption by other projects, typically via the `contextvibes thea init` command. Further refactoring may consolidate additional THEA documentation and guides into this directory.

## Key Subdirectories

Below is an overview of the primary subdirectories currently within `thea/` and their purpose:

### 1. `prompts/`
   - **Purpose:** Contains standardized prompt templates for a variety of development tasks, languages, and AI models. These are designed to elicit high-quality responses from LLMs.
   - **Key Artifacts:** Individual `.md` files representing specific prompt templates.
   - **Consumption:** Used by AI assistants and developers to initiate AI-driven tasks.

### 2. `schemas/`
   - **Purpose:** Defines the structural contracts (in JSON Schema format) for THEA artifacts, including prompts, heuristics, and metadata (like the YAML front matter on THEA documents).
   - **Key Artifacts:** `.json` schema files (e.g., `thea_artifact_metadata_schema.json`).
   - **Consumption:** Used by `ContextVibes CLI` for validation, by `Logos` for maintaining structural integrity, and by developers contributing new artifacts.
   - **Further Reading:** Refer to `../../docs/manuals/thea_metadata_authoring_guide.md` for details on artifact metadata (note: path relative to `thea/README.md`).

### 3. `heuristics/`
   - **Purpose:** Provides actionable heuristic rules and guidelines that can inform AI analysis, code generation, or developer best practices.
   - **Key Artifacts:** `.md` files detailing specific heuristics, often with examples and rationale.
   - **Consumption:** Consumed by AI assistants to apply specific best practices or analytical lenses.

### 4. `playbooks/`
   - **Purpose:** Contains structured, step-by-step guides and processes for utilizing THEA effectively, contributing to THEA, or performing common THEA-related development workflows.
   - **Key Subdirectories:**
     - `ai_guidance/`: Playbooks specifically for guiding AI behavior (e.g., core Go rules, Dataform formatting).
     - `process_guidance/`: Playbooks for THEA's internal development processes and standards (e.g., managing diagrams, capturing lessons).
     - `project_initiation/`: Playbooks related to starting projects with THEA principles.
   - **Consumption:** Used by developers and the THEA team to ensure consistent application of processes.
   - **Further Reading:** Key playbooks include:
     - `[Playbook: Capturing Lessons Learned with AI Collaboration](playbooks/process_guidance/capturing_lessons_with_ai_via_documents.md)`
     - `[Playbook: AI-Facilitated Strategic Project Kickoff](playbooks/project_initiation/master_strategic_kickoff_prompt.md)`

### 5. `research/`
   - **Purpose:** Houses foundational research, experimental findings, and comparative analyses that underpin THEA's design choices, prompts, and heuristics.
   - **Key Subdirectories:**
     - `go-best-practices/`
     - `llm-prompting/`
     - `prompts/` (research *about* prompts, distinct from `thea/prompts/` which *are* the prompts themselves)
   - **Consumption:** Primarily for THEA contributors (`Athena`, `Logos`) to inform framework evolution, but summaries may be useful for users seeking deeper understanding. Note: Detailed archived research briefs are often found in `docs/research_findings/`.

### 6. `firebase_studio_templates/`
   - **Purpose:** Contains schemas, example templates, embedded `airules.md` templates, and playbooks specifically for guiding the creation and maintenance of THEA-aligned Firebase Studio project templates.
   - **Key Subdirectories:**
     - `EMBEDDED_AIRULES_TEMPLATES/`
     - `EXAMPLES/`
     - `PLAYBOOKS/` (e.g., `[Playbook: Designing THEA-Aligned Firebase Templates](firebase_studio_templates/PLAYBOOKS/designing_thea_aligned_firebase_templates.md)`)
     - `SCHEMAS/`
   - **Consumption:** Used by developers building new Firebase Studio project templates intended to work with THEA.

### 7. `rulesets/`
   - **Purpose:** Intended to hold collections or configurations of THEA artifacts (like prompts and heuristics) tailored for specific contexts, project types, or operational modes. (This area is subject to further definition and population).
   - **Key Artifacts:** Likely to include `.json`, `.yaml`, or structured `.md` files defining these curated sets.

## Artifact Manifest

An automated index of artifacts within this `thea/` directory (and potentially other designated THEA content areas) is generated by the `ContextVibes CLI index` command and stored in `thea/thea-manifest.json`. This manifest is primarily for machine consumption (e.g., by the THEA Collective AI) to discover and understand available THEA resources based on their metadata.

---
This `README.md` provides a human-friendly entry point to the core THEA framework assets consolidated within the `thea/` directory.
