# THEA (Tooling & Heuristics for Efficient AI-Development) - v0.2.0

Welcome to THEA, an AI guidance system designed to enhance developer productivity by providing intelligent tooling and actionable heuristics. This repository is the central hub for THEA's core guidance artifacts, its supporting documentation, and the research that informs its intelligence.

THEA's guidance is consumed by **ContextVibes** (a separate system) to provide AI-assisted development features directly within the developer's environment.

## 1. Purpose of THEA

THEA aims to:

*   **Standardize AI Interaction:** Provide clear, versioned guidelines, rules, and prompt templates for effective and consistent collaboration with AI development assistants.
*   **Promote Best Practices:** Embody and disseminate best practices for software development, documentation, and security through its curated prompts and heuristics.
*   **Enhance Developer Experience:** By providing structured and intelligent guidance to ContextVibes, THEA helps streamline development workflows and reduce cognitive load.

## 2. How THEA's Guidance is Used

Conceptually, the workflow is as follows:

1.  **THEA Defines:** The core guidance (prompts, schemas, heuristics, playbooks) is defined within the `thea/` directory of this repository.
2.  **ContextVibes Consumes:** The ContextVibes engine (in its separate repository) is designed to fetch, parse, and interpret THEA's guidance artifacts.
3.  **Developers Interact:** Developers using an IDE integrated with ContextVibes receive AI-powered suggestions, code generation, and analysis, all shaped by THEA's underlying guidance.

## 3. Navigating This Repository

This repository is organized using a **"Product, Library, Factory"** model to ensure a clear separation of concerns. Every top-level directory has a distinct purpose.

---

### The Product: `thea/`

This is the primary, deliverable artifact of the repository. It contains the structured guidance that is consumed by the ContextVibes system.

*   **Concept:** What we ship.
*   **Audience:** Guidance Authors, Content Contributors.
*   **Details:** See the `thea/README.md` for a full breakdown of its contents.

---

### The Library: `docs/`

This is the internal knowledge base for the project itself. It contains documentation about our development process, our history, our research, and our plans.

*   **Concept:** How we work and what we've learned.
*   **Audience:** Project Managers, Process Analysts, and the core development team.
*   **Details:** See the `docs/README.md` for a full breakdown of its contents.

---

### The Factory: `factory/`

This is the complete, self-contained automation framework used to build, test, and manage this project.

*   **Concept:** How we build.
*   **Audience:** Tooling and Automation Engineers.
*   **Details:** See the `factory/scripts/README.md` for an explanation of the automation philosophy.

---

### Root-Level Files

The files in the root directory serve as the primary entry points to the project:

*   **`Taskfile.yml`**: The public API for the automation framework. It is a simple, stable facade that delegates all commands to the `factory/`.
*   **`README.md`**: This file. The front door and high-level guide to the project.
*   **`.github/`**: Community interaction files, including issue/PR templates and `CONTRIBUTING.MD`.

## 4. Contributing to THEA

THEA is an evolving system, and contributions are welcome! Please see `.github/CONTRIBUTING.MD` for detailed guidelines on how to contribute to this framework.

## 5. Continuous Improvement & Lessons Learned

This framework is a living entity. We are committed to continuous improvement by systematically capturing lessons learned and feeding valuable insights back into our guidance, playbooks, and processes.

![THEA Continuous Improvement Cycle](factory/.idx/icon.png)
*(Note: The diagram path may need to be updated after the factory refactoring)*

This cycle ensures that practical needs identified during development feed back into enhancing both our core tooling (`factory/`) and our foundational guidance (`thea/`), leading to progressively more powerful and efficient development workflows.
