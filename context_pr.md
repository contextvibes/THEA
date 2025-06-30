# AI Prompt: Generate Pull Request Description

## Your Role & Task
You are an expert software engineer writing a clear and comprehensive description for a pull request. Analyze the following git commit history and aggregated diff for the entire feature branch against the `main` branch. Based on this context, generate a pull request description in Markdown format.

---

## Commit History on This Branch
```
5addb3c refactor(automation): Implement Factory, Library, Product architecture (development, 6 days ago)
1be0175 refactor(automation): Implement Factory, Library, Product architecture (development, 6 days ago)
02148a3 refactor(automation): Isolate framework into factory/ directory (development, 6 days ago)```

---
## Full Diff for Branch (vs. main)
```diff
diff --git a/.idx/dev.nix b/.idx/dev.nix
index 96cf549..0d908ea 100644
--- a/.idx/dev.nix
+++ b/.idx/dev.nix
@@ -19,10 +19,19 @@
     nodePackages.markdownlint-cli # A linter to enforce standards in Markdown files.
 
     # --- Essential Utilities ---
-    git  # The version control system for managing source code.
-    gh   # The official GitHub CLI for interacting with GitHub from the terminal.
-    jq   # A command-line JSON processor, useful for scripting.
+    git # The version control system for managing source code.
+    gh # The official GitHub CLI for interacting with GitHub from the terminal.
     tree # A utility to display directory structures.
+    file # For inspecting file types (fixes the immediate error)
+    shellcheck # To find bugs and errors in shell scripts
+    shfmt # To automatically format shell scripts
+
+    # --- Interactive UI/Menus ---
+    gum # For creating beautiful, modern interactive menus and prompts
+
+    # --- Data Processing  ---
+    jq # The standard tool for parsing and handling JSON
+    yq # The standa
   ];
 
   # Sets global environment variables for the Nix shell. This is empty for now.
diff --git a/README.md b/README.md
index 5fa4cce..0fffd6a 100644
--- a/README.md
+++ b/README.md
@@ -8,74 +8,71 @@ THEA's guidance is consumed by **ContextVibes** (a separate system) to provide A
 
 THEA aims to:
 
-* **Standardize AI Interaction:** Provide clear, versioned guidelines, rules, and prompt templates for effective and consistent collaboration with AI development assistants.
-* **Promote Best Practices:** Embody and disseminate best practices for software development (initially focusing on Go), documentation, and security through its curated prompts and heuristics.
-* **Enhance Developer Experience:** By providing structured and intelligent guidance to ContextVibes, THEA helps streamline development workflows and reduce cognitive load.
-* **Foster Quality & Consistency:** Encourage high-quality, consistent code and documentation by providing standardized AI-driven assistance.
-* **Guide Firebase Studio Template Development:** Provide principles, artifacts (schemas, playbooks, example `airules.md`), and AI assistance for crafting high-quality, THEA-aligned Firebase Studio project templates.
+*   **Standardize AI Interaction:** Provide clear, versioned guidelines, rules, and prompt templates for effective and consistent collaboration with AI development assistants.
+*   **Promote Best Practices:** Embody and disseminate best practices for software development, documentation, and security through its curated prompts and heuristics.
+*   **Enhance Developer Experience:** By providing structured and intelligent guidance to ContextVibes, THEA helps streamline development workflows and reduce cognitive load.
 
 ## 2. How THEA's Guidance is Used
 
 Conceptually, the workflow is as follows:
 
-1. **THEA Defines:** The core guidance (prompts, schemas, heuristics, playbooks, core docs, research) is defined within the `thea/` directory of this repository.
-2. **ContextVibes Consumes:** The ContextVibes engine (in its separate repository) is designed to fetch, parse, and interpret THEA's guidance artifacts.
-3. **Developers Interact:** Developers using an IDE integrated with ContextVibes receive AI-powered suggestions, code generation, and analysis, all shaped by THEA's underlying guidance.
-4. **Iterative Improvement:** THEA's guidance is designed to be versioned and improved over time based on feedback and new research.
-
-For more details on specific integrations, refer to the ContextVibes documentation and guides within `thea/integrations/` or `thea/application-guides/`.
+1.  **THEA Defines:** The core guidance (prompts, schemas, heuristics, playbooks) is defined within the `thea/` directory of this repository.
+2.  **ContextVibes Consumes:** The ContextVibes engine (in its separate repository) is designed to fetch, parse, and interpret THEA's guidance artifacts.
+3.  **Developers Interact:** Developers using an IDE integrated with ContextVibes receive AI-powered suggestions, code generation, and analysis, all shaped by THEA's underlying guidance.
 
 ## 3. Navigating This Repository
 
-Key components are organized as follows:
-
-*   **`thea/`**: **The heart of the THEA Framework.** This directory contains all core distributable assets:
-    *   `foundations/`: Core concepts, base schemas, foundational research, methodologies, and the THEA team model.
-    *   `building-blocks/`: Atomic, reusable assets like prompts, heuristics, meta-prompts, and artifact-specific schemas.
-    *   `application-guides/`: Playbooks, rulesets, user guides, and manuals on how to apply THEA.
-    *   `integrations/`: Assets and documentation for integrating THEA with specific tools, like Firebase Studio templates (under `firebase-studio/`).
-    *   `README.md`: Provides a detailed map and overview of the contents within the `thea/` directory.
-    *   `thea-manifest.json`: A machine-readable index of THEA artifacts, generated by `contextvibes index`.
-*   **`docs/`**: Contains documentation *about the development and maintenance of this THEA framework project itself*.
-    *   `contributor-guides/`: Guides for contributing to *this* repository.
-    *   `lessons_learned_sessions/`: Internal reflections on the THEA development process.
-    *   `process/`: Definitions of THEA's internal development processes (e.g., `agile-framework-development.md`).
-    *   `product_backlog/`: Detailed specifications for PBIs related to THEA's development.
-    *   `research_findings/`: Archived research briefs that *informed* THEA's creation (distinct from consumable research in `thea/foundations/research-papers/`).
-    *   `team_resources/`: Resources for the THEA development team.
-*   **`scripts/`**: Utility scripts for managing or validating THEA's artifacts or this repository (e.g., `scripts/dev_utils.sh`, scripts for batch renames). *(Note: Some may be deprecated/removed as functionality moves to ContextVibes CLI or is no longer needed.)*
-*   **`.idx/`**: Firebase Studio configuration tailored for contributors working on THEA itself (e.g., this project's `airules.md`, `dev.nix`).
-*   **`.github/`**: GitHub specific files, including issue templates, PR templates, and `CONTRIBUTING.MD`.
-*   **Root Files:** `README.MD` (this file), `CHANGELOG.MD`, `LICENSE`, `.gitignore`, `.markdownlint.jsonc`, `.contextvibes.yaml`.
+This repository is organized using a **"Product, Library, Factory"** model to ensure a clear separation of concerns. Every top-level directory has a distinct purpose.
 
-## 4. Contributing to THEA
+---
+
+### The Product: `thea/`
 
-THEA is an evolving system, and contributions are welcome! Whether it's suggesting new prompts, refining heuristics, improving documentation, or sharing research, your input is valuable.
+This is the primary, deliverable artifact of the repository. It contains the structured guidance that is consumed by the ContextVibes system.
 
-Please see `.github/CONTRIBUTING.MD` for detailed guidelines on how to contribute to this framework. THEA's development follows agile principles, and we adhere to the "Think Big, Start Small, Learn Fast" philosophy.
+*   **Concept:** What we ship.
+*   **Audience:** Guidance Authors, Content Contributors.
+*   **Details:** See the `thea/README.md` for a full breakdown of its contents.
 
-## 5. Core Principles
+---
+
+### The Library: `docs/`
 
-*   **Think Big, Start Small, Learn Fast:** We embrace ambitious goals while prioritizing iterative development and rapid learning.
-*   **Be Kind:** All interactions and contributions should align with our core operating principle of kindness and respectful collaboration.
-*   *(Other core principles can be added here or linked to a dedicated document, likely within `thea/foundations/concepts/`)*
+This is the internal knowledge base for the project itself. It contains documentation about our development process, our history, our research, and our plans.
+
+*   **Concept:** How we work and what we've learned.
+*   **Audience:** Project Managers, Process Analysts, and the core development team.
+*   **Details:** See the `docs/README.md` for a full breakdown of its contents.
 
 ---
-*This THEA README is managed by @Scribe and @Canon, with strategic guidance from @Orion and @Athena. Technical review for ContextVibes integration by @Kernel.*
 
-## 6. Continuous Improvement & Lessons Learned
+### The Factory: `factory/`
+
+This is the complete, self-contained automation framework used to build, test, and manage this project.
 
-This framework is a living entity. We are committed to continuous improvement by:
+*   **Concept:** How we build.
+*   **Audience:** Tooling and Automation Engineers.
+*   **Details:** See the `factory/scripts/README.md` for an explanation of the automation philosophy.
+
+---
+
+### Root-Level Files
+
+The files in the root directory serve as the primary entry points to the project:
+
+*   **`Taskfile.yml`**: The public API for the automation framework. It is a simple, stable facade that delegates all commands to the `factory/`.
+*   **`README.md`**: This file. The front door and high-level guide to the project.
+*   **`.github/`**: Community interaction files, including issue/PR templates and `CONTRIBUTING.MD`.
+
+## 4. Contributing to THEA
 
-*   Systematically capturing lessons learned during project execution and framework development (see `docs/lessons_learned_sessions/` and `docs/process/agile-framework-development.md`).
-*   Feeding valuable insights back into THEA's guidance (within `thea/`), our development playbooks (within `thea/application-guides/playbooks/process_guidance/` or `docs/process/`), and overall processes.
-*   Fostering a culture where knowledge sharing drives our evolution.
+THEA is an evolving system, and contributions are welcome! Please see `.github/CONTRIBUTING.MD` for detailed guidelines on how to contribute to this framework.
 
-The THEA ecosystem, encompassing the THEA guidance system (in `thea/`), Firebase Studio Templates (defined in `thea/integrations/firebase-studio/`), and the ContextVibes CLI, is designed for such continuous, iterative improvement. The development and use of these components are interconnected in a virtuous cycle, driven by developer experience and feedback:
+## 5. Continuous Improvement & Lessons Learned
 
-![THEA Continuous Improvement Cycle](thea/foundations/assets/images/thea-continuous-improvement-cycle.svg)
-*(Process for creating and maintaining diagrams: [Playbook: Creating and Maintaining THEA Project Diagrams](thea/application-guides/playbooks/process_guidance/managing-project-diagrams.md))*
+This framework is a living entity. We are committed to continuous improvement by systematically capturing lessons learned and feeding valuable insights back into our guidance, playbooks, and processes.
 
-This cycle ensures that practical needs identified during template development and usage feed back into enhancing both our core tooling (`ContextVibes CLI`) and our foundational guidance (`THEA`), leading to progressively more powerful and efficient development workflows.
+![THEA Continuous Improvement Cycle](factory/.idx/icon.png)
+*(Note: The diagram path may need to be updated after the factory refactoring)*
 
-*(Refer to `docs/process/agile-framework-development.md` and `.github/CONTRIBUTING.MD` for more on how insights are captured and integrated.)*
+This cycle ensures that practical needs identified during development feed back into enhancing both our core tooling (`factory/`) and our foundational guidance (`thea/`), leading to progressively more powerful and efficient development workflows.
diff --git a/Taskfile.yml b/Taskfile.yml
index aaf0b05..e562e7b 100644
--- a/Taskfile.yml
+++ b/Taskfile.yml
@@ -1,203 +1,103 @@
-# Taskfile.yml
-# This is the main entry point for all project automation.
-# REVISION: This menu has been updated based on cognitive ergonomic analysis
-# and the official Taskfile style guide.
+# /.Taskfile.yml
+#
+# WHAT: This is the public API for the project's automation framework. It is a
+#       transparent facade that proxies all commands to the real implementation
+#       located in the ./factory directory.
+# WHY:  This provides a single, self-documenting entry point for all developers,
+#       fulfilling our "Taskfile as the Public API" principle.
 
 version: '3'
 
-# ==============================================================================
-#  INCLUDED TASK FILES
-# ==============================================================================
-# CONVENTION: The files included here are organized to match the command menu
-# displayed by the `default` task. All included files start with '_' for
-# a consistent file system structure.
-# ==============================================================================
-includes:
-  # --- Local Development (Inner Loop) ---
-  _task-start:      ./tasks/_task-start.yml  # Implements the `task-start` command.
-  _status:          ./tasks/_status.yml      # Implements the `status` command.
-  _run:             ./tasks/_run.yml       # Implements the `run` command.
-  _commit:          ./tasks/_commit.yml      # Implements the `commit` command.
-  _task-finish:     ./tasks/_task-finish.yml # Implements the `task-finish` command.
-
-  # --- Build & Release Pipeline (Outer Loop) ---
-  _build:           ./tasks/_build.yml      # Implements the `build` command to create artifacts.
-  _test:            ./tasks/_test.yml       # Implements the `test` command to run the test suite.
-  _analyze:         ./tasks/_analyze.yml    # Implements the `analyze` command for code quality checks.
-  _deploy:          ./tasks/_deploy.yml     # Implements the `deploy` command for cloud deployment.
-
-  # --- Infrastructure & Utilities ---
-  _provision:       ./tasks/_provision.yml  # Implements the `provision` command for infrastructure setup.
-  _verify:          ./tasks/_verify.yml     # Implements the `verify` command to check infrastructure health.
-  _destroy:         ./tasks/_destroy.yml    # Implements the `destroy` command for infrastructure teardown.
-  _update:          ./tasks/_update.yml     # Implements the `deps-update` command.
-  _clean:           ./tasks/_clean.yml      # Implements the `clean` command to remove temporary files.
-
-  # --- AI Assistant ---
-  _thea:            ./tasks/_thea.yml       # Implements all `thea-*` commands for AI-assisted workflows.
-
-  # --- Core Internal Utilities ---
-  _init:            ./tasks/_init.yml       # Implements the hidden `init` task, a dependency for other tasks.
-
+# The dotenv declaration MUST live in this top-level file.
 dotenv: [".env"]
 
 tasks:
+  # The default task explicitly calls the 'default' task from the factory's
+  # Taskfile, ensuring the formatted menu is always displayed.
   default:
     desc: "Displays the main project command menu."
     silent: true
     cmds:
-      - |
-        echo
-        echo "----------------------------------------------------------------------------"
-        echo "          ✨ THEA Command Menu (Cognitively-Refined) ✨"
-        echo "----------------------------------------------------------------------------"
-        echo "Run \`task <command>\` to execute an action. e.g., \`task test\`"
-        echo
-        echo -e "\033[1m--- 💻 Local Development (Inner Loop) ---\033[0m"
-        echo "    Tasks for the core cycle of coding and local iteration."
-        echo
-        echo -e "  \033[32mtask-start\033[0m   - ACTION:   Initiate a new task (e.g., \`git checkout -b new-feature\`)."
-        echo -e "  \033[32mstatus\033[0m       - VIEW:     Show a summary of local file changes (e.g., \`git status\`)."
-        echo -e "  \033[32mrun\033[0m          - ACTION:   Execute the application locally on your machine."
-        echo -e "  \033[32mcommit\033[0m       - ACTION:   Save all local changes into a new commit (e.g., \`git commit\`)."
-        echo -e "  \033[32mtask-finish\033[0m  - ACTION:   Finalize a task (e.g., create a pull request)."
-        echo
-        echo -e "\033[1m--- 📦 Build & Release Pipeline (Outer Loop) ---\033[0m"
-        echo "    Tasks for building, testing, and deploying the application."
-        echo
-        echo -e "  \033[32mbuild\033[0m        - ACTION:   Compile source code and create a build artifact."
-        echo -e "  \033[32mtest\033[0m         - ACTION:   Run the application's full suite of automated tests."
-        echo -e "  \033[32manalyze\033[0m      - ACTION:   Inspect code for quality, style, and vulnerabilities."
-        echo -e "  \033[32mrelease\033[0m      - ACTION:   Create and publish a new versioned release artifact."
-        echo -e "  \033[32mdeploy\033[0m       - ACTION:   Deploys the application to the cloud."
-        echo
-        echo -e "\033[1m--- ☁️ Infrastructure & Utilities ---\033[0m"
-        echo "    Tasks for managing cloud resources and local housekeeping."
-        echo
-        echo -e "  \033[32mprovision\033[0m    - GUIDE:    Shows setup checklist for cloud infrastructure."
-        echo -e "  \033[32mverify\033[0m       - VIEW:     Check that provisioned infrastructure is healthy."
-        echo -e "  \033[31mdestroy\033[0m      - ACTION:    Shows checklist for tearing down all infrastructure."
-        echo -e "  \033[32mdeps-update\033[0m  - ACTION:   Update third-party dependencies to their latest versions."
-        echo -e "  \033[32mclean\033[0m        - ACTION:   Remove all local temporary files and build artifacts."
-        echo
-        echo -e "\033[1m--- 🤖 AI Assistant ---\033[0m"
-        echo "    Leverage AI to accelerate your workflow and manage assets."
-        echo
-        echo -e "  \033[32mthea-export-codebase\033[0m   - AI:       Package the entire codebase for AI analysis or context."
-        echo -e "  \033[32mthea-prompt-generate\033[0m   - AI:       Generate a custom prompt template for a specific task."
-        echo -e "  \033[32mthea-playbook-generate\033[0m - AI:       Generate a custom, reusable playbook for a complex workflow."
-        echo
-
-  # ============================================================================
-  #  TASK IMPLEMENTATIONS
-  # ============================================================================
-  # CONVENTION: Each task below is a simple facade that calls a task of the
-  # exact same name in its corresponding included file.
-  # ============================================================================
-
-  # --- Local Development (Inner Loop) ---
+      - task --dir ./factory default
+
+  # ---------------------------------------------------------------------------
+  # PROXY TASKS (The Public API)
+  # Each task below is a simple proxy that calls the real task inside the
+  # factory. The description is copied for discoverability (`task --list`),
+  # and {{.CLI_ARGS}} ensures all arguments are passed through.
+  # ---------------------------------------------------------------------------
+
   task-start:
     desc: "ACTION: Initiate a new task (e.g., git checkout -b new-feature)."
     cmds:
-      - task: _task-start:task-start
-        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
+      - task --dir ./factory task-start -- {{.CLI_ARGS}}
 
-  status:
-    desc: "VIEW: Show a summary of local file changes (e.g., git status)."
+  context:
+    desc: "VIEW: Generate context for a specific goal (commit, pr, verify, export-*)."
     cmds:
-      - task: _status:status
+      - task --dir ./factory context -- {{.CLI_ARGS}}
 
   run:
     desc: "ACTION: Execute the application locally on your machine."
     cmds:
-      - task: _run:run
+      - task --dir ./factory run -- {{.CLI_ARGS}}
 
   commit:
     desc: "ACTION: Save all local changes into a new commit (e.g., git commit)."
     cmds:
-      - task: _commit:commit
-        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
+      - task --dir ./factory commit -- {{.CLI_ARGS}}
 
   task-finish:
     desc: "ACTION: Finalize a task (e.g., create a pull request)."
     cmds:
-      - task: _task-finish:task-finish
+      - task --dir ./factory task-finish -- {{.CLI_ARGS}}
 
-  # --- Build & Release Pipeline (Outer Loop) ---
   build:
     desc: "ACTION: Compile source code and create a build artifact."
     cmds:
-      - task: _build:build
+      - task --dir ./factory build -- {{.CLI_ARGS}}
 
   test:
     desc: "ACTION: Run the application's full suite of automated tests."
     cmds:
-      - task: _test:test
+      - task --dir ./factory test -- {{.CLI_ARGS}}
 
   analyze:
     desc: "ACTION: Inspect code for quality, style, and vulnerabilities."
     cmds:
-      - task: _analyze:analyze
+      - task --dir ./factory analyze -- {{.CLI_ARGS}}
 
   release:
-    desc: "ACTION: Create and publish a new versioned release artifact. (placeholder)"
+    desc: "ACTION: Create and publish a new versioned release artifact."
     cmds:
-      - echo "Placeholder for release task. This would typically involve tagging and creating a release in your Git provider."
+      - task --dir ./factory release -- {{.CLI_ARGS}}
 
   deploy:
     desc: "ACTION: Deploys the application to the cloud."
     cmds:
-      - task: _deploy:deploy
+      - task --dir ./factory deploy -- {{.CLI_ARGS}}
 
-  # --- Infrastructure & Utilities ---
   provision:
     desc: "GUIDE: Shows setup checklist for cloud infrastructure."
     cmds:
-      - task: _provision:provision
+      - task --dir ./factory provision -- {{.CLI_ARGS}}
 
   verify:
     desc: "VIEW: Check that provisioned infrastructure is healthy."
     cmds:
-      - task: _verify:verify
+      - task --dir ./factory verify -- {{.CLI_ARGS}}
 
   destroy:
-    desc: "ACTION: Permanently destroys ALL cloud infrastructure (requires confirmation)."
+    desc: "ACTION: Shows checklist for tearing down all infrastructure."
     cmds:
-      - task: _destroy:destroy
+      - task --dir ./factory destroy -- {{.CLI_ARGS}}
 
   deps-update:
     desc: "ACTION: Update third-party dependencies to their latest versions."
     cmds:
-      - task: _update:deps-update
+      - task --dir ./factory deps-update -- {{.CLI_ARGS}}
 
   clean:
     desc: "ACTION: Remove all local temporary files and build artifacts."
     cmds:
-      - task: _clean:clean
-
-  # --- AI Assistant ---
-  thea-export-codebase:
-    desc: "AI: Package the entire codebase for AI analysis or context."
-    cmds:
-      - task: _thea:thea-export-codebase
-        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
-
-  thea-prompt-generate:
-    desc: "AI: Generate a custom prompt template for a specific task."
-    cmds:
-      - task: _thea:thea-prompt-generate
-
-  thea-playbook-generate:
-    desc: "AI: Generate a custom, reusable playbook for a complex workflow."
-    cmds:
-      - task: _thea:thea-playbook-generate
-
-  # --- Hidden Utilities ---
-  init:
-    internal: true
-    cmds:
-      - task: _init:init
-  env:
-    internal: true
-    cmds:
-      - task: _init:env
+      - task --dir ./factory clean -- {{.CLI_ARGS}}
diff --git a/docs/README.md b/docs/README.md
new file mode 100644
index 0000000..f44a17c
--- /dev/null
+++ b/docs/README.md
@@ -0,0 +1,32 @@
+# The Library: Project Documentation
+
+Welcome to the `docs/` directory. This is the internal knowledge base for the THEA project itself.
+
+## Purpose
+
+The contents of this directory represent **The Library**. This documentation is *about the project*, not the distributable guidance. It's where we document our processes, decisions, and history.
+
+**Key Distinction:**
+*   `thea/` contains the **product** we ship.
+*   `docs/` contains the **process** by which we build and manage the project.
+
+## Directory Structure
+
+*   ### `lessons_learned_sessions/`
+    *   **Purpose:** A repository of notes and reflections from our internal review sessions. This is where we capture what went well and what could be improved.
+
+*   ### `process/`
+    *   **Purpose:** Formal documentation of our team's development processes, such as our agile framework definition.
+
+*   ### `product_backlog/`
+    *   **Purpose:** Detailed specifications for Product Backlog Items (PBIs). This is where we define and track upcoming work on the THEA framework itself.
+
+*   ### `research_findings/`
+    *   **Purpose:** An archive of research briefs and findings that *informed* the creation of THEA. This is distinct from the consumable research papers that are part of the product in `thea/foundations/research-papers/`.
+
+## How to Contribute
+
+When contributing to the project's internal documentation, please follow these guidelines:
+1.  Use the existing templates for new PBIs or lessons learned sessions where applicable.
+2.  Ensure that process documentation is reviewed and approved by the team before being merged.
+3.  Keep the focus on the *project's lifecycle*, not the end-user guidance.
diff --git a/docs/prompts/cleanup.md b/docs/prompts/cleanup.md
new file mode 100644
index 0000000..471efd7
--- /dev/null
+++ b/docs/prompts/cleanup.md
@@ -0,0 +1,28 @@
+# AI Meta-Prompt: Code Cleanup and Refactoring
+
+## Your Role
+
+You are a senior software engineer with a talent for refactoring and simplifying code. You have been tasked with identifying opportunities to clean up the provided Go codebase, reducing its complexity and improving its overall health without changing its external behavior.
+
+## The Task
+
+Analyze the following Go code. Your goal is to identify and suggest specific, safe refactorings that will make the code cleaner, more efficient, and easier to maintain.
+
+## Rules for Your Suggestions
+
+1. **Prioritize Safety:** All suggested changes must be behavior-preserving refactorings. Do not suggest changes that would alter the public API or the code's functionality.
+2. **Focus on High-Impact Areas:** Look for common code smells such as:
+    * **Dead Code:** Unused variables, functions, or constants that can be safely removed.
+    * **Redundancy:** Duplicated code blocks that could be extracted into a shared function.
+    * **Overly Complex Functions:** Long functions that are doing too many things and could be broken down into smaller, more focused units.
+    * **Unnecessary Complexity:** Complicated conditional logic that could be simplified.
+    * **Poor Naming:** Variables or functions with names that are unclear or misleading.
+3. **Provide Clear Instructions:** For each suggested cleanup, provide:
+    * The file name and line number(s) of the code to be changed.
+    * A clear explanation of *why* the code should be changed.
+    * A code snippet showing the exact "before" and "after".
+4. **Format as a Checklist:** Present your findings as a Markdown checklist, so the developer can easily work through and apply your suggestions.
+
+## Your Input
+
+I will now provide you with the code to be cleaned up.
diff --git a/docs/prompts/code-quality.md b/docs/prompts/code-quality.md
new file mode 100644
index 0000000..5a8118a
--- /dev/null
+++ b/docs/prompts/code-quality.md
@@ -0,0 +1,26 @@
+# AI Meta-Prompt: Code Quality Review
+
+## Your Role
+
+You are an expert Go developer and a meticulous code reviewer. Your primary goal is to analyze the provided Go code for quality, maintainability, and adherence to best practices. You are not here to judge, but to improve.
+
+## The Task
+
+Analyze the following Go code snippet or file. Provide a comprehensive code review in Markdown format.
+
+## Rules for Your Review
+
+1. **Start with a High-Level Summary:** Begin with a brief, one-paragraph summary of the code's purpose and your overall impression of its quality.
+2. **Use a Structured Format:** Present your feedback in a list or table. For each point, specify the file name and line number(s).
+3. **Categorize Your Feedback:** Group your suggestions into the following categories:
+    * **Correctness:** Identify any potential bugs, race conditions, or logical errors.
+    * **Simplicity & Clarity:** Suggest ways to simplify complex code, improve variable names, or make the code easier to understand.
+    * **Idiomatic Go:** Point out places where the code deviates from standard Go idioms (e.g., error handling, interface usage, struct composition).
+    * **Testing:** Comment on the quality and coverage of existing tests, or suggest new test cases that are needed.
+    * **Nitpicks:** For minor stylistic issues (e.g., comment formatting, extra whitespace), group them under a "Nitpicks" heading.
+4. **Provide Actionable Suggestions:** For each point of feedback, provide a clear "before" and "after" code snippet demonstrating your suggested improvement. Explain *why* your suggestion is an improvement.
+5. **Maintain a Positive and Collaborative Tone:** Frame your feedback constructively. Assume the original author acted with good intentions.
+
+## Your Input
+
+I will now provide you with the code to be reviewed.
diff --git a/docs/prompts/export-automation-context.md b/docs/prompts/export-automation-context.md
new file mode 100644
index 0000000..8d4e45b
--- /dev/null
+++ b/docs/prompts/export-automation-context.md
@@ -0,0 +1,24 @@
+# AI INSTRUCTION: Automation Framework Analysis
+
+## 1. Your Role
+
+Assume the role of **Kernel**, the project's lead tooling and automation engineer. Your expertise lies in Go Task, shell scripting, CI/CD pipelines, Docker, and Nix. Your memory is being initialized with a curated export of the project's complete automation and configuration layer.
+
+## 2. Your Task
+
+The content immediately following this prompt is a targeted export of the project's "Factory" files. This includes:
+
+*   `Taskfile.yml` and all tasks in `tasks/`
+*   All helper shell scripts in `scripts/`
+*   `Dockerfile` and `docker-compose.yml`
+*   All IDX environment configurations in `.idx/`
+
+Your primary task is to **fully ingest and internalize this automation context**. Your goal is to build a deep and accurate mental model of how this project is built, tested, configured, and deployed. You must understand the high-level `task` API, the low-level script logic, and the environment that executes them.
+
+## 3. Required Confirmation
+
+After you have processed all the information, your **only** response should be the following confirmation message. This signals that you have successfully loaded the automation context and are ready to operate with your specialized knowledge.
+
+**Confirmation Message:**
+---
+Context loaded. I have a complete model of the project's automation framework and am ready to operate as Kernel.
\ No newline at end of file
diff --git a/docs/prompts/export-code-context.md b/docs/prompts/export-code-context.md
new file mode 100644
index 0000000..08b8234
--- /dev/null
+++ b/docs/prompts/export-code-context.md
@@ -0,0 +1,23 @@
+# AI INSTRUCTION: Application Code Analysis
+
+## 1. Your Role
+
+Assume the role of **Ferris**, the project's Go language mentor and senior software engineer. Your expertise is in idiomatic Go, application architecture, and API design. Your memory is being initialized with a curated export of the project's complete application source code.
+
+## 2. Your Task
+
+The content immediately following this prompt is a targeted export of the project's "Application" files. This includes:
+
+*   The main application entrypoint in `cmd/`
+*   All core business logic in `internal/`
+*   Project dependencies in `go.mod` and `go.sum`
+
+Your primary task is to **fully ingest and internalize this application code context**. Your goal is to build a deep and accurate mental model of the application's architecture, logic, and dependencies. You must understand what the application does and how it is structured.
+
+## 3. Required Confirmation
+
+After you have processed all the information, your **only** response should be the following confirmation message. This signals that you have successfully loaded the code context and are ready to operate with your specialized knowledge.
+
+**Confirmation Message:**
+---
+Context loaded. I have a complete model of the application's Go source code and am ready to operate as Ferris.
diff --git a/docs/prompts/export-docs-context.md b/docs/prompts/export-docs-context.md
new file mode 100644
index 0000000..b1959d2
--- /dev/null
+++ b/docs/prompts/export-docs-context.md
@@ -0,0 +1,23 @@
+# AI INSTRUCTION: Documentation & Guidance Analysis
+
+## 1. Your Role
+
+Assume the role of **Logos**, the project's documentation architect. Your expertise is in technical writing, project standards, and developer guidance. Your memory is being initialized with a curated export of the project's complete documentation and guidance layer.
+
+## 2. Your Task
+
+The content immediately following this prompt is a targeted export of the project's "Library" files. This includes:
+
+*   `README.md` and `CHANGELOG.md`
+*   All guides and diagrams in `docs/`
+*   All procedural playbooks in `playbooks/`
+
+Your primary task is to **fully ingest and internalize this documentation context**. Your goal is to build a deep and accurate mental model of how developers are guided to work on this project. You must understand the project's stated goals, its contribution process, and its operational procedures.
+
+## 3. Required Confirmation
+
+After you have processed all the information, your **only** response should be the following confirmation message. This signals that you have successfully loaded the documentation context and are ready to operate with your specialized knowledge.
+
+**Confirmation Message:**
+---
+Context loaded. I have a complete model of the project's documentation and am ready to operate as Logos.
\ No newline at end of file
diff --git a/docs/prompts/export-project-context.md b/docs/prompts/export-project-context.md
new file mode 100644
index 0000000..f6d3720
--- /dev/null
+++ b/docs/prompts/export-project-context.md
@@ -0,0 +1,24 @@
+# AI INSTRUCTION: Full Project Context Ingestion
+
+## 1. Your Role
+
+Assume the role of a senior software engineer and technical architect with deep expertise in Go, shell scripting, and modern development workflows. Your memory is now being initialized with the complete state of a software project.
+
+## 2. Your Task
+
+The content immediately following this prompt is a comprehensive, machine-generated export of a software project. This export includes:
+
+*   The current state of uncommitted work.
+*   The commit history of the current branch.
+*   The full project directory structure.
+*   The complete source code of several key configuration and application files.
+
+Your primary task is to **fully ingest and internalize this entire context**. Do not summarize it. Your goal is to build a complete and accurate mental model of the project as if you were an engineer who had just been onboarded. You must understand the dependencies, the automation logic, the application's purpose, and the most recent changes.
+
+## 3. Required Confirmation
+
+After you have processed all the information that follows this prompt, your **only** response should be the following confirmation message. This signals that you have successfully loaded the context and are awaiting a specific, follow-up command.
+
+**Confirmation Message:**
+---
+Context loaded. I have a complete model of the project's code, automation, and documentation. Ready for your next objective.
\ No newline at end of file
diff --git a/docs/prompts/generate-commit-message.md b/docs/prompts/generate-commit-message.md
new file mode 100644
index 0000000..26737b7
--- /dev/null
+++ b/docs/prompts/generate-commit-message.md
@@ -0,0 +1,35 @@
+# AI Prompt: Generate Conventional Commit Command
+
+<!-- REASON: This prompt has been reconstructed using the Component-Based
+Methodology from the Firebase Studio research paper (Section 4.2). It now
+includes an explicit Chain-of-Thought trigger and a Few-Shot example to
+improve the reliability and accuracy of the AI's output. -->
+
+## 1. Role & Persona
+You are an expert software engineer channeling the **`Canon`** persona, the guardian of project standards. Your primary function is to create a perfectly formatted Conventional Commit message based on a provided code diff.
+
+## 2. Context & Goal
+You will be given the output of `git status` and `git diff --staged`. Your goal is to analyze these changes and generate a single, complete `task commit` command that is ready to be executed in the terminal.
+
+## 3. Task Breakdown (Chain-of-Thought)
+To ensure accuracy, you **MUST** follow these steps in your reasoning:
+1.  **Analyze Intent:** First, determine the primary intent of the changes. Is this a new feature (`feat`), a bug fix (`fix`), a refactoring (`refactor`), a documentation update (`docs`), or a maintenance task (`chore`)?
+2.  **Identify Scope:** Second, identify the most logical scope for the changes (e.g., `automation`, `api`, `config`, `testing`).
+3.  **Draft Subject:** Third, write a concise subject line (under 50 chars) in the imperative mood (e.g., "Add feature," not "Added feature").
+4.  **Draft Body:** Fourth, write a brief body explaining the "why" behind the changes.
+5.  **Assemble Command:** Finally, assemble these components into the final `task commit` command.
+
+## 4. Constraints
+*   The final output **MUST** be only a single, runnable `bash` command. Do not add any conversational text before or after it.
+*   The commit message **MUST** adhere to the Conventional Commits v1.0.0 specification.
+*   The command **MUST** use two `-m` flags: one for the subject and one for the body.
+
+## 5. Example (Few-Shot)
+If the user added a new function to a script, your final output should look exactly like this:
+
+```bash
+task commit -- -m "feat(automation): Add validation to start-task script" -m "This change introduces a new function to validate branch names against the project's naming convention, improving consistency."
+```
+
+## 6. Your Input
+I will now provide you with the git status and diff output. Analyze it and generate the command.
\ No newline at end of file
diff --git a/docs/prompts/generate-pr-description.md b/docs/prompts/generate-pr-description.md
new file mode 100644
index 0000000..74d58b3
--- /dev/null
+++ b/docs/prompts/generate-pr-description.md
@@ -0,0 +1,23 @@
+# AI Prompt: Generate Pull Request Description
+
+## Your Role
+You are an expert software engineer writing a clear and comprehensive description for a pull request.
+
+## The Task
+Analyze the following git commit history and aggregated diff for the entire feature branch. Based on this context, generate a pull request description in Markdown format.
+
+## Rules for Your Output
+1.  **Format:** Use the provided Markdown template.
+2.  **Summary:** Write a high-level summary of the changes and the problem being solved.
+3.  **Changes:** Use a bulleted list to detail the specific changes made.
+4.  **Output:** Generate ONLY the pull request description and nothing else.
+
+## PR Template
+```markdown
+### Summary
+
+### Changes
+-
+-
+
+### How To Test
\ No newline at end of file
diff --git a/factory/README.md b/factory/README.md
new file mode 100644
index 0000000..e03f0f2
--- /dev/null
+++ b/factory/README.md
@@ -0,0 +1,50 @@
+# The Factory: Automation Framework
+
+## 1. Purpose & Philosophy
+
+Welcome to the `factory/` directory. This is the complete, self-contained automation framework for the THEA project.
+
+Our project is organized using a **"Product, Library, Factory"** model. This directory represents **The Factory**—the machinery, processes, and environment used to build, test, and manage the project's "Product" (the `thea/` directory) and its "Library" (the `docs/` directory).
+
+The primary goal of this structure is to create a clean separation of concerns, making the project easier to navigate and maintain.
+
+## 2. The "Menu / Workflow / Action" Pattern
+
+The automation within the factory is designed around a three-layer pattern to ensure logic is organized and easy to trace.
+
+1.  **The Menu (Public API):**
+    *   **Location:** `/Taskfile.yml` (in the project root).
+    *   **Purpose:** Provides the clean, user-facing "public API" of commands. It is a simple proxy that delegates every command to the factory. This is the only file a typical user needs to be aware of.
+
+2.  **The Workflow (The Control Panel):**
+    *   **Location:** `factory/Taskfile.yml` and `factory/tasks/`.
+    *   **Purpose:** This is the main entry point and control panel for the factory itself. The `Taskfile.yml` here defines the user-friendly help menu and includes all the individual task files from the `tasks/` subdirectory. The files in `tasks/` provide the wiring between a command and the script that implements it.
+
+3.  **The Action (The Implementation):**
+    *   **Location:** `factory/scripts/`.
+    *   **Purpose:** This is where the real work happens. The shell scripts in this directory contain the core implementation logic for every command.
+
+## 3. Directory Structure
+
+*   ### `Taskfile.yml`
+    *   The main entry point for the factory. It defines the default help menu and includes all task files from the `tasks/` directory.
+
+*   ### `tasks/`
+    *   Contains individual `.yml` files, each corresponding to a high-level command. These files bridge the gap between the command name and the script that executes the logic.
+
+*   ### `scripts/`
+    *   Contains all the shell scripts that perform the automation tasks.
+    *   **`_automation_helpers.sh`**: This is the most important file in this directory. It is a centralized library of shared functions and variables. **All reusable logic MUST be placed here.**
+
+*   ### `.idx/`
+    *   Contains the Nix configuration (`dev.nix`) that defines the development environment. This ensures that every developer has the exact same set of tools (Go, ShellCheck, Gum, etc.) for a consistent and reproducible experience.
+
+## 4. How to Add a New Command
+
+To add a new command (e.g., `task new-command`) to the framework, follow these steps:
+
+1.  **Implement the Action:** Create a new shell script in `factory/scripts/new_command.sh`. Place any reusable logic in `_automation_helpers.sh`.
+2.  **Define the Workflow:** Create a new task file in `factory/tasks/_new_command.yml`. In this file, define a task that calls your new script.
+3.  **Include the Workflow:** Open `factory/Taskfile.yml` and add `_new_command: ./tasks/_new_command.yml` to the `includes:` block.
+4.  **Expose the API:** Open the root `/Taskfile.yml` and add a new proxy task for `new-command` that delegates to the factory.
+5.  **Document the API:** Add the new command to the `default` task's help menu inside `factory/Taskfile.yml` so it is discoverable by users.
diff --git a/factory/Taskfile.yml b/factory/Taskfile.yml
new file mode 100644
index 0000000..826a306
--- /dev/null
+++ b/factory/Taskfile.yml
@@ -0,0 +1,199 @@
+# Taskfile.yml
+#
+# WHAT: This file is the single, user-facing entry point for all project automation.
+# WHY:  It provides a simple, high-level command menu that is easy for developers
+#       to use and understand, hiding the complexity of the underlying scripts and tools.
+#       This approach, called "Menu / Workflow / Action", is designed to reduce cognitive load.
+
+version: '3'
+
+# ==============================================================================
+#  INCLUDED TASK FILES
+# ==============================================================================
+# WHAT: This block includes all the helper Taskfiles from the ./tasks/ directory.
+# WHY:  Including these files allows this main Taskfile to act as a clean menu,
+#       delegating the actual implementation logic to the included files. This
+#       keeps the project's automation organized and maintainable.
+# ==============================================================================
+includes:
+  # --- Local Development (Inner Loop) ---
+  _task-start:      ./tasks/_task-start.yml
+  _context:         ./tasks/_context.yml
+  _run:             ./tasks/_run.yml
+  _commit:          ./tasks/_commit.yml
+  _task-finish:     ./tasks/_task-finish.yml
+
+  # --- Build & Release Pipeline (Outer Loop) ---
+  _build:           ./tasks/_build.yml
+  _test:            ./tasks/_test.yml
+  _analyze:         ./tasks/_analyze.yml
+  _release:         ./tasks/_release.yml
+  _deploy:          ./tasks/_deploy.yml
+
+  # --- Infrastructure & Utilities ---
+  _provision:       ./tasks/_provision.yml
+  _verify:          ./tasks/_verify.yml
+  _destroy:         ./tasks/_destroy.yml
+  _update:          ./tasks/_update.yml
+  _clean:           ./tasks/_clean.yml
+
+  # --- Core Internal Utilities ---
+  _init:            ./tasks/_init.yml
+
+tasks:
+  # WHAT: This is the default task that runs when 'task' is called without arguments.
+  # WHY:  Its purpose is to display a well-formatted, user-friendly help menu
+  #       that describes all available high-level commands.
+  default:
+    desc: "Displays the main project command menu."
+    silent: true
+    cmds:
+      - |
+        echo
+        echo "----------------------------------------------------------------------------"
+        echo "          ✨ THEA Command Menu (Cognitively-Refined) ✨"
+        echo "----------------------------------------------------------------------------"
+        echo "Run \`task <command>\` to execute an action. e.g., \`task test\`"
+        echo
+        echo -e "\033[1m--- 💻 Local Development (Inner Loop) ---\033[0m"
+        echo "    Tasks for the core cycle of coding and local iteration."
+        echo
+        echo -e "  \033[32mtask-start\033[0m   - ACTION:   Initiate a new task (e.g., \`git checkout -b new-feature\`)."
+        echo -e "  \033[32mcontext\033[0m      - VIEW:     Generate context for a specific goal (commit, pr, verify, export-*)."
+        echo -e "  \033[32mrun\033[0m          - ACTION:   Execute the application locally on your machine."
+        echo -e "  \033[32mcommit\033[0m       - ACTION:   Save all local changes into a new commit (e.g., \`git commit\`)."
+        echo -e "  \033[32mtask-finish\033[0m  - ACTION:   Finalize a task (e.g., create a pull request)."
+        echo
+        echo -e "\033[1m--- 📦 Build & Release Pipeline (Outer Loop) ---\033[0m"
+        echo "    Tasks for building, testing, and deploying the application."
+        echo
+        echo -e "  \033[32mbuild\033[0m        - ACTION:   Compile source code and create a build artifact."
+        echo -e "  \033[32mtest\033[0m         - ACTION:   Run the application's full suite of automated tests."
+        echo -e "  \033[32manalyze\033[0m      - ACTION:   Inspect code for quality, style, and vulnerabilities."
+        echo -e "  \033[32mrelease\033[0m      - ACTION:   Create and publish a new versioned release artifact."
+        echo -e "  \033[32mdeploy\033[0m       - ACTION:   Deploys the application to the cloud."
+        echo
+        echo -e "\033[1m--- ☁️ Infrastructure & Utilities ---\033[0m"
+        echo "    Tasks for managing cloud resources and local housekeeping."
+        echo
+        echo -e "  \033[32mprovision\033[0m    - GUIDE:    Shows setup checklist for cloud infrastructure."
+        echo -e "  \033[32mverify\033[0m       - VIEW:     Check that provisioned infrastructure is healthy."
+        echo -e "  \033[31mdestroy\033[0m      - ACTION:   Shows checklist for tearing down all infrastructure."
+        echo -e "  \033[32mdeps-update\033[0m  - ACTION:   Update third-party dependencies to their latest versions."
+        echo -e "  \033[32mclean\033[0m        - ACTION:   Remove all local temporary files and build artifacts."
+        echo
+
+  # ============================================================================
+  #  FACADE TASKS
+  # ============================================================================
+  # WHAT: Each task below is a simple "facade" that delegates its execution
+  #       to a corresponding task in an included file from the `tasks/` directory.
+  #
+  # WHY:  This pattern keeps the root Taskfile clean and readable, like a high-level
+  #       API menu. It abstracts away the implementation details and enforces a
+  #       consistent structure across the entire project.
+  #
+  # HOW:  The `vars: { CLI_ARGS: '{{.CLI_ARGS}}' }` block is used universally.
+  #       It captures any arguments passed after a '--' on the command line
+  #       (e.g., `task commit -- -m "msg"`) and forwards them to the
+  #       underlying script, enabling both interactive and parameterized use.
+  # ============================================================================
+  task-start:
+    desc: "ACTION: Initiate a new task (e.g., git checkout -b new-feature)."
+    cmds:
+      - task: _task-start:task-start
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
+
+  context:
+    desc: "VIEW: Show a summary of local file changes (e.g., git context)."
+    cmds:
+      - task: _context:helper
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
+
+  run:
+    desc: "ACTION: Execute the application locally on your machine."
+    cmds:
+      - task: _run:run
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
+
+  commit:
+    desc: "ACTION: Save all local changes into a new commit (e.g., git commit)."
+    cmds:
+      - task: _commit:commit
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
+
+  task-finish:
+    desc: "ACTION: Finalize a task (e.g., create a pull request)."
+    cmds:
+      - task: _task-finish:task-finish
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
+
+  build:
+    desc: "ACTION: Compile source code and create a build artifact."
+    cmds:
+      - task: _build:build
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
+
+  test:
+    desc: "ACTION: Run the application's full suite of automated tests."
+    cmds:
+      - task: _test:test
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
+
+  analyze:
+    desc: "ACTION: Inspect code for quality, style, and vulnerabilities."
+    cmds:
+      - task: _analyze:analyze
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
+
+  release:
+    desc: "ACTION: Create and publish a new versioned release artifact."
+    cmds:
+      - task: _release:release
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
+
+  deploy:
+    desc: "ACTION: Deploys the application to the cloud."
+    cmds:
+      - task: _deploy:deploy
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
+
+  provision:
+    desc: "GUIDE: Shows setup checklist for cloud infrastructure."
+    cmds:
+      - task: _provision:provision
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
+
+  verify:
+    desc: "VIEW: Check that provisioned infrastructure is healthy."
+    cmds:
+      - task: _verify:verify
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
+
+  destroy:
+    desc: "ACTION: Permanently destroys ALL cloud infrastructure (requires confirmation)."
+    cmds:
+      - task: _destroy:destroy
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
+
+  deps-update:
+    desc: "ACTION: Update third-party dependencies to their latest versions."
+    cmds:
+      - task: _update:deps-update
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
+
+  clean:
+    desc: "ACTION: Remove all local temporary files and build artifacts."
+    cmds:
+      - task: _clean:clean
+        vars: { CLI_ARGS: '{{.CLI_ARGS}}' }
+
+  # --- Hidden Utilities ---
+  init:
+    internal: true
+    cmds:
+      - task: _init:init
+  env:
+    internal: true
+    cmds:
+      - task: _init:env
diff --git a/factory/scripts/README.md b/factory/scripts/README.md
new file mode 100644
index 0000000..69a556f
--- /dev/null
+++ b/factory/scripts/README.md
@@ -0,0 +1,46 @@
+# Scripts Directory
+
+## 1. Purpose
+
+This directory contains all the shell scripts that implement the core logic for the project's automation framework.
+
+These scripts represent the "Action" layer in our "Menu / Workflow / Action" automation philosophy. They are designed to be called by the `Taskfile.yml` configurations located in the `tasks/` directory and should contain the actual implementation details for a given command.
+
+## 2. Design Philosophy
+
+*   **Separation of Concerns:** The root `Taskfile.yml` is the user-facing "Menu." The `tasks/*.yml` files define the "Workflow." These scripts are the "Action"—the "how." This separation keeps the `Taskfile` clean and makes the underlying logic easier to find and maintain.
+*   **Single Responsibility:** Each script should, as much as possible, be responsible for a single, well-defined task (e.g., `commit.sh` handles committing, `start_task.sh` handles starting a new task).
+*   **Don't Repeat Yourself (DRY):** All generic, reusable logic that could be used by more than one script **must** be placed in the central helper library.
+
+## 3. The Automation Helper Library
+
+The most important file in this directory is `_automation_helpers.sh`.
+
+*   **What It Is:** A library of shared variables and bash functions that are used across multiple scripts. The leading underscore (`_`) ensures it is listed first and signals its role as an internal library.
+*   **Purpose:** It is the **single source of truth** for common logic. This prevents code duplication and ensures that core behaviors (like checking for uncommitted changes or validating branch names) are consistent everywhere.
+*   **Usage:** To use the helper functions in a new script, add the following line at the top:
+    ```sh
+    source "$(dirname "$0")/_automation_helpers.sh"
+    ```
+
+**Golden Rule:** Before writing any new code in a script, ask yourself: "Is this logic generic enough to be used by another script?" If the answer is yes, it belongs in `_automation_helpers.sh`.
+
+## 4. Naming Conventions
+
+Scripts should be named clearly and consistently to reflect their purpose. We follow a `verb_noun.sh` or `context_verb.sh` pattern.
+
+*   **Examples:**
+    *   `commit.sh` (Action script)
+    *   `start_task.sh` (Action script)
+    *   `context_export_automation.sh` (Context generation script)
+
+## 5. Contributing a New Script
+
+When adding a new script to the framework, follow these steps:
+
+1.  **Check the Helper:** Review `_automation_helpers.sh` to see if any functions you need already exist.
+2.  **Factor Out Logic:** As you write your script, identify any new, generic logic and add it to `_automation_helpers.sh` first.
+3.  **Source the Helper:** Add `source "$(dirname "$0")/_automation_helpers.sh"` to the top of your new script.
+4.  **Write the Script:** Implement the specific logic for your new task, calling helper functions where appropriate.
+5.  **Make it Executable:** Run `chmod +x your_new_script.sh` to ensure it can be executed.
+6.  **Update Taskfile:** Add a corresponding task in the `tasks/` directory that calls your new script.
diff --git a/factory/scripts/_automation_helpers.sh b/factory/scripts/_automation_helpers.sh
new file mode 100644
index 0000000..7c85b4c
--- /dev/null
+++ b/factory/scripts/_automation_helpers.sh
@@ -0,0 +1,205 @@
+# -----------------------------------------------------------------------------
+# SECTION: SHARED VARIABLES & CONSTANTS
+# -----------------------------------------------------------------------------
+# WHAT: Define variables here that are used by multiple scripts.
+# WHY:  Centralizing constants prevents "magic strings" and makes global
+#       changes (like renaming the main branch) trivial.
+# -----------------------------------------------------------------------------
+readonly MAIN_BRANCH="main"
+readonly PROMPTS_DIR="docs/prompts"
+readonly CONTEXT_STATUS_FILE="contextvibes_status.md"
+readonly BRANCH_PATTERN="^((feature|fix|docs|format)/.+)$"
+
+
+# -----------------------------------------------------------------------------
+# SECTION: SHARED FUNCTIONS
+# -----------------------------------------------------------------------------
+# WHAT: Reusable functions for common automation tasks.
+# WHY:  Encapsulates logic into named, single-responsibility blocks.
+# -----------------------------------------------------------------------------
+
+# ---
+# WHAT:  Checks if the current branch is the main branch and exits if it is.
+# WHY:   A critical safety guard to prevent direct modifications or operations
+#        on the primary branch, enforcing a feature-branch workflow.
+# FROM:  commit.sh, finish_task.sh
+# USAGE: prevent_run_on_main
+# ---
+prevent_run_on_main() {
+  if [ "$(git rev-parse --abbrev-ref HEAD)" == "$MAIN_BRANCH" ]; then
+    echo "❌ ERROR: This command cannot be run on the '$MAIN_BRANCH' branch." >&2
+    exit 1
+  fi
+}
+
+# ---
+# WHAT:  Checks for any uncommitted (staged or unstaged) changes and exits
+#        if the workspace is "dirty".
+# WHY:   Ensures that scripts which perform Git operations start from a clean,
+#        known state, preventing accidental inclusion of unrelated changes.
+# FROM:  finish_task.sh
+# USAGE: ensure_clean_workspace
+# ---
+ensure_clean_workspace() {
+  if ! git diff --quiet --exit-code; then
+    echo "❌ ERROR: You have uncommitted changes. Please commit or stash them first." >&2
+    exit 1
+  fi
+}
+
+# ---
+# WHAT:  A non-fatal version of ensure_clean_workspace that just prints a warning.
+# WHY:   Useful for context-generation scripts where uncommitted changes might
+#        be relevant to the output, but the user should be aware of them.
+# FROM:  context_pr.sh
+# USAGE: warn_if_dirty
+# ---
+warn_if_dirty() {
+  if ! git diff --quiet --exit-code; then
+    echo "⚠️  Warning: You have uncommitted changes that may not be reflected in the output." >&2
+  fi
+}
+
+# ---
+# WHAT:  A user-friendly version of ensure_clean_workspace. It checks for
+#        uncommitted changes and, if found, interactively prompts the user
+#        to stash them before proceeding.
+# WHY:   Provides a better user experience than simply exiting. It allows the
+#        user to save their work-in-progress and continue the current task
+#        without having to manually run git commands.
+# FROM:  clean.sh, start_task.sh
+# USAGE: STASH_PERFORMED=$(prompt_to_stash_if_dirty)
+#        # ... later in the script ...
+#        if [ "$STASH_PERFORMED" = "true" ]; then git stash pop; fi
+# ---
+prompt_to_stash_if_dirty() {
+  if ! git diff --quiet --exit-code; then
+    echo "⚠️  You have uncommitted changes."
+    read -p "    Stash them and continue? (Y/n) " -n 1 -r
+    echo
+    if [[ $REPLY =~ ^[Nn]$ ]]; then
+      echo "Aborted by user. Please commit or stash your changes before running again."
+      exit 1
+    else
+      git stash
+      echo "✅ Changes stashed."
+      # Return "true" to the calling script to signal a stash was performed
+      echo "true"
+    fi
+  else
+    # Return "false" if no stash was performed
+    echo "false"
+  fi
+}
+
+# ---
+# WHAT:  Validates a given branch name against the project's convention.
+# WHY:   Enforces consistent branch naming across the project, which helps
+#        with organization and automation.
+# FROM:  start_task.sh, clean.sh
+# USAGE: validate_branch_name "feature/my-new-thing"
+# ---
+validate_branch_name() {
+  local branch_name="$1"
+  if [[ ! "$branch_name" =~ $BRANCH_PATTERN ]]; then
+    echo "❌ ERROR: Invalid branch name: '$branch_name'" >&2
+    echo "   Branches must follow the pattern: type/description" >&2
+    echo "   Valid types are: feature, fix, docs, format" >&2
+    echo "   Example: feature/new-context-menu" >&2
+    exit 1
+  fi
+}
+
+# ---
+# WHAT:  Checks if the GitHub CLI ('gh') is installed and authenticated.
+# WHY:   Ensures that scripts relying on GitHub integration (like creating a
+#        pull request) can function correctly.
+# FROM:  finish_task.sh
+# USAGE: ensure_gh_cli_authenticated
+# ---
+ensure_gh_cli_authenticated() {
+  if ! gh auth status > /dev/null 2>&1; then
+    echo "❌ ERROR: GitHub CLI ('gh') is not authenticated. Please run 'gh auth login'." >&2
+    exit 1
+  fi
+}
+
+# ---
+# WHAT:  Checks for merge conflicts between the current branch and main without
+#        actually performing a merge.
+# WHY:   A critical pre-flight check before attempting a merge or PR. It allows
+#        the script to fail early with a clear message if conflicts exist.
+# FROM:  finish_task.sh
+# USAGE: check_for_merge_conflicts
+# ---
+check_for_merge_conflicts() {
+  echo "--> Analyzing branch for merge conflicts with '$MAIN_BRANCH'..."
+  git fetch origin "$MAIN_BRANCH"
+  # Uses git merge-tree to simulate a merge and checks for conflict markers
+  if git merge-tree "$(git merge-base "origin/$MAIN_BRANCH" HEAD)" HEAD "origin/$MAIN_BRANCH" | grep -q '<<<<<<<'; then
+    echo "❌ CONFLICT DETECTED: This branch has conflicts with '$MAIN_BRANCH'." >&2
+    echo "   Please resolve them manually (e.g., 'git pull origin $MAIN_BRANCH') before proceeding." >&2
+    exit 1
+  fi
+  echo "✅ No merge conflicts detected."
+}
+
+# ---
+# WHAT:  Checks if a given file is a text-based file and not a binary.
+# WHY:   Prevents scripts from attempting to 'cat' binary files (like images
+#        or executables) into a text-based report, which would corrupt it.
+# FROM:  context_export_all.sh, context_export_docs.sh, context_export.sh
+# USAGE: if is_text_file "path/to/file.md"; then ... fi
+# ---
+is_text_file() {
+  local file_path="$1"
+  # The 'file' command inspects the content, and we grep for keywords
+  # that indicate it's safe to treat as text.
+  if file "$file_path" | grep -E -q 'text|script|JSON|XML|YAML|HTML|CSS|Markdown|empty'; then
+    return 0 # Success (it is a text file)
+  else
+    return 1 # Failure (it is not a text file)
+  fi
+}
+
+# WHAT:  Creates a new report file, prepending it with a custom prompt if one
+#        exists, or a generic default prompt if it does not.
+# WHY:   Standardizes the creation of all context export files, ensuring they
+#        are always formatted correctly for AI analysis.
+# FROM:  context_export_automation.sh, context_export_code.sh, etc.
+# USAGE: generate_report_header "path/to/output.md" "path/to/custom_prompt.md" "Default Prompt Title" "Default Prompt Body"
+# ---
+generate_report_header() {
+  local output_file="$1"
+  local custom_prompt_file="$2"
+  local default_title="$3"
+  local default_body="$4"
+
+  if [ -f "$custom_prompt_file" ]; then
+    echo "--> Using custom prompt from '$custom_prompt_file'."
+    cat "$custom_prompt_file" > "$output_file"
+  else
+    echo "--> Custom prompt not found. Using default."
+    {
+      echo "# AI Prompt: $default_title"
+      echo ""
+      echo "## Your Role"
+      echo "$default_body"
+      echo ""
+      echo "## The Task"
+      echo "Review the following export to gain a complete understanding of the requested context. Acknowledge that you are up-to-date and ready for the next instruction."
+    } > "$output_file"
+  fi
+
+  # Append the standard export header after the prompt
+  {
+    echo ""
+    echo "---"
+    echo "# Automation Framework Export"
+    echo ""
+    echo "**Branch:** \`$(git rev-parse --abbrev-ref HEAD)\`"
+    echo "**Generated:** $(date)"
+    echo ""
+    echo "---"
+  } >> "$output_file"
+}
diff --git a/scripts/clean.sh b/factory/scripts/clean.sh
similarity index 100%
rename from scripts/clean.sh
rename to factory/scripts/clean.sh
diff --git a/scripts/commit.sh b/factory/scripts/commit.sh
similarity index 100%
rename from scripts/commit.sh
rename to factory/scripts/commit.sh
diff --git a/factory/scripts/context.sh b/factory/scripts/context.sh
new file mode 100755
index 0000000..2a96636
--- /dev/null
+++ b/factory/scripts/context.sh
@@ -0,0 +1,67 @@
+#!/bin/bash
+# scripts/context.sh (v3 - Standalone Script Controller)
+#
+# WHAT: A master script for context generation. It acts as a router, calling
+#       the correct standalone script based on the user's goal.
+# WHY:  Provides a single entry point (`task context`) while keeping all
+#       implementation logic in dedicated, single-responsibility files.
+
+set -e
+
+# --- The Interactive Menu ---
+# This function displays the menu and calls the appropriate standalone script.
+show_menu() {
+  echo
+  echo "Please select a context generation goal:"
+  PS3="Your choice: "
+  options=(
+    "For a Commit Message"
+    "For a Pull Request Description"
+    "For Quick Verification"
+    "Export: Code Only"
+    "Export: Automation Only"
+    "Export: Documentation Only"
+    "Export: Full Project (All)"
+    "Quit"
+  )
+  select opt in "${options[@]}"; do
+    case $opt in
+      "For a Commit Message")         ./scripts/context_commit.sh; break ;;
+      "For a Pull Request Description") ./scripts/context_pr.sh; break ;;
+      "For Quick Verification")         ./scripts/context_verify.sh; break ;;
+      "Export: Code Only")            ./scripts/context_export_code.sh; break ;;
+      "Export: Automation Only")        ./scripts/context_export_automation.sh; break ;;
+      "Export: Documentation Only")     ./scripts/context_export_docs.sh; break ;;
+      "Export: Full Project (All)")   ./scripts/context_export_all.sh; break ;;
+      "Quit")                         echo "Aborted."; break ;;
+      *)                              echo "Invalid option $REPLY";;
+    esac
+  done
+}
+
+# --- Main Controller Logic ---
+MODE=$1
+case "$MODE" in
+  # --- Parameterized Modes for Automation ---
+  commit)            ./scripts/context_commit.sh ;;
+  pr)                ./scripts/context_pr.sh ;;
+  verify)            ./scripts/context_verify.sh ;;
+  export-code)       ./scripts/context_export_code.sh ;;
+  export-automation) ./scripts/context_export_automation.sh ;;
+  export-docs)       ./scripts/context_export_docs.sh ;;
+  export-all)        ./scripts/context_export_all.sh ;;
+
+  # --- Interactive Mode ---
+  "")
+    show_menu
+    ;;
+
+  # --- Error Case ---
+  *)
+    echo "❌ ERROR: Invalid mode '$MODE' provided." >&2
+    echo "   Valid modes are: commit, pr, verify, export-code, export-automation, export-docs, export-all" >&2
+    exit 1
+    ;;
+esac
+
+exit 0
\ No newline at end of file
diff --git a/factory/scripts/context_commit.sh b/factory/scripts/context_commit.sh
new file mode 100755
index 0000000..779a93e
--- /dev/null
+++ b/factory/scripts/context_commit.sh
@@ -0,0 +1,25 @@
+#!/bin/bash
+# scripts/status_commit.sh
+# Generates context for a commit message (uncommitted changes only).
+
+set -e
+
+OUTPUT_FILE="contextvibes_status.md"
+
+echo "--> Generating report with commit message prompt..."
+cat ./docs/prompts/generate-commit-message.md > "$OUTPUT_FILE"
+
+echo "## Uncommitted Local Changes" >> "$OUTPUT_FILE"
+echo "" >> "$OUTPUT_FILE"
+echo '```' >> "$OUTPUT_FILE"
+git status >> "$OUTPUT_FILE"
+echo '```' >> "$OUTPUT_FILE"
+echo "" >> "$OUTPUT_FILE"
+echo "---" >> "$OUTPUT_FILE"
+echo "## Diff of Uncommitted Changes" >> "$OUTPUT_FILE"
+echo '```diff' >> "$OUTPUT_FILE"
+git diff --staged >> "$OUTPUT_FILE"
+git diff >> "$OUTPUT_FILE"
+echo '```' >> "$OUTPUT_FILE"
+
+echo "✅ Report with commit prompt saved to '$OUTPUT_FILE'."
\ No newline at end of file
diff --git a/factory/scripts/context_export.sh b/factory/scripts/context_export.sh
new file mode 100755
index 0000000..8610b2b
--- /dev/null
+++ b/factory/scripts/context_export.sh
@@ -0,0 +1,123 @@
+#!/bin/bash
+# scripts/status_export.sh
+# Generates the most comprehensive project snapshot for an LLM.
+# It intelligently uses a custom prompt if it exists, otherwise falls back to a default.
+
+set -e
+
+OUTPUT_FILE="contextvibes_status.md"
+MAIN_BRANCH="main"
+CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
+CUSTOM_PROMPT_PATH="docs/prompts/export-project-context.md"
+
+echo "--> Generating comprehensive project export..."
+
+# --- Header and Prompt ---
+# Check for a custom prompt file first. If it exists, use it.
+if [ -f "$CUSTOM_PROMPT_PATH" ]; then
+  echo "--> Found custom prompt at '$CUSTOM_PROMPT_PATH'. Using it."
+  cat "$CUSTOM_PROMPT_PATH" > "$OUTPUT_FILE"
+else
+  # Otherwise, use the built-in default prompt.
+  echo "--> Custom prompt not found. Using default."
+  {
+    echo "# AI Prompt: Full Project Context Analysis"
+    echo ""
+    echo "## Your Role"
+    echo "You are an expert AI pair programmer. Your task is to analyze the following comprehensive project export to get a complete and up-to-date understanding of the repository's current state."
+    echo ""
+    echo "## The Task"
+    echo "Read and fully absorb all the provided information. This is the ground truth of the project from now on. Acknowledge that you are up-to-date and ready for the next instruction."
+  } > "$OUTPUT_FILE"
+fi
+
+# Append the standard export header and content to the file.
+{
+  echo ""
+  echo "---"
+  echo "# Comprehensive Project Export"
+  echo ""
+  echo "**Branch:** \`$CURRENT_BRANCH\`"
+  echo "**Generated:** $(date)"
+  echo ""
+  echo "---"
+} >> "$OUTPUT_FILE"
+
+# --- Git Status Section ---
+{
+  echo "## 1. Uncommitted Local Changes"
+  echo '```'
+  if [[ -z $(git status --porcelain) ]]; then
+    echo "No uncommitted local changes. The working directory is clean."
+  else
+    git status
+  fi
+  echo '```'
+  echo ""
+  echo "---"
+} >> "$OUTPUT_FILE"
+
+# --- New Work Section ---
+if [ "$CURRENT_BRANCH" != "$MAIN_BRANCH" ]; then
+  MERGE_BASE=$(git merge-base "$MAIN_BRANCH" HEAD)
+  {
+    echo "## 2. New Work on This Branch (Compared to \`$MAIN_BRANCH\`)"
+    echo ""
+    if [ "$(git rev-list --count $MERGE_BASE..HEAD)" -eq 0 ]; then
+      echo "No new commits found on this branch compared to \`$MAIN_BRANCH\`."
+    else
+      echo "**Commit History:**"
+      echo '```'
+      git log --oneline $MERGE_BASE..HEAD
+      echo '```'
+    fi
+    echo ""
+    echo "---"
+  } >> "$OUTPUT_FILE"
+fi
+
+# --- Project Structure Section ---
+{
+  echo "## 3. Project Structure"
+  echo ""
+  echo '```'
+  tree -a -I '.git|.task|bin|node_modules|.venv|__pycache__|*.log|contextvibes_*.md'
+  echo '```'
+  echo ""
+  echo "---"
+} >> "$OUTPUT_FILE"
+
+# --- Full Content of All Tracked Files Section ---
+# This section dynamically finds every file tracked by Git and cats its content.
+echo "## 4. Full Content of All Tracked Files" >> "$OUTPUT_FILE"
+
+# Use 'git ls-files' to get a definitive list of all tracked files.
+git ls-files | while read -r file; do
+    # Check if the file is a binary, non-text, or empty. All are safe to process.
+    # We use an extended grep to look for multiple keywords that indicate a non-binary file.
+    # CRITICAL: We now include 'empty' as a valid type to handle empty files correctly.
+    if ! file "$file" | grep -E -q 'text|script|JSON|XML|YAML|HTML|CSS|Markdown|empty'; then
+        echo "--> Skipping binary file: $file"
+        continue
+    fi
+    
+    # We must also ensure we don't include the output file itself.
+    if [ "$file" == "$OUTPUT_FILE" ]; then
+        continue
+    fi
+
+    {
+      echo ""
+      echo "======== FILE: ${file} ========"
+      # Use a language hint for markdown code blocks if possible.
+      extension="${file##*.}"
+      echo "\`\`\`${extension}"
+      # Use `cat` to append the file's content.
+      cat "$file"
+      echo '```'
+      echo "======== END FILE: ${file} ========"
+    } >> "$OUTPUT_FILE"
+done
+
+
+echo "✅ Comprehensive export complete. Report saved to '$OUTPUT_FILE'."
\ No newline at end of file
diff --git a/factory/scripts/context_export_all.sh b/factory/scripts/context_export_all.sh
new file mode 100755
index 0000000..fed6e56
--- /dev/null
+++ b/factory/scripts/context_export_all.sh
@@ -0,0 +1,96 @@
+#!/bin/bash
+# Filename: factory/scripts/context_export_all.sh
+#
+# WHAT: Exports a comprehensive snapshot of the entire project, organized
+#       by our "Product, Library, Factory" architectural model.
+# WHY:  Provides a complete, structured context file for high-level AI
+#       analysis, onboarding, or architectural review. This version is
+#       "root-aware" and will function correctly even when run from a subdirectory.
+
+set -e
+# Source the single source of truth for all helper functions and variables.
+source "$(dirname "$0")/_automation_helpers.sh"
+
+# --- Configuration ---
+# Programmatically find the absolute path to the project's root directory.
+# This makes all subsequent paths robust and independent of the execution directory.
+readonly GIT_ROOT=$(git rev-parse --show-toplevel)
+
+# Define file paths relative to the newly found GIT_ROOT.
+readonly OUTPUT_FILE="$GIT_ROOT/contextvibes_export_project.md"
+readonly PROMPT_FILE="$GIT_ROOT/$PROMPTS_DIR/export-project-context.md"
+
+# --- Main Logic ---
+
+echo "--> Generating full project export..."
+
+# Use the helper function to create the report file with a custom or default prompt.
+# This now uses the full, absolute path to the output and prompt files.
+generate_report_header \
+  "$OUTPUT_FILE" \
+  "$PROMPT_FILE" \
+  "Full Project Context Analysis" \
+  "You are an expert AI systems architect. Your task is to analyze the following comprehensive project export to build a complete mental model of the repository's architecture, purpose, and implementation."
+
+# ---
+# WHAT:  A local helper function to find all tracked, text-based files in a
+#        given set of paths and append them to the report under a "Book" heading.
+# ---
+export_book() {
+  local title="$1"
+  shift # Remove the title from the arguments, leaving only the paths
+  local paths=("$@")
+  local files
+
+  # Use `git -C` to run the command from the context of the GIT_ROOT.
+  # This ensures it finds the correct files (e.g., "thea/", not "factory/thea/").
+  files=$(git -C "$GIT_ROOT" ls-files -- "${paths[@]}")
+
+  # Append the book header to the main output file
+  { echo ""; echo "---"; echo "## Book: ${title}"; echo ""; } >> "$OUTPUT_FILE"
+
+  # Process each file found by Git
+  echo "$files" | while read -r file; do
+    # Construct the full, absolute path for file system operations like `cat` and `is_text_file`.
+    local full_path="$GIT_ROOT/$file"
+
+    # Skip if the file doesn't exist or is not a text file
+    if [ ! -f "$full_path" ] || ! is_text_file "$full_path"; then
+      echo "--> Skipping non-text file: $file"
+      continue
+    fi
+
+    # Append the file's content, wrapped in markdown code blocks.
+    # The header uses the clean, relative path for readability. The `cat` uses the full path.
+    {
+      echo ""
+      echo "======== FILE: ${file} ========"
+      echo "\`\`\`${file##*.}"
+      cat "$full_path"
+      echo "\`\`\`"
+      echo "======== END FILE: ${file} ========"
+    } >> "$OUTPUT_FILE"
+  done
+}
+
+#
+# --- Execute the Export ---
+#
+# The paths here are relative to the GIT_ROOT, as expected by the `git -C` command.
+# This aligns perfectly with our "Product, Library, Factory" model.
+#
+
+export_book "The Product (Core THEA Guidance)" \
+  "README.md" \
+  "CHANGELOG.md" \
+  "thea/"
+
+export_book "The Library (Project & Process Documentation)" \
+  "docs/"
+
+export_book "The Factory (Automation Framework & Environment)" \
+  "Taskfile.yml" \
+  ".github/" \
+  "factory/"
+
+echo "✅ Full project export complete. Report saved to '$OUTPUT_FILE'."
diff --git a/factory/scripts/context_export_automation.sh b/factory/scripts/context_export_automation.sh
new file mode 100755
index 0000000..3cd6724
--- /dev/null
+++ b/factory/scripts/context_export_automation.sh
@@ -0,0 +1,98 @@
+#!/bin/bash
+# scripts/context_export_automation.sh (VERSION 7 - REFACTORED)
+#
+# WHY: Generates a focused snapshot of the project's automation framework.
+# WHAT: Uses the central helper script to handle all common logic, then
+#       gathers and appends the specific automation files to the report.
+
+set -e
+# Source the single source of truth for all helper functions and variables.
+source "$(dirname "$0")/_automation_helpers.sh"
+
+# --- Phase 1: State Verification ---
+echo "--> Verifying repository state..."
+# All complex checks are now handled by the helper script.
+ensure_clean_workspace # Or use another helper like prompt_to_stash_if_dirty if preferred
+
+# --- Phase 2: Report Generation ---
+OUTPUT_FILE="contextvibes_export_automation.md"
+PROMPT_FILE="$PROMPTS_DIR/export-automation-context.md"
+
+echo "--> Generating focused automation export to '$OUTPUT_FILE'..."
+
+# Use the new helper function to create the report with the correct prompt.
+generate_report_header \
+  "$OUTPUT_FILE" \
+  "$PROMPT_FILE" \
+  "Analyze Automation Framework" \
+  "You are an expert DevOps engineer and automation specialist."
+
+# --- Phase 3: Append Automation-Specific Content ---
+# The rest of the script now only does work unique to THIS script.
+
+# Section 1: Uncommitted Local Changes
+{
+  echo "## 1. Uncommitted Local Changes"
+  echo '```'
+  git status
+  echo '```'
+  echo ""
+  echo "---"
+} >> "$OUTPUT_FILE"
+
+# Section 2: Project Manifest
+{
+  echo "## 2. Project Manifest"
+  echo "Status: [T]=Tracked, [U]=Untracked, [I]=Ignored"
+  echo '```'
+  find . -not -path '*/.git/*' -not -name '.' | sort | while read -r file; do
+    if [ -z "$file" ]; then continue; fi
+    status="U"
+    if git check-ignore -q "$file"; then status="I";
+    elif git ls-files --error-unmatch "$file" >/dev/null 2>&1; then status="T"; fi
+    indent_level=$(echo "$file" | tr -cd '/' | wc -c)
+    indent=$(printf '%*s' $((indent_level * 2)) '')
+    printf "[%s] %s%s\n" "$status" "$indent" "$(basename "$file")"
+  done
+  echo '```'
+  echo ""
+  echo "---"
+} >> "$OUTPUT_FILE"
+
+# Section 3: Core Automation Files
+echo "## 3. Core Automation Files" >> "$OUTPUT_FILE"
+CORE_FILES=( "README.md" "Taskfile.yml" )
+CORE_DIRS=( "scripts" "tasks" )
+
+for file in "${CORE_FILES[@]}"; do
+  if [ -f "$file" ] && is_text_file "$file"; then
+    {
+      echo ""
+      echo "======== FILE: ${file} ========"
+      echo '```'
+      cat "$file"
+      echo '```'
+      echo "======== END FILE: ${file} ========"
+    } >> "$OUTPUT_FILE"
+  fi
+done
+
+for dir in "${CORE_DIRS[@]}"; do
+  if [ -d "$dir" ]; then
+    find "$dir" -type f | sort | while read -r file; do
+      if is_text_file "$file"; then
+        {
+          echo ""
+          echo "======== FILE: ${file} ========"
+          lang="${file##*.}"
+          echo "\`\`\`${lang}"
+          cat "$file"
+          echo '```'
+          echo "======== END FILE: ${file} ========"
+        } >> "$OUTPUT_FILE"
+      fi
+    done
+  fi
+done
+
+echo "✅ Focused automation export complete. Report saved to '$OUTPUT_FILE'."
diff --git a/factory/scripts/context_export_code.sh b/factory/scripts/context_export_code.sh
new file mode 100755
index 0000000..2ce12d6
--- /dev/null
+++ b/factory/scripts/context_export_code.sh
@@ -0,0 +1,33 @@
+#!/bin/bash
+# WHAT: Exports only the application source code.
+set -e
+
+OUTPUT_FILE="contextvibes_export_code.md"
+CUSTOM_PROMPT_PATH="docs/prompts/export-code-context.md"
+FALLBACK_PROMPT_PATH="docs/prompts/export-project-context.md"
+
+echo "--> Generating Code export..."
+
+# --- Use the specific prompt if it exists, otherwise use the fallback ---
+if [ -f "$CUSTOM_PROMPT_PATH" ]; then
+  echo "--> Using specific code prompt: $CUSTOM_PROMPT_PATH"
+  cat "$CUSTOM_PROMPT_PATH" > "$OUTPUT_FILE"
+else
+  echo "--> Specific prompt not found. Using fallback: $FALLBACK_PROMPT_PATH"
+  cat "$FALLBACK_PROMPT_PATH" > "$OUTPUT_FILE"
+fi
+
+# --- Append the file content ---
+echo "" >> "$OUTPUT_FILE" && echo "---" >> "$OUTPUT_FILE"
+echo "## Book: The Application (Code)" >> "$OUTPUT_FILE"
+
+git ls-files cmd/ internal/ go.mod go.sum | while read -r file; do
+  if [ -f "$file" ]; then
+    echo "" >> "$OUTPUT_FILE" && echo "======== FILE: ${file} ========" >> "$OUTPUT_FILE"
+    echo "\`\`\`${file##*.}" >> "$OUTPUT_FILE"
+    cat "$file" >> "$OUTPUT_FILE"
+    echo "\`\`\`" >> "$OUTPUT_FILE" && echo "======== END FILE: ${file} ========" >> "$OUTPUT_FILE"
+  fi
+done
+
+echo "✅ Code export complete. Report saved to '$OUTPUT_FILE'."
diff --git a/factory/scripts/context_export_docs.sh b/factory/scripts/context_export_docs.sh
new file mode 100755
index 0000000..54e8c54
--- /dev/null
+++ b/factory/scripts/context_export_docs.sh
@@ -0,0 +1,41 @@
+#!/bin/bash
+# WHAT: Exports only the documentation and guidance files.
+set -e
+
+OUTPUT_FILE="contextvibes_export_docs.md"
+CUSTOM_PROMPT_PATH="docs/prompts/export-docs-context.md"
+FALLBACK_PROMPT_PATH="docs/prompts/export-project-context.md"
+
+echo "--> Generating Documentation & Guidance export..."
+
+# --- Use the specific prompt if it exists, otherwise use the fallback ---
+if [ -f "$CUSTOM_PROMPT_PATH" ]; then
+  echo "--> Using specific documentation prompt: $CUSTOM_PROMPT_PATH"
+  cat "$CUSTOM_PROMPT_PATH" > "$OUTPUT_FILE"
+else
+  echo "--> Specific prompt not found. Using fallback: $FALLBACK_PROMPT_PATH"
+  cat "$FALLBACK_PROMPT_PATH" > "$OUTPUT_FILE"
+fi
+
+# --- Helper function to export a "book" of files ---
+export_book() {
+  local title="$1"; shift
+  local files
+  files=$(git ls-files "$@")
+  
+  { echo ""; echo "---"; echo "## Book: ${title}"; echo ""; } >> "$OUTPUT_FILE"
+
+  echo "$files" | while read -r file; do
+    if [ ! -f "$file" ]; then continue; fi
+    if ! file "$file" | grep -E -q 'text|script|JSON|XML|YAML|HTML|CSS|Markdown|empty'; then
+        echo "--> Skipping binary file: $file"
+        continue
+    fi
+    { echo ""; echo "======== FILE: ${file} ========"; echo "\`\`\`${file##*.}"; cat "$file"; echo "\`\`\`"; echo "======== END FILE: ${file} ========"; } >> "$OUTPUT_FILE"
+  done
+}
+
+# --- Define the documentation files and directories to be exported ---
+export_book "The Library (Documentation & Guidance)" README.md CHANGELOG.md docs/ playbooks/
+
+echo "✅ Documentation export complete. Report saved to '$OUTPUT_FILE'."
\ No newline at end of file
diff --git a/factory/scripts/context_pr.sh b/factory/scripts/context_pr.sh
new file mode 100755
index 0000000..f728975
--- /dev/null
+++ b/factory/scripts/context_pr.sh
@@ -0,0 +1,31 @@
+#!/bin/bash
+# scripts/status_pr.sh
+# Generates context for a pull request (all changes on branch vs. main).
+
+set -e
+
+OUTPUT_FILE="contextvibes_status.md"
+MAIN_BRANCH="main"
+
+if ! git diff --quiet --exit-code; then
+  echo "⚠️  Warning: You have uncommitted changes. They will not be included in the PR description."
+fi
+
+MERGE_BASE=$(git merge-base $MAIN_BRANCH HEAD)
+
+echo "--> Generating report with PR description prompt..."
+cat ./docs/prompts/generate-pr-description.md > "$OUTPUT_FILE"
+
+echo "## New Work on This Branch (Compared to \`$MAIN_BRANCH\`)" >> "$OUTPUT_FILE"
+echo "" >> "$OUTPUT_FILE"
+echo "**Commit History:**" >> "$OUTPUT_FILE"
+echo '```' >> "$OUTPUT_FILE"
+git log --pretty=format:'%h %s (%an, %cr)' $MERGE_BASE..HEAD >> "$OUTPUT_FILE"
+echo '```' >> "$OUTPUT_FILE"
+echo "" >> "$OUTPUT_FILE"
+echo "**Detailed file changes (diff):**" >> "$OUTPUT_FILE"
+echo '```diff' >> "$OUTPUT_FILE"
+git diff $MERGE_BASE..HEAD >> "$OUTPUT_FILE"
+echo '```' >> "$OUTPUT_FILE"
+
+echo "✅ Report with PR prompt saved to '$OUTPUT_FILE'."
\ No newline at end of file
diff --git a/factory/scripts/context_verify.sh b/factory/scripts/context_verify.sh
new file mode 100755
index 0000000..fe39494
--- /dev/null
+++ b/factory/scripts/context_verify.sh
@@ -0,0 +1,62 @@
+#!/bin/bash
+# scripts/status_verify.sh
+# Generates a focused report of all recent changes for AI verification.
+# This includes uncommitted changes and new commits on the current branch.
+
+set -e
+
+OUTPUT_FILE="contextvibes_status.md"
+MAIN_BRANCH="main"
+CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
+
+# --- Header and AI Prompt ---
+{
+  echo "# AI Prompt: Verification of Changes"
+  echo ""
+  echo "## Your Role"
+  echo "You are an expert AI pair programmer acting as a code reviewer."
+  echo ""
+  echo "## The Task"
+  echo "Carefully analyze the following git status and aggregated diff. Verify that the changes accurately reflect the instructions I just gave you. Confirm if the implementation is correct or point out any discrepancies."
+  echo ""
+  echo "---"
+  echo "# Verification Report"
+  echo ""
+  echo "**Branch:** \`$CURRENT_BRANCH\`"
+  echo "**Generated:** $(date -u)"
+  echo ""
+  echo "---"
+} > "$OUTPUT_FILE"
+
+# --- 1. Uncommitted Changes Summary ---
+{
+  echo "## 1. Uncommitted Local Changes"
+  echo '```'
+  if [[ -z $(git status --porcelain) ]]; then
+    echo "No uncommitted local changes."
+  else
+    git status
+  fi
+  echo '```'
+  echo ""
+  echo "---"
+} >> "$OUTPUT_FILE"
+
+# --- 2. Aggregated Diff (Committed + Uncommitted) ---
+{
+  echo "## 2. Aggregated Diff of All Changes vs \`$MAIN_BRANCH\`"
+  echo '```diff'
+  
+  # Define the merge base to compare against.
+  MERGE_BASE=$(git merge-base $MAIN_BRANCH HEAD)
+
+  # First, show the diff of all committed changes on this branch.
+  git diff $MERGE_BASE..HEAD
+  
+  # Second, show the diff of all uncommitted (staged and unstaged) changes.
+  git diff HEAD
+
+  echo '```'
+} >> "$OUTPUT_FILE"
+
+echo "✅ Verification report generated. Saved to '$OUTPUT_FILE'."
\ No newline at end of file
diff --git a/scripts/finish_task.sh b/factory/scripts/finish_task.sh
similarity index 100%
rename from scripts/finish_task.sh
rename to factory/scripts/finish_task.sh
diff --git a/scripts/generate_playbook_menu.sh b/factory/scripts/generate_playbook_menu.sh
similarity index 100%
rename from scripts/generate_playbook_menu.sh
rename to factory/scripts/generate_playbook_menu.sh
diff --git a/scripts/generate_prompt_menu.sh b/factory/scripts/generate_prompt_menu.sh
similarity index 100%
rename from scripts/generate_prompt_menu.sh
rename to factory/scripts/generate_prompt_menu.sh
diff --git a/scripts/start_task.sh b/factory/scripts/start_task.sh
similarity index 61%
rename from scripts/start_task.sh
rename to factory/scripts/start_task.sh
index d0f87b5..b071e08 100755
--- a/scripts/start_task.sh
+++ b/factory/scripts/start_task.sh
@@ -1,10 +1,10 @@
 #!/bin/bash
