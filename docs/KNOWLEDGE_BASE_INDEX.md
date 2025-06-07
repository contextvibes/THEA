# Knowledge Base Index for THEA & AI-Assisted Development Framework

Version: 0.1.0 *(User: Version might need updating if significant changes like this are made)*

## Purpose

This document serves as the central, curated index to our organization's collected knowledge, key learnings, best practices, guides, and important reference materials related to THEA and the broader `ai-assisted-dev-framework`.

Its primary goal is to make valuable information easily discoverable and accessible to all team members.

## Updating This Index

As part of our **Lessons Learned & Knowledge Capture Process** (detailed in `docs/process/AGILE_FRAMEWORK_DEVELOPMENT.MD`), this Knowledge Base Index is a living document.

When new learning resources (e.g., guides, tooling examples, playbook updates, significant research findings) are created or updated based on captured lessons:

* `Canon` and `Scribe` are responsible for ensuring this index is updated with:
  * A clear **Subject/Title** of the resource.
  * Relevant **Keywords** for searchability.
  * A direct **Link** to the detailed document, playbook, or artifact.
  * A brief **Summary** of the resource's content or the learning it captures.

## Index Categories

*(This section will be populated by @Canon and @Scribe with categorized links to actual knowledge assets. Example categories and the new entry are shown below.)*

* **THEA - Core Concepts & Architecture**
  * `README.MD` - Main overview, purpose, navigation, and core principles of THEA.
  * `docs/team/TEAM_HANDBOOK.MD` - Team operating philosophy, core roles, and responsibilities.
  * *(Placeholder: [Link to THEA Vision Doc] - [Summary])*

* **THEA - Prompt Engineering & Heuristic Design**
  * `docs/meta-prompts/prompt-to-write-better-prompts.md` - Guide and embedded "Gemini Prompting Guide" for crafting effective LLM prompts and System Instructions.
  * `thea/prompts/` - Directory for standardized prompt templates.
  * `thea/heuristics/` - Directory for actionable heuristic rules.
  * `thea/schemas/` - Directory for schemas defining prompts and heuristics.
  * *(Placeholder: [Link to Prompt Design Playbook] - [Summary])*

* **THEA - Firebase Studio Template Development**
  * `thea/firebase_studio_templates/SCHEMAS/firebase_template_manifest_schema.json` - (Stub) Schema for Firebase Studio template manifests.
  * `thea/firebase_studio_templates/PLAYBOOKS/designing_thea_aligned_firebase_templates.md` - (Stub) Playbook for designing THEA-aligned Firebase templates.
  * `thea/firebase_studio_templates/EXAMPLES/` - (Stub) Directory for example Firebase Studio templates.
  * `thea/firebase_studio_templates/EMBEDDED_AIRULES_TEMPLATES/` - (Stub) Directory for `airules.md` templates to be embedded in Firebase Studio templates.

* **THEA - Contribution & Development Process**
  * `.github/CONTRIBUTING.MD` - How to contribute to THEA, including proposing changes and sharing lessons learned.
  * `docs/process/AGILE_FRAMEWORK_DEVELOPMENT.MD` - Details on THEA's Scrum-based development process and lessons learned integration.
  * `playbooks/process_guidance/capturing_lessons_with_ai_via_documents.md` - Playbook detailing the user-mediated flow for capturing lessons learned with AI collaboration.
  * **[NEW] `playbooks/process_guidance/managing_thea_diagrams.md` - Playbook for creating, storing, and maintaining THEA project diagrams using tools like diagrams.net (Draw.io). [NEW]**
  * `docs/product_backlog/items/` - Directory containing detailed Product Backlog Item specifications.

* **THEA - Tooling & Integrations**
  * `docs/integrations/CONTEXTVIBES_COLLABORATION.md` - Strategy for collaboration and feedback regarding the `ContextVibes CLI`.
  * `.idx/dev.nix` - Nix environment configuration for THEA development in Firebase Studio.

* **THEA - Research & Lessons Learned**
  * `docs/lessons_learned_sessions/` - Directory for capturing reflections and outcomes from specific lessons learned sessions.
  * `docs/research_findings/` - Directory for research findings informing THEA.
  * `research/` - General directory for research materials.

* **Go Language - Best Practices & Patterns**
  * `research/go-best-practices/go-client.md` - Research on idiomatic Go client constructor patterns.
  * *(Placeholder: [Link to other Go best practices] - [Summary])*

* **Dataform & BigQuery - Best Practices**
  * `playbooks/ai_guidance/dataform_formatting_rules.md` - Specific formatting rules for Dataform queries.
  * *(Placeholder: [Link to other Dataform/BQ best practices] - [Summary])*

* **AI Guidance Examples (Specific Rulesets)**
  * `playbooks/ai_guidance/go_core_airules.md` - Core AI rules for general Go projects.
  * `playbooks/ai_guidance/pulumi_ai_rules.md` - AI rules for Pulumi Go GCP Infrastructure.

* **General Project Playbooks**
    * `playbooks/project_initiation/AI_PROJECT_BRIEF_TEMPLATE.md` - Template for defining project specifics for AI collaboration.
    * *(Placeholder: [Link to Project Retrospectives Playbook] - [Summary])*

* **Glossary**
  * `docs/GLOSSARY.MD` - Organizational glossary of terms.

---
*(This index is managed by @Canon and @Scribe.)*