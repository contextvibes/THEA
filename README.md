# THEA (Tooling & Heuristics for Efficient AI-Development) - v0.1.0 (Foundational Setup)

Welcome to THEA, an AI guidance system designed to enhance developer productivity by providing intelligent tooling and actionable heuristics. This repository is the central hub for THEA's core guidance artifacts (prompts, heuristic rules, schemas), its supporting documentation, and the research that informs its intelligence.

THEA's guidance is consumed by **ContextVibes** (a separate system) to provide AI-assisted development features directly within the developer's environment.

## 1. Purpose of THEA

THEA aims to:

* **Standardize AI Interaction:** Provide clear, versioned guidelines, rules, and prompt templates for effective and consistent collaboration with AI development assistants.
* **Promote Best Practices:** Embody and disseminate best practices for software development (initially focusing on Go), documentation, and security through its curated prompts and heuristics.
* **Enhance Developer Experience:** By providing structured and intelligent guidance to ContextVibes, THEA helps streamline development workflows and reduce cognitive load.
* **Foster Quality & Consistency:** Encourage high-quality, consistent code and documentation by providing standardized AI-driven assistance.

## 2. How THEA's Guidance is Used

Conceptually, the workflow is as follows:

1. **THEA Defines:** This repository contains THEA's "intelligence" – structured prompts, heuristic rules, and schemas.
2. **ContextVibes Consumes:** The ContextVibes engine (in its separate repository) is designed to fetch, parse, and interpret THEA's guidance artifacts.
3. **Developers Interact:** Developers using an IDE integrated with ContextVibes receive AI-powered suggestions, code generation, and analysis, all shaped by THEA's underlying guidance.
4. **Iterative Improvement:** THEA's guidance is designed to be versioned and improved over time based on feedback and new research.

For more details on specific integrations, refer to the ContextVibes documentation and guides within this repository's `docs/` section.

## 3. Navigating This Repository

Key components are organized as follows:

* **`thea/`**: The core of THEA. Contains the actual guidance artifacts:
  * `prompts/`: Standardized prompt templates for various coding tasks and languages.
  * `heuristics/`: Actionable heuristic rules that can trigger analysis or suggestions.
  * `schemas/`: Definitions for the structure of prompts and heuristics, ensuring consistency.
* **`docs/`**: All project documentation for THEA, including:
  * User guides on understanding and leveraging THEA's guidance.
  * Architectural overviews of THEA.
  * Ethical guidelines for THEA's development and use.
  * (Link to Team Handbook & Personas, e.g., `docs/team/TEAM_HANDBOOK.MD`)
* **`research/`**: Research findings, papers, and experimental results that inform the design of THEA's prompts and heuristics. (Curated by @Logos)
* **`playbooks/`**: Processes, templates, and best practices for *creating and contributing to* THEA's guidance artifacts.
* **`scripts/`**: Utility scripts for managing or validating THEA's artifacts (e.g., `scripts/dev_utils.sh`).
* **`.idx/`**: Firebase Studio configuration tailored for contributors working on THEA's artifacts (e.g., `airules.md` for AI assistance *during* THEA development, `dev.nix`).
* **`.github/`**: GitHub specific files, including issue templates, PR templates (`CONTRIBUTING.MD` is also here).

## 4. Contributing to THEA

THEA is an evolving system, and contributions are welcome! Whether it's suggesting new prompts, refining heuristics, improving documentation, or sharing research, your input is valuable.

Please see `CONTRIBUTING.MD` (in the `.github/` directory) for detailed guidelines on how to contribute. THEA's development follows agile principles, and we adhere to the "Think Big, Start Small, Learn Fast" philosophy.

## 5. Core Principles

* **Think Big, Start Small, Learn Fast:** We embrace ambitious goals while prioritizing iterative development and rapid learning.
* *(Other core principles can be added here or linked to a dedicated document)*

---
*This THEA README is managed by @Scribe and @Canon, with strategic guidance from @Orion and @Athena. Technical review for ContextVibes integration by @Kernel.*

## 6. Continuous Improvement & Lessons Learned

This framework is a living entity. We are committed to continuous improvement by:

* Systematically capturing lessons learned during project execution and framework development.
* Feeding valuable insights back into THEA's guidance, our playbooks, and overall processes.
* Fostering a culture where knowledge sharing drives our evolution.
*(Refer to `docs/process/AGILE_FRAMEWORK_DEVELOPMENT.MD` and `CONTRIBUTING.MD` for more on how insights are captured and integrated.)*