-# scripts/start_task.sh (FINAL, STATE-AWARE VERSION)
+# scripts/start_task.sh (VERSION 2 - WITH BRANCH NAME VALIDATION)
 #
 # WHY:  Handles starting a new feature branch safely and intelligently.
-# WHAT: Checks for uncommitted changes. If found, it asks the user for
-#       permission to stash them and carry them over to the new branch.
-# HOW:  Uses git commands and an interactive 'read' prompt.
+# WHAT: Checks for uncommitted changes and validates the new branch name
+#       against the project's conventions before creating it.
+# HOW:  Uses git commands, an interactive 'read' prompt, and regex matching.
 
 set -e
 
@@ -24,7 +24,7 @@ if ! git diff --quiet --exit-code; then
   fi
 fi
 
-# --- Phase 2: Branch Creation ---
+# --- Phase 2: Branch Creation & Validation ---
 # Validate that a branch name was provided.
 if [ -z "$1" ]; then
   echo "❌ ERROR: You must provide a name for the new feature branch."
@@ -35,6 +35,17 @@ if [ -z "$1" ]; then
 fi
 
 BRANCH_NAME=$1
+BRANCH_PATTERN="^((feature|fix|docs|format)/.+)$"
+
+# --- NEW: Validate the branch name against the pattern ---
+if [[ ! "$BRANCH_NAME" =~ $BRANCH_PATTERN ]]; then
+  echo "❌ ERROR: Invalid branch name: '$BRANCH_NAME'"
+  echo "   Branches must follow the pattern: type/description"
+  echo "   Valid types are: feature, fix, docs, format"
+  echo "   Example: task task-start -- feature/new-context-menu"
+  if [ "$STASH_PERFORMED" = true ]; then git stash pop; fi
+  exit 1
+fi
 
 echo "--> Creating and switching to new branch '$BRANCH_NAME'..."
 git checkout -b "$BRANCH_NAME"
