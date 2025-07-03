# The Factory: Automation Framework

## 1. Purpose & Philosophy

Welcome to the `factory/` directory. This is the complete, self-contained automation framework for the THEA project.

Our project is organized using a **"Product, Library, Factory"** model. This directory represents **The Factory**—the machinery, processes, and environment used to build, test, and manage the project's "Product" (the `thea/` directory) and its "Library" (the `docs/` directory).

The primary goal of this structure is to create a clean separation of concerns, making the project easier to navigate and maintain.

## 2. The "Menu / Workflow / Action" Pattern

The automation within the factory is designed around a three-layer pattern to ensure logic is organized and easy to trace.

1.  **The Menu (Public API):**
    *   **Location:** `/Taskfile.yml` (in the project root).
    *   **Purpose:** Provides the clean, user-facing "public API" of commands. It is a simple proxy that delegates every command to the factory. This is the only file a typical user needs to be aware of.

2.  **The Workflow (The Control Panel):**
    *   **Location:** `factory/Taskfile.yml` and `factory/tasks/`.
    *   **Purpose:** This is the main entry point and control panel for the factory itself. The `Taskfile.yml` here defines the user-friendly help menu and includes all the individual task files from the `tasks/` subdirectory. The files in `tasks/` provide the wiring between a command and the script that implements it.

3.  **The Action (The Implementation):**
    *   **Location:** `factory/scripts/`.
    *   **Purpose:** This is where the real work happens. The shell scripts in this directory contain the core implementation logic for every command.

## 3. Directory Structure

*   ### `Taskfile.yml`
    *   The main entry point for the factory. It defines the default help menu and includes all task files from the `tasks/` directory.

*   ### `tasks/`
    *   Contains individual `.yml` files, each corresponding to a high-level command. These files bridge the gap between the command name and the script that executes the logic.

*   ### `scripts/`
    *   Contains all the shell scripts that perform the automation tasks.
    *   **`_automation_helpers.sh`**: This is the most important file in this directory. It is a centralized library of shared functions and variables. **All reusable logic MUST be placed here.**

*   ### `.idx/`
    *   Contains the Nix configuration (`dev.nix`) that defines the development environment. This ensures that every developer has the exact same set of tools (Go, ShellCheck, Gum, etc.) for a consistent and reproducible experience.

## 4. How to Add a New Command

To add a new command (e.g., `task new-command`) to the framework, follow these steps:

1.  **Implement the Action:** Create a new shell script in `factory/scripts/new_command.sh`. Place any reusable logic in `_automation_helpers.sh`.
2.  **Define the Workflow:** Create a new task file in `factory/tasks/_new_command.yml`. In this file, define a task that calls your new script.
3.  **Include the Workflow:** Open `factory/Taskfile.yml` and add `_new_command: ./tasks/_new_command.yml` to the `includes:` block.
4.  **Expose the API:** Open the root `/Taskfile.yml` and add a new proxy task for `new-command` that delegates to the factory.
5.  **Document the API:** Add the new command to the `default` task's help menu inside `factory/Taskfile.yml` so it is discoverable by users.