diff --git a/factory/tasks/README.md b/factory/tasks/README.md
new file mode 100644
index 0000000..f54d09b
--- /dev/null
+++ b/factory/tasks/README.md
@@ -0,0 +1,63 @@
+Excellent point, Kernel. A project of this complexity requires clear documentation at every level. The `tasks/` directory is the crucial link between the user-facing `Taskfile.yml` and the implementation logic in `scripts/`, so it absolutely deserves its own `README.md`.
+
+This file will complete our documentation hierarchy, ensuring that any developer can understand the framework's design from top to bottom.
+
+Here is a `README.md` crafted for the `tasks/` directory. It is designed to work in concert with the root and `scripts/` READMEs.
+
+---
+
+### `tasks/README.md`
+
+```markdown
+# Tasks Directory
+
+## 1. Purpose
+
+This directory contains the individual `Taskfile` configurations that are included by the root `Taskfile.yml`. Each file in this directory corresponds to a high-level command available to the user (e.g., `_commit.yml` implements the `task commit` command).
+
+## 2. Role in the Automation Framework
+
+Our framework follows a "Menu / Workflow / Action" design pattern to ensure clarity and separation of concerns. This directory represents the **"Workflow"** layer.
+
+*   **Menu (`/Taskfile.yml`):** The user-facing command menu. It defines *what* commands are available. It acts as a clean, high-level facade.
+*   **Workflow (`tasks/*.yml`):** This directory. It defines *how* a menu command is connected to its implementation. It's the bridge between the user's intent and the underlying logic.
+*   **Action (`scripts/*.sh`):** The implementation layer. The shell scripts contain the actual logic that performs the work.
+
+This structure keeps the root `Taskfile.yml` simple and readable, while the files in this directory provide the necessary wiring to the scripts.
+
+## 3. File Naming and Structure
+
+*   **Naming Convention:** All files must be prefixed with an underscore (e.g., `_commit.yml`, `_context.yml`). This is a standard `Task` convention that prevents the tasks within these files from appearing in the main `task --list` output, keeping the user-facing menu clean.
+*   **Structure:** Each file is a standard `Taskfile` that defines one or more tasks. Typically, a file like `_commit.yml` will define a single task named `commit`.
+
+## 4. Passing Arguments to Scripts
+
+A critical responsibility of the tasks defined in this directory is to forward any command-line arguments to the underlying scripts. We use a standard pattern for this.
+
+**The Pattern:**
+```yaml
+# tasks/_commit.yml
+version: '3'
+
+tasks:
+  commit:
+    desc: "(Action) Stages all changes and then commits them via a script."
+    silent: true
+    cmds:
+      # Call the script, passing all command-line arguments through.
+      - ./scripts/commit.sh {{.CLI_ARGS}}
+```
+
+The `{{.CLI_ARGS}}` variable is a feature of Go Task that captures all arguments passed after a `--` on the command line. This allows a user to run `task commit -- -m "My commit message"` and have the `-m "..."` part passed directly to `scripts/commit.sh`.
+
+## 5. How to Add a New Task
+
+To add a new command to the framework:
+
+1.  **Create the Script:** Implement the core logic in a new shell script in the `scripts/` directory.
+2.  **Create the Task File:** Create a new file in this directory, named `_your_task_name.yml`.
+3.  **Define the Task:** Inside your new `.yml` file, define the task that calls your script, ensuring you pass `{{.CLI_ARGS}}`.
+4.  **Include the Task File:** Open the root `Taskfile.yml` and add your new file to the `includes:` block.
+5.  **Create the Facade:** In the root `Taskfile.yml`, add the user-facing facade task that delegates to your new task (e.g., `your-task: task: _your_task_name:your-task`).
+6.  **Update the Help Menu:** Add your new command to the `default` task's help menu in the root `Taskfile.yml` so it is discoverable by users.
+```
diff --git a/tasks/_analyze.yml b/factory/tasks/_analyze.yml
similarity index 100%
rename from tasks/_analyze.yml
rename to factory/tasks/_analyze.yml
diff --git a/tasks/_build.yml b/factory/tasks/_build.yml
similarity index 100%
rename from tasks/_build.yml
rename to factory/tasks/_build.yml
diff --git a/tasks/_clean.yml b/factory/tasks/_clean.yml
similarity index 100%
rename from tasks/_clean.yml
rename to factory/tasks/_clean.yml
diff --git a/tasks/_commit.yml b/factory/tasks/_commit.yml
similarity index 100%
rename from tasks/_commit.yml
rename to factory/tasks/_commit.yml
diff --git a/factory/tasks/_context.yml b/factory/tasks/_context.yml
new file mode 100644
index 0000000..286fe57
--- /dev/null
+++ b/factory/tasks/_context.yml
@@ -0,0 +1,14 @@
+# tasks/_context.yml
+# WHAT: This file is the facade for all context-generation commands.
+# WHY:  It provides a single, consistent helper task that forwards all
+#       arguments to the main context controller script.
+
+version: '3'
+
+tasks:
+  # This single helper task is called by all `context:*` tasks in the root Taskfile.
+  # It receives the specific mode (e.g., 'commit', 'export-code') via CLI_ARGS.
+  helper:
+    internal: true
+    cmds:
+      - ./scripts/context.sh {{.CLI_ARGS}}
\ No newline at end of file
diff --git a/tasks/_deploy.yml b/factory/tasks/_deploy.yml
similarity index 100%
rename from tasks/_deploy.yml
rename to factory/tasks/_deploy.yml
diff --git a/tasks/_destroy.yml b/factory/tasks/_destroy.yml
similarity index 100%
rename from tasks/_destroy.yml
rename to factory/tasks/_destroy.yml
diff --git a/tasks/_init.yml b/factory/tasks/_init.yml
similarity index 100%
rename from tasks/_init.yml
rename to factory/tasks/_init.yml
diff --git a/tasks/_provision.yml b/factory/tasks/_provision.yml
similarity index 100%
rename from tasks/_provision.yml
rename to factory/tasks/_provision.yml
diff --git a/factory/tasks/_release.yml b/factory/tasks/_release.yml
new file mode 100644
index 0000000..40d2a1d
--- /dev/null
+++ b/factory/tasks/_release.yml
@@ -0,0 +1,19 @@
+# tasks/_release.yml (PLACEHOLDER)
+# This file defines the placeholder task for creating a new versioned release.
+version: '3'
+
+tasks:
+  release:
+    desc: "(Info) Explains that this is a placeholder for the release process."
+    # This task is internal because the user-facing command is in the root Taskfile.
+    internal: true
+    silent: true
+    cmds:
+      - |
+        echo
+        echo "--> INFO: This is a placeholder for the 'release' task."
+        echo "    The full release process, including building and publishing artifacts,"
+        echo "    will be implemented here."
+        echo
+        echo "    It would receive arguments like: {{.CLI_ARGS}}"
+        echo
diff --git a/tasks/_run.yml b/factory/tasks/_run.yml
similarity index 100%
rename from tasks/_run.yml
rename to factory/tasks/_run.yml
diff --git a/tasks/_task-finish.yml b/factory/tasks/_task-finish.yml
similarity index 100%
rename from tasks/_task-finish.yml
rename to factory/tasks/_task-finish.yml
diff --git a/tasks/_task-start.yml b/factory/tasks/_task-start.yml
similarity index 100%
rename from tasks/_task-start.yml
rename to factory/tasks/_task-start.yml
diff --git a/tasks/_test.yml b/factory/tasks/_test.yml
similarity index 100%
rename from tasks/_test.yml
rename to factory/tasks/_test.yml
diff --git a/tasks/_update.yml b/factory/tasks/_update.yml
similarity index 100%
rename from tasks/_update.yml
rename to factory/tasks/_update.yml
diff --git a/tasks/_verify.yml b/factory/tasks/_verify.yml
similarity index 100%
rename from tasks/_verify.yml
rename to factory/tasks/_verify.yml
diff --git a/scripts/export_codebase.sh b/scripts/export_codebase.sh
deleted file mode 100755
index ece9136..0000000
--- a/scripts/export_codebase.sh
+++ /dev/null
@@ -1,99 +0,0 @@
-#!/bin/bash
-# scripts/export_codebase.sh
-#
-# WHY: Generates the most comprehensive project snapshot for an LLM.
-# WHAT: It captures the full git status (local and vs. main), the project
-#       structure, and the content of all key configuration and guidance files.
-# HOW: Uses git, tree, and cat commands, appending each section to the output.
-
-set -e
-
-OUTPUT_FILE="contextvibes_export.md"
-MAIN_BRANCH="main"
-CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
-
-echo "--> Generating comprehensive project export to '$OUTPUT_FILE'..."
-
-# --- Header ---
-{
-  echo "# Comprehensive Project Export"
-  echo ""
-  echo "**Branch:** \`$CURRENT_BRANCH\`"
-  echo "**Generated:** $(date)"
-  echo ""
-  echo "---"
-} > "$OUTPUT_FILE"
-
-# --- Section 1: Git Status (What's New?) ---
-{
-  echo "## 1. Uncommitted Local Changes"
-  echo '```'
-  if [[ -z $(git status --porcelain) ]]; then
-    echo "No uncommitted local changes. The working directory is clean."
-  else
-    git status
-  fi
-  echo '```'
-  echo ""
-  echo "---"
-} >> "$OUTPUT_FILE"
-
-if [ "$CURRENT_BRANCH" != "$MAIN_BRANCH" ]; then
-  MERGE_BASE=$(git merge-base $MAIN_BRANCH HEAD)
-  {
-    echo "## 2. New Work on This Branch (Compared to \`$MAIN_BRANCH\`)"
-    echo ""
-    if [ $(git rev-list --count $MERGE_BASE..HEAD) -eq 0 ]; then
-      echo "No new commits found on this branch compared to \`$MAIN_BRANCH\`."
-    else
-      echo "**Commit History:**"
-      echo '```'
-      git log --oneline $MERGE_BASE..HEAD
-      echo '```'
-      echo ""
-      echo "**Detailed file changes (diff):**"
-      echo '```diff'
-      git diff $MERGE_BASE..HEAD
-      echo '```'
-    fi
-    echo ""
-    echo "---"
-  } >> "$OUTPUT_FILE"
-fi
-
-# --- Section 2: Project Structure ---
-{
-  echo "## 3. Project Structure"
-  echo ""
-  echo '```'
-  tree -a -I '.git|.task|bin|node_modules|.venv|__pycache__|*.log|contextvibes_*.md'
-  echo '```'
-  echo ""
-  echo "---"
-} >> "$OUTPUT_FILE"
-
-# --- Section 3: Key Project Files ---
-echo "## 4. Key Project Files" >> "$OUTPUT_FILE"
-KEY_FILES=(
-  "README.md"
-  "Taskfile.yml"
-  ".idx/dev.nix"
-  ".idx/airules.md"
-  ".github/CONTRIBUTING.MD"
-  ".contextvibes.yaml"
-)
-
-for file in "${KEY_FILES[@]}"; do
-  if [ -f "$file" ]; then
-    {
-      echo ""
-      echo "======== FILE: ${file} ========"
-      echo '```'
-      cat "$file"
-      echo '```'
-      echo "======== END FILE: ${file} ========"
-    } >> "$OUTPUT_FILE"
-  fi
-done
-
-echo "✅ Comprehensive export complete. Report saved to '$OUTPUT_FILE'."
diff --git a/scripts/status.sh b/scripts/status.sh
deleted file mode 100755
index d652a90..0000000
--- a/scripts/status.sh
+++ /dev/null
@@ -1,76 +0,0 @@
-#!/bin/bash
-# scripts/status.sh
-#
-# WHY: Generates a focused report on "what is new" for the current workspace.
-# WHAT: It captures uncommitted local changes and, if on a feature branch,
-#       the new commits and file diffs compared to the 'main' branch.
-# HOW: Uses git commands to check status and diffs, then formats the
-#      output into a structured markdown file for LLM context.
-
-set -e
-
-OUTPUT_FILE="contextvibes_status.md"
-MAIN_BRANCH="main"
-CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
-
-echo "--> Generating status report for branch '$CURRENT_BRANCH'..."
-
-# Overwrite the file with the initial header
-{
-  echo "# Status Report: What's New?"
-  echo ""
-  echo "**Branch:** \`$CURRENT_BRANCH\`"
-  echo "**Generated:** $(date)"
-  echo ""
-  echo "---"
-} > "$OUTPUT_FILE"
-
-# --- Section 1: Uncommitted Local Changes ---
-{
-  echo "## 1. Uncommitted Local Changes"
-  echo ""
-  echo '```'
-  # If `git status --porcelain` has no output, the directory is clean.
-  if [[ -z $(git status --porcelain) ]]; then
-    echo "No uncommitted local changes. The working directory is clean."
-  else
-    git status
-  fi
-  echo '```'
-  echo ""
-  echo "---"
-} >> "$OUTPUT_FILE"
-
-# --- Section 2: New Commits and Diffs vs. Main Branch ---
-# This section only runs if we are NOT on the main branch.
-if [ "$CURRENT_BRANCH" != "$MAIN_BRANCH" ]; then
-  # Find the common ancestor commit to compare against
-  MERGE_BASE=$(git merge-base $MAIN_BRANCH HEAD)
-
-  {
-    echo "## 2. New Work on This Branch (Compared to \`$MAIN_BRANCH\`)"
-    echo ""
-    # Check if there are any new commits on this branch
-    if [ $(git rev-list --count $MERGE_BASE..HEAD) -eq 0 ]; then
-      echo "No new commits found on this branch compared to \`$MAIN_BRANCH\`."
-    else
-      echo "**Commit History since branching from \`$MAIN_BRANCH\`:**"
-      echo '```'
-      git log --oneline $MERGE_BASE..HEAD
-      echo '```'
-      echo ""
-      echo "**Detailed file changes (diff):**"
-      echo '```diff'
-      git diff $MERGE_BASE..HEAD
-      echo '```'
-    fi
-  } >> "$OUTPUT_FILE"
-fi
-
-echo "✅ Full status report saved to '$OUTPUT_FILE'."
-echo ""
-echo "---"
-echo "Status Summary for Terminal:"
-echo "---"
-# Display the short, concise summary to the terminal for the user.
-git status --short
diff --git a/tasks/_status.yml b/tasks/_status.yml
deleted file mode 100644
index 6f2e2e4..0000000
--- a/tasks/_status.yml
+++ /dev/null
@@ -1,8 +0,0 @@
-# tasks/_status.yml
-version: '3'
-tasks:
-  status:
-    desc: "(Action) Saves a 'what's new' report to a file and shows a summary."
-    silent: true
-    cmds:
-      - ./scripts/status.sh
diff --git a/tasks/_thea.yml b/tasks/_thea.yml
deleted file mode 100644
index b1151ee..0000000
--- a/tasks/_thea.yml
+++ /dev/null
@@ -1,22 +0,0 @@
-# tasks/_thea.yml
-# Implements the high-level AI Assistant commands.
-version: '3'
-
-tasks:
-  thea-export-codebase:
-    desc: "(AI) Exports a comprehensive project snapshot for AI analysis."
-    silent: true
-    cmds:
-      - ./scripts/export_codebase.sh {{.CLI_ARGS}}
-
-  thea-prompt-generate:
-    desc: "(AI) Generate a custom prompt template for a specific task."
-    silent: true
-    cmds:
-      - ./scripts/generate_prompt_menu.sh
-
-  thea-playbook-generate:
-    desc: "(AI) Generate a custom, reusable playbook for a complex workflow."
-    silent: true
-    cmds:
-      - ./scripts/generate_playbook_menu.sh
diff --git a/thea/README.md b/thea/README.md
index d74ec80..068667a 100644
--- a/thea/README.md
+++ b/thea/README.md
@@ -1,84 +1,74 @@
 ---
 id: "thea:README"
 fileExtension: "md"
-title: "THEA Core Framework Overview (Contents of thea/)"
-artifactVersion: "0.1.0"
+title: "THEA Product Framework Overview (thea/)"
+artifactVersion: "0.2.0"
 status: "Active"
-summary: "Provides an overview of the subdirectories and purpose of the core THEA framework assets located within the 'thea/' directory."
+summary: "Provides a comprehensive overview of the THEA Product Framework, detailing the structure and purpose of the core guidance assets located within the 'thea/' directory."
 usageGuidance:
   - "Use this document as the primary entry point to understand the structure and contents of the 'thea/' directory."
   - "Refer to this for high-level descriptions of prompts, schemas, playbooks, research, and other core THEA artifacts."
 owner: "Scribe, Canon"
-createdDate: "2025-06-09T15:00:00Z" # Updated to reflect approximate creation time
-lastModifiedDate: "2025-06-09T15:00:00Z" # Updated to reflect approximate creation time
+createdDate: "2025-06-09T15:00:00Z"
+lastModifiedDate: "2025-06-24T05:00:00Z"
 tags:
   - "readme"
   - "thea-core"
   - "navigation"
-  - "framework-overview"
+  - "product-framework"
   - "documentation"
 ---
-# THEA Core Framework (`thea/`)
-
-This directory contains the core intellectual property and distributable assets of the THEA (Tooling & Heuristics for Efficient AI-Development) guidance system. These artifacts are designed to be consumed by developers and AI assistants (like the THEA Collective and ContextVibes CLI) to enhance software development quality and efficiency.
-
-The contents of this directory are versioned and intended to be packageable for consumption by other projects, typically via the `contextvibes thea init` command. Further refactoring may consolidate additional THEA documentation and guides into this directory.
-
-## Key Subdirectories
-
-Below is an overview of the primary subdirectories currently within `thea/` and their purpose:
-
-### 1. `prompts/`
-   - **Purpose:** Contains standardized prompt templates for a variety of development tasks, languages, and AI models. These are designed to elicit high-quality responses from LLMs.
-   - **Key Artifacts:** Individual `.md` files representing specific prompt templates.
-   - **Consumption:** Used by AI assistants and developers to initiate AI-driven tasks.
-
-### 2. `schemas/`
-   - **Purpose:** Defines the structural contracts (in JSON Schema format) for THEA artifacts, including prompts, heuristics, and metadata (like the YAML front matter on THEA documents).
-   - **Key Artifacts:** `.json` schema files (e.g., `thea_artifact_metadata_schema.json`).
-   - **Consumption:** Used by `ContextVibes CLI` for validation, by `Logos` for maintaining structural integrity, and by developers contributing new artifacts.
-   - **Further Reading:** Refer to `../../docs/manuals/thea_metadata_authoring_guide.md` for details on artifact metadata (note: path relative to `thea/README.md`).
-
-### 3. `heuristics/`
-   - **Purpose:** Provides actionable heuristic rules and guidelines that can inform AI analysis, code generation, or developer best practices.
-   - **Key Artifacts:** `.md` files detailing specific heuristics, often with examples and rationale.
-   - **Consumption:** Consumed by AI assistants to apply specific best practices or analytical lenses.
-
-### 4. `playbooks/`
-   - **Purpose:** Contains structured, step-by-step guides and processes for utilizing THEA effectively, contributing to THEA, or performing common THEA-related development workflows.
-   - **Key Subdirectories:**
-     - `ai_guidance/`: Playbooks specifically for guiding AI behavior (e.g., core Go rules, Dataform formatting).
-     - `process_guidance/`: Playbooks for THEA's internal development processes and standards (e.g., managing diagrams, capturing lessons).
-     - `project_initiation/`: Playbooks related to starting projects with THEA principles.
-   - **Consumption:** Used by developers and the THEA team to ensure consistent application of processes.
-   - **Further Reading:** Key playbooks include:
-     - `[Playbook: Capturing Lessons Learned with AI Collaboration](playbooks/process_guidance/capturing_lessons_with_ai_via_documents.md)`
-     - `[Playbook: AI-Facilitated Strategic Project Kickoff](playbooks/project_initiation/master_strategic_kickoff_prompt.md)`
-
-### 5. `research/`
-   - **Purpose:** Houses foundational research, experimental findings, and comparative analyses that underpin THEA's design choices, prompts, and heuristics.
-   - **Key Subdirectories:**
-     - `go-best-practices/`
-     - `llm-prompting/`
-     - `prompts/` (research *about* prompts, distinct from `thea/prompts/` which *are* the prompts themselves)
-   - **Consumption:** Primarily for THEA contributors (`Athena`, `Logos`) to inform framework evolution, but summaries may be useful for users seeking deeper understanding. Note: Detailed archived research briefs are often found in `docs/research_findings/`.
-
-### 6. `firebase_studio_templates/`
-   - **Purpose:** Contains schemas, example templates, embedded `airules.md` templates, and playbooks specifically for guiding the creation and maintenance of THEA-aligned Firebase Studio project templates.
-   - **Key Subdirectories:**
-     - `EMBEDDED_AIRULES_TEMPLATES/`
-     - `EXAMPLES/`
-     - `PLAYBOOKS/` (e.g., `[Playbook: Designing THEA-Aligned Firebase Templates](firebase_studio_templates/PLAYBOOKS/designing_thea_aligned_firebase_templates.md)`)
-     - `SCHEMAS/`
-   - **Consumption:** Used by developers building new Firebase Studio project templates intended to work with THEA.
-
-### 7. `rulesets/`
-   - **Purpose:** Intended to hold collections or configurations of THEA artifacts (like prompts and heuristics) tailored for specific contexts, project types, or operational modes. (This area is subject to further definition and population).
-   - **Key Artifacts:** Likely to include `.json`, `.yaml`, or structured `.md` files defining these curated sets.
+# THEA Product Framework (`thea/`)
+
+Welcome to the `thea/` directory. This is the **Product** of the repository. It contains the core intellectual property and distributable assets of the THEA (Tooling & Heuristics for Efficient AI-Development) guidance system.
+
+These artifacts are designed to be consumed by developers and AI assistants (like the THEA Collective and ContextVibes CLI) to enhance software development quality and efficiency.
+
+## Directory Structure
+
+The framework is organized into four primary pillars:
+
+### 1. `foundations/`
+
+*   **Purpose:** Contains the "first principles" of the system. This includes core concepts, base schemas (`.json`), foundational research papers, and methodologies that underpin the entire THEA framework.
+*   **Key Artifacts:**
+    *   `base-schemas/`: Defines the structural contracts (in JSON Schema format) for all other THEA artifacts.
+    *   `research-papers/`: Houses foundational research and analyses that inform THEA's design choices.
+    *   `concepts/` & `methodologies/`: Explanations of the core ideas behind THEA.
+*   **Consumption:** Used by `ContextVibes CLI` for validation, by `Logos` for maintaining structural integrity, and by developers seeking to understand the "why" behind the guidance.
+
+### 2. `building-blocks/`
+
+*   **Purpose:** Contains atomic, reusable assets that are the building blocks for more complex guidance.
+*   **Key Artifacts:**
+    *   `prompts/`: Standardized prompt templates for a variety of development tasks.
+    *   `heuristics/`: Actionable heuristic rules and guidelines that can inform AI analysis or code generation.
+    *   `meta-prompts/`: Prompts designed to help users write better prompts.
+*   **Consumption:** Used by AI assistants and developers to initiate AI-driven tasks with consistent, high-quality inputs.
+
+### 3. `application-guides/`
+
+*   **Purpose:** Contains practical, user-facing documentation on how to apply THEA. This includes structured, step-by-step guides and processes for utilizing the framework effectively.
+*   **Key Artifacts:**
+    *   `playbooks/`: Detailed workflows for common development processes (e.g., project initiation, capturing lessons learned).
+    *   `guides/`: Specific instructions on topics like metadata authoring and style.
+    *   `rulesets/`: Curated collections of prompts and heuristics for specific contexts.
+*   **Consumption:** Used by developers and teams to ensure consistent application of THEA's processes and best practices.
+
+### 4. `integrations/`
+
+*   **Purpose:** Contains schemas, example templates, and playbooks specifically for guiding the creation and maintenance of THEA-aligned artifacts in other systems.
+*   **Key Artifacts:**
+    *   `firebase-studio/`: Resources for building high-quality Firebase Studio project templates that work with THEA.
+*   **Consumption:** Used by developers who are extending the THEA ecosystem into other tools and platforms.
 
 ## Artifact Manifest
 
-An automated index of artifacts within this `thea/` directory (and potentially other designated THEA content areas) is generated by the `ContextVibes CLI index` command and stored in `thea/thea-manifest.json`. This manifest is primarily for machine consumption (e.g., by the THEA Collective AI) to discover and understand available THEA resources based on their metadata.
+An automated index of artifacts within this `thea/` directory is generated by the `task factory:index` command and stored in `thea/thea-manifest.json`. This manifest is primarily for machine consumption (e.g., by the THEA Collective AI) to discover and understand available THEA resources based on their metadata.
 
----
-This `README.md` provides a human-friendly entry point to the core THEA framework assets consolidated within the `thea/` directory.
+## How to Contribute
+
+Contributions to THEA's guidance are highly encouraged. When adding or modifying content, please adhere to the following:
+1.  Place your content in the appropriate directory based on the structure above.
+2.  Ensure any new artifacts conform to the relevant JSON schemas defined in `foundations/base-schemas/`.
+3.  Follow the authoring rules defined in `application-guides/guides/markdown-authoring-rules.md`.
```
