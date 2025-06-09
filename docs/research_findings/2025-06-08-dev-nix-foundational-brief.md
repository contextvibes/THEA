---
id: "research:research_findings/2025-06-08-dev-nix-foundational-brief"
fileExtension: "md"
title: "Foundational Best Practices Brief: Universal dev.nix Management in Firebase Studio"
artifactVersion: "1.0.0"
status: "Archived"
summary: "The direct research output from a specialized LLM detailing the foundational best practices for managing .idx/dev.nix files in Firebase Studio."
usageGuidance:
  - "This document is the raw research output that informed the official 'Guide: Managing dev.nix in Firebase Studio'."
  - "Consult this for deeper context, citations, and trade-offs that were summarized in the final guide."
  - "Use as a reference when considering updates or changes to the core dev.nix standards."
owner: "Athena"
createdDate: "2025-06-08T14:40:00Z"
lastModifiedDate: "2025-06-08T14:40:00Z"
tags:
  - "research"
  - "nix"
  - "firebase-studio"
  - "dev-environment"
  - "best-practices"
  - "athena"
  - "research-finding"
---
# **Foundational Best Practices Brief: Universal dev.nix Management in Firebase Studio**

## **1\. Executive Summary**

This brief outlines foundational best practices for creating and managing .idx/dev.nix files within the Google Firebase Studio environment. The objective is to establish a universal standard applicable to all THEA projects, promoting consistency, reproducibility, and maintainability across diverse programming languages and frameworks.

Key findings and recommendations include:

* **Standardized Package Discovery:** Utilizing search.nixos.org as the primary source for Nix package discovery and understanding how to interpret attribute names, especially for versioned software.  
* **A Foundational dev.nix Template:** A minimal, well-commented base template is provided, establishing essential sections like channel, packages, env, and Firebase Studio-specific idx configurations. This template serves as a common starting point for all projects.  
* **Language Extension Patterns:** A clear pattern for extending the base template with language-specific tools and configurations is demonstrated using Go as a representative example. This includes managing language toolchains and related environment variables, emphasizing reliance on Nix's capabilities and modern language features like Go Modules.  
* **Environment Variable Management:** Clear syntax and examples for defining universal and project-specific environment variables within the env block, including referencing other Nix variables and home directory paths.  
* **Developer Workflow in Firebase Studio:** A defined end-to-end workflow for modifying dev.nix, triggering environment rebuilds, locating logs for troubleshooting, and verifying changes.  
* **Maintenance and Style:** Recommendations for commenting, code organization, package ordering, and the use of Nix formatting tools to ensure dev.nix files remain clean and maintainable.

Adherence to these best practices will significantly enhance developer experience, reduce environment-related inconsistencies, and streamline project onboarding within the Firebase Studio ecosystem at THEA.

## **2\. The Universal Workflow for Adding Packages**

A consistent and reliable method for discovering and adding Nix packages is fundamental to maintaining reproducible development environments. This section details the authoritative process for finding package attribute names and provides canonical examples.

### **2.1. Nix Package Discovery (Authoritative Process)**

The Nix ecosystem offers a vast collection of packages, primarily through its main repository, Nixpkgs. Identifying the correct "attribute name" for a package is crucial for its inclusion in a dev.nix file.

* Primary Official Website for Package Search:  
  The primary and official web interface for searching Nix packages is search.nixos.org.1 This website allows developers to search for packages across various Nixpkgs channels (e.g., stable, unstable) and even other public Nix flakes. While the nix search command-line tool also exists, search.nixos.org offers a more user-friendly interface and broader search capabilities.1  
* Interpreting Search Results and Finding Attribute Names:  
  When a developer searches for a package (e.g., "jq") on search.nixos.org, the results page will list matching packages. Each entry typically provides:  
  * **Name:** The common name of the software (e.g., "jq").  
  * **Version:** The version of the software in that package.  
  * **Attribute Name (Implicit or Explicit):** The crucial piece of information is the attribute name used in Nix expressions. On search.nixos.org, the most prominent name listed for the package is usually the attribute name itself. For instance, searching for "jq" clearly shows "jq" as the package.3 When adding this to dev.nix, it will be prefixed with pkgs., resulting in pkgs.jq.  
  * The "How to install" section on a package's detail page often provides direct examples, such as environment.systemPackages \= \[ pkgs.jq-lsp \]; for jq-lsp, clearly indicating pkgs.jq-lsp is the way to reference it.4  
* Handling Ambiguities (e.g., Versioned Packages):  
  Many packages, especially runtimes like NodeJS, have multiple versions available in Nixpkgs. search.nixos.org will list these, often with attribute names that include version numbers. For example, a search for "node" or "nodejs" will yield results like nodejs\_20, nodejs\_22, nodejs\_24, and potentially a generic nodejs which might point to a default or an older version.5  
  * To use a specific version, the developer must choose the attribute name that corresponds to that version (e.g., pkgs.nodejs\_22 for NodeJS version 22.x).  
  * The term "Nix package name" or "attribute name" refers to the key in the Nixpkgs attribute set (e.g., nodejs\_22), while the "package name" often refers to the software's name and version (e.g., "nodejs-22.14.0").7 It is important to use the Nix attribute name in dev.nix.  
  * For tools that are part of a larger ecosystem (e.g., NPM packages), they are often grouped under a specific attribute set, like pkgs.nodePackages. The search results will usually reflect this structure.

The ability to pinpoint the exact attribute name, including its version specificity, is vital. Using a generic name like pkgs.nodejs might lead to unexpected version changes when the underlying Nixpkgs channel updates its default. Therefore, for critical tools like language runtimes, selecting a version-specific attribute (e.g., pkgs.nodejs\_22) is generally recommended for greater stability and predictability in THEA projects.

### **2.2. Canonical Attribute Names for Common Tools (Examples)**

Based on the process described above, here are the canonical attribute names for the requested common tools:

* **A command-line JSON processor (jq):**  
  * Attribute Name: pkgs.jq  
  * Source: The search result for "jq" on search.nixos.org clearly identifies the primary package as jq.3  
* **A modern version of the NodeJS runtime:**  
  * Attribute Name Example: pkgs.nodejs\_22 (for NodeJS 22.x series)  
  * Source: Searches for "node" or "nodejs" on search.nixos.org list multiple versions like nodejs\_20, nodejs\_22, nodejs\_24.5 Firebase Studio documentation also exemplifies pkgs.nodejs\_20.8 Choosing a specific, recent, and stable version is key. For instance, if NodeJS 22 is the current Long-Term Support (LTS) or desired modern version, pkgs.nodejs\_22 would be appropriate.  
* **markdownlint-cli (the NodeJS-based Markdown linter):**  
  * Attribute Name: pkgs.nodePackages.markdownlint-cli  
  * Source: markdownlint-cli is an NPM package.9 Within Nixpkgs, such packages are typically available under the nodePackages attribute set. A search on search.nixos.org for "markdownlint-cli" confirms the attribute name as nodePackages.markdownlint-cli. Some Nixpkgs internal files might show aliases or different naming conventions 10, but pkgs.nodePackages.markdownlint-cli is the explicit and standard way to refer to it.

This systematic approach ensures that developers can confidently identify and specify the correct Nix packages, forming a reliable foundation for their development environments.

**Table: Nix Package Discovery Steps**

| Step | Action | Key Detail / Tool |
| :---- | :---- | :---- |
| 1 | **Visit the Official Search Portal** | Go to <https://search.nixos.org/packages.1> |
| 2 | **Enter Search Term** | Use the common name of the tool (e.g., "git", "python", "nodejs"). |
| 3 | **Analyze Results** | Look for the package that matches the desired tool and version. |
| 4 | **Identify Attribute Name** | The primary name listed is typically the attribute. Note versioned names (e.g., python311, nodejs\_22). For ecosystem packages, note the prefix (e.g., nodePackages.some-npm-tool). |
| 5 | **Verify (Optional)** | Click on the package name to see more details, including potential installation examples that show the pkgs.\<attributeName\> usage.4 |
| 6 | **Select Channel (If Necessary)** | search.nixos.org allows filtering by Nixpkgs channel (e.g., stable-23.11, unstable). Ensure the package exists in the channel used by your dev.nix file. |

## **3\. The THEA Foundational dev.nix Template**

A standardized, minimal, and well-structured dev.nix template is crucial for consistency across all THEA projects. This template serves as the common starting point, ensuring essential configurations are present and providing clear guidance for future language-specific or project-specific additions.

### **3.1. Essential Sections and Overall Structure**

The dev.nix file in Firebase Studio is a Nix expression that returns an attribute set. The structure is defined by Nix language conventions and specific attributes recognized by Firebase Studio.8

The essential, non-negotiable sections for a THEA foundational template are:

1. **Function Signature:** { pkgs, lib,... }:  
   * This defines the input parameters for the Nix expression. pkgs provides access to the Nixpkgs collection, lib offers utility functions from Nixpkgs, and ... allows for other parameters that might be passed by the calling environment (Firebase Studio in this case).  
2. **channel:**  
   * Example: channel \= "stable-24.05";  
   * Purpose: Specifies which Nixpkgs channel (a snapshot of the Nixpkgs repository) to use for sourcing packages. This is critical for reproducibility. Using a specific stable channel (e.g., "stable-23.11", "stable-24.05") is generally recommended over "unstable" for production-like stability, though "unstable" provides newer packages.8 THEA should decide on a preferred stable channel and update it periodically.  
3. **packages:**  
   * Example: packages \= \[ pkgs.git \];  
   * Purpose: A list of system-level packages to be installed and made available in the development environment's PATH. These are tools accessible from the terminal.8  
4. **env:**  
   * Example: env \= { MY\_VARIABLE \= "my\_value"; };  
   * Purpose: An attribute set defining environment variables that will be available system-wide within the workspace and in application previews.11  
5. **idx:**  
   * Purpose: This attribute set contains configurations specific to the Firebase Studio (formerly Project IDX) environment.8  
   * **idx.extensions**: A list of strings, where each string is the fully-qualified ID (e.g., "publisher.extension-id") of a VS Code extension from the OpenVSX registry to be automatically installed in the workspace.8  
   * **idx.previews**: A list defining configurations for running and previewing applications within Firebase Studio. Each preview configuration can specify commands, ports, and preview-specific environment variables.11  
   * **idx.workspace**: Contains lifecycle hooks:  
     * onCreate: A set of commands to run once when the workspace is first created.11  
     * onStart: A set of commands to run every time the workspace starts or restarts.11  
6. **(Optional but Recommended for Maintainability) imports:**  
   * Example: imports \= \[./my-custom-settings.nix \];  
   * Purpose: A list of paths to other .nix files. This allows the dev.nix configuration to be modularized, improving readability and organization for complex projects.12

### **3.2. File Structure and Commenting Guidelines**

To ensure clarity and maintainability, the dev.nix template should adhere to the following structuring and commenting guidelines:

* **Header Comment:** The file should begin with a comment explaining its purpose, its location (.idx/dev.nix), and links to relevant documentation (e.g., Firebase Studio dev.nix reference, Nixpkgs search).  
* **Sectioning with Comments:** Use prominent comments (e.g., \# \--- SECTION NAME \---) to delineate major configuration blocks like "NIXPKGS CHANNEL", "UNIVERSAL PACKAGES", "ENVIRONMENT VARIABLES (UNIVERSAL)", "FIREBASE STUDIO SPECIFIC CONFIGURATION", and "LANGUAGE/FRAMEWORK SPECIFIC CONFIGURATIONS".  
* **Purposeful Comments:** Each significant configuration or package should have a brief comment explaining its role or why it's included.  
* **Placeholders:** Include commented-out examples or explicit placeholder comments (e.g., \# Add other universal CLI tools here) to guide developers on where to add project-specific or language-specific settings.  
* **Grouping:** Related configurations should be grouped. For example, all universal tools should be listed together in the packages array before any language-specific additions.  
* **Consistency:** Follow consistent formatting for lists, attribute sets, and indentation, ideally enforced by a Nix formatting tool (see Section 7).

### **3.3. THEA Foundational dev.nix Base Template (Copy-Pasteable)**

The following is the recommended universal THEA foundational template for .idx/dev.nix files:

Nix

\#.idx/dev.nix  
\# This is the universal THEA foundational template for Firebase Studio projects.  
\# It defines the development environment using Nix.  
\# Documentation:  
\# \- Firebase Studio dev.nix reference: <https://firebase.google.com/docs/studio/devnix-reference>  
\# \- Nixpkgs search: <https://search.nixos.org/packages>

{ pkgs, lib,... }: {

  \# \--------------------------------------------------------------------------  
  \# NIXPKGS CHANNEL  
  \# \--------------------------------------------------------------------------  
  \# Specifies which Nixpkgs channel to use.  
  \# Options: "stable-YY.MM" (e.g., "stable-24.05") for stability,  
  \# or "unstable" for the latest packages (may have breaking changes).  
  \# THEA Recommendation: Start with a recent stable channel.  
  channel \= "stable-24.05"; \# Adjust as needed, current as of mid-2024 \[8, 11\]

  \# \--------------------------------------------------------------------------  
  \# UNIVERSAL PACKAGES  
  \# \--------------------------------------------------------------------------  
  \# System-level packages available in all THEA projects.  
  \# Add tools that are generally useful, regardless of language/framework.  
  \# Search for packages at <https://search.nixos.org/packages>  
  packages \=  
    \# Add other universal CLI tools here (e.g., curl, wget, common build tools if not language-specific)  
  \];

  \# \--------------------------------------------------------------------------  
  \# ENVIRONMENT VARIABLES (UNIVERSAL)  
  \# \--------------------------------------------------------------------------  
  \# Environment variables available system-wide in the workspace and preview.  
  \# These apply to all processes started within the Firebase Studio environment.  
  env \= {  
    \# EXAMPLE\_UNIVERSAL\_VAR \= "hello\_from\_thea\_universal\_env";  
    \# Example: PYTHONUNBUFFERED \= "1"; \# Useful for Python projects to ensure immediate output \[11\]  
    \# Add other universal environment variables here  
  };

  \# \--------------------------------------------------------------------------  
  \# FIREBASE STUDIO SPECIFIC CONFIGURATION (idx)  
  \# \--------------------------------------------------------------------------  
  \# This section configures Firebase Studio's behavior, including extensions,  
  \# application previews, and workspace lifecycle hooks.  
  idx \= {  
    \# VS Code extensions to install automatically from the OpenVSX registry.  
    \# Find extension IDs at <https://open-vsx.org/>  
    \# See Firebase documentation for details.\[8\]  
    extensions \=;

    \# Application preview configurations.  
    \# Defines how applications are run and what ports they use for previewing.  
    \# See Firebase documentation for schema.\[11, 12\]  
    previews \=; \# Example for a Node.js project  
      \#   \# command \= \["python", "-m", "http.server", "8080"\]; \# Simple Python server  
      \#  
      \#   \# Port your application listens on (integer)  
      \#   \# port \= 3000;  
      \#  
      \#   \# Environment variables specific to this preview instance  
      \#   \# env \= { BROWSER \= "none"; \# Prevents some tools from opening a browser  
      \#   \#         NODE\_ENV \= "development"; };  
      \#  
      \#   \# Whether to automatically open this preview when the workspace starts (boolean)  
      \#   \# open \= true;  
      \# }  
    \];

    \# Workspace lifecycle hooks.  
    \# These allow running custom shell commands at different stages of the workspace lifecycle.  
    \# See Firebase documentation for usage.\[11\]  
    workspace \= {  
      \# Runs ONCE when a workspace is first created from a template or Git repository.  
      \# Useful for one-time setup tasks like creating virtual environments,  
      \# installing initial dependencies not managed by Nix, or setting up databases.  
      onCreate \= {  
        \# example-one-time-setup \= ''  
        \#   echo "\>\>\> Workspace first-time setup initiated."  
        \#   \# Add one-time setup commands here.  
        \#   \# Example: Initializing a database schema if using a service like idx.services.postgres  
        \#   \# Example: Creating a Python virtual environment (if not managed differently)  
        \#   \#   python3 \-m venv.venv  
        \#   \#   source.venv/bin/activate  
        \#   \#   pip install \-r requirements.txt  
        \#   echo "\>\>\> Workspace first-time setup complete."  
        \# '';  
      };

      \# Runs EVERY time the workspace is (re)started.  
      \# Useful for tasks that need to happen on every start, like starting services,  
      \# checking for dependency updates, or setting dynamic configurations.  
      onStart \= {  
        \# example-every-start-tasks \= ''  
        \#   echo "\>\>\> Workspace starting or restarting."  
        \#   \# Add commands to run on every start here.  
        \#   \# Example: Ensure Python dependencies are installed/updated  
        \#   \#   if \[ \-f ".venv/bin/activate" \]; then  
        \#   \#     source.venv/bin/activate  
        \#   \#     pip install \-r requirements.txt  
        \#   \#   fi  
        \#   echo "\>\>\> Workspace start procedures complete."  
        \# '';  
      };  
    }; \# End of idx.workspace  
  }; \# End of idx

  \# \--------------------------------------------------------------------------  
  \# LANGUAGE/FRAMEWORK SPECIFIC CONFIGURATIONS  
  \# \--------------------------------------------------------------------------  
  \# This is a placeholder section.  
  \# Language-specific packages and environment variables should be added here,  
  \# typically by extending the 'packages' and 'env' attributes defined above.  
  \# See Section 4 of the "Foundational Best Practices Brief" for patterns.  
  \#  
  \# Example for adding Go (illustrative, actual implementation in Section 4):  
  \#  
  \# packages \= pkgs.lib.lists.concatLists  
  \# \];  
  \#  
  \# env \= lib.recursiveUpdate config.env { \# Or direct update if not using 'config'  
  \#   \# Go-specific environment variables (if any)  
  \#   \# Example: GOPATH \= "${config.projectRoot}/.go"; \# If needed and projectRoot is defined  
  \# };

  \# \--------------------------------------------------------------------------  
  \# MODULARITY (OPTIONAL BUT RECOMMENDED FOR COMPLEX PROJECTS)  
  \# \--------------------------------------------------------------------------  
  \# For larger configurations, you can split your dev.nix into multiple files  
  \# and import them here. This improves organization and maintainability.  
  \# Each imported file should also be a Nix expression returning an attribute set.  
  \# See Firebase documentation for details.\[12\]  
  \#  
  \# imports \= \[  
  \#   \# Example:./dev.local.nix \# For local, user-specific overrides (add to.gitignore)  
  \#   \# Example:./common-tools.nix  
  \#   \# Example:./frontend-config.nix  
  \#   \# Example:./backend-config.nix  
  \# \];

}

This template provides a robust and commented starting point. The use of a specific stable channel ensures that all developers on a project, and across different THEA projects starting from this template, will have a consistent base set of package versions, minimizing "works on my machine" issues. The idx block is pre-structured for Firebase Studio's specific features, guiding developers to configure extensions and previews correctly.

**Table: Key Sections of the Foundational dev.nix Template**

| Section | Purpose | Firebase Studio Specific? | Notes |
| :---- | :---- | :---- | :---- |
| channel | Defines the Nixpkgs package set version (e.g., "stable-24.05") for reproducibility. | No (Nix) / Yes (IDX context) | Crucial for consistent environments. 8 |
| packages | Lists system-level tools (e.g., pkgs.git, pkgs.jq) to be installed in the environment. | No (Nix) | These are available in the PATH. 8 |
| env | Sets environment variables (e.g., API\_KEY="secret") for the workspace and previews. | No (Nix) | For configuring application behavior. 11 |
| idx | Root attribute for Firebase Studio-specific configurations. | Yes | Contains settings for extensions, previews, lifecycle hooks. 8 |
| idx.extensions | Specifies VS Code extensions (e.g., "vscodevim.vim") to be automatically installed from OpenVSX. | Yes | Enhances IDE functionality. 8 |
| idx.previews | Defines how applications are run and previewed within Firebase Studio (command, port, etc.). | Yes | Enables integrated application testing. 11 |
| idx.workspace | Contains lifecycle hooks (onCreate, onStart) for running setup and startup shell commands. | Yes | Automates environment preparation. 11 |
| imports | (Optional) Allows splitting the configuration into multiple .nix files for better organization. | No (Nix) | Recommended for complex projects to improve maintainability. 12 |

## **4\. Pattern for Language-Specific Extensions (Using Go)**

Once the foundational dev.nix template is in place, projects will require extensions for specific programming languages and frameworks. This section demonstrates the pattern for such extensions using Go as a representative example. The principles outlined here can be adapted for other languages like Python, Node.js, Java, etc.

### **4.1. Adding Language-Specific Packages**

The primary step in setting up a language environment is adding the necessary compilers, interpreters, build tools, language servers, and debuggers to the packages list in dev.nix.

For a productive Go environment, the following core packages are recommended:

* **Go Compiler/Toolchain:** pkgs.go (which typically points to the latest stable Go version in the selected Nixpkgs channel) or a more specific version like pkgs.go\_1\_22 or pkgs.go\_1\_21 if a particular Go version is required for the project.13 Pinning to a specific minor version (e.g., pkgs.go\_1\_22) offers greater stability than relying on the generic pkgs.go.  
* **Go Language Server (gopls):** pkgs.gopls is the official language server for Go, providing features like autocompletion, definition jumping, and diagnostics in IDEs.14  
* **Go Debugger (delve):** pkgs.delve is a powerful debugger for Go applications.13 Note that in some Nix environments, delve might require specific hardening workarounds, though Firebase Studio's environment aims to simplify this.

Optionally, other useful Go tools can be included:

* pkgs.goimports or pkgs.gofumpt: For formatting Go code and managing imports. gofmt is part of pkgs.go.  
* pkgs.golangci-lint: A popular and fast Go linters aggregator.

Integration Method:  
These language-specific packages should be added to the packages list. If the foundational template defines universal packages, the Go packages can be appended. A common Nix pattern for combining lists is using the \++ operator or pkgs.lib.lists.concatLists.  
If extending a simple, single dev.nix file (as per the THEA Foundational Template):

Nix

\# In.idx/dev.nix  
{ pkgs, lib,... }: {  
  \#... (channel, universal packages, universal env, idx sections as defined before)

  \# Overwrite/extend the 'packages' attribute to include Go-specific tools  
  packages \= \[  
    \# Universal packages (copied from the universal section or inherited if using imports)  
    pkgs.git  
    pkgs.jq \# Example universal tool  
    \#... other universal tools  
  \] \++ \[  
    \# \--- Go Language Environment \---  
    pkgs.go\_1\_22         \# Go compiler and toolchain (specify desired version)  
    pkgs.gopls           \# Official Go language server  
    pkgs.delve           \# Go debugger  
    \# pkgs.golangci-lint \# Optional: Go linter aggregator  
    \# pkgs.goimports     \# Optional: Go formatter/imports tool  
  \];

  \#... (idx section, potentially language-specific env vars)  
}

If using a more modular approach with Nix Flakes or imports where config.packages might hold packages from an imported base configuration, the pattern would be:  
packages \= config.packages \++ \[ /\* Go packages \*/ \];  
However, for the Firebase Studio dev.nix, direct extension of the list is simpler and more common.

### **4.2. Documenting Language-Specific Sections**

Clear documentation within the dev.nix file is crucial when adding language-specific configurations.

* Use comments to clearly mark the beginning and end of the language-specific block (e.g., \# \--- Go Language Environment \---).  
* Add a brief comment next to each language-specific package explaining its purpose.

Example:

Nix

  \#...  
  packages \= \[  
    pkgs.git  
  \] \++;  
  \#...

### **4.3. Managing GOPATH and Other Language-Specific Environment Variables**

A common question for Go developers is the management of GOPATH.

* **Nix's Role and Go Modules:** Modern Go projects predominantly use Go Modules (go.mod and go.sum files) for dependency management. When using Go Modules, the Go toolchain automatically handles dependency fetching and building, typically within the project directory or a module cache. Nix ensures that the Go compiler (pkgs.go) and related tools (pkgs.gopls, etc.) are correctly installed and available in the PATH. For projects using Go Modules, **manually setting GOPATH for project dependencies is generally unnecessary and not recommended** within the Nix environment. The Nix environment itself provides the necessary isolation and tooling paths.  
* **When GOPATH Might Be Considered:**  
  * **Legacy Projects:** Projects that predate Go Modules and still rely on the traditional GOPATH workspace structure.  
  * **Global Tools Installation:** Some older Go tools might expect to be installed via go install into $GOPATH/bin. However, the preferred way to get tools in a Nix environment is via Nix packages.  
  * If a specific, unavoidable scenario requires GOPATH, it can be set in the env block of dev.nix:  
    Nix  
    env \= {  
      \#... other universal environment variables  
      \# GOPATH \= "$HOME/go"; \# Traditional GOPATH, if absolutely necessary  
      \# Or, for project-local vendoring if not using modules (less common now):  
      \# GOPATH \= "${config.projectRoot}/.go\_vendor"; \# Assuming projectRoot is available  
    };  
    The GitHub issue 24 discusses complex shellHook manipulations for GOPATH in nix-shell contexts, but this level of complexity should be avoided in the simpler Firebase Studio dev.nix env block to maintain clarity. The focus should be on leveraging Nix packages and Go Modules.  
* **General Principle for Other Languages (e.g., Python's PYTHONPATH):**  
  * Nix generally manages the paths for packages it installs, making them available to the language runtime.  
  * If a language requires specific path variables (like PYTHONPATH for Python to find project-local modules not installed as Nix packages), these can be set in the env block. Often, these paths would be relative to the project root.  
    Nix  
    env \= {  
      \# For a Python project with a 'src' directory containing modules:  
      \# PYTHONPATH \= "\\${config.projectRoot}/src:\\${env.PYTHONPATH}"; \# Prepend to existing PYTHONPATH  
    };  
    (Note: config.projectRoot is illustrative; the exact way to reference the project root might vary or require it to be explicitly set if needed by Nix at evaluation time).

The core principle is to let Nix manage tool paths and language runtimes as much as possible. Manual manipulation of path variables like GOPATH or PYTHONPATH should be reserved for specific, well-understood cases where the language's default behavior in a Nix environment, or its modern module system, is insufficient. This approach keeps dev.nix files cleaner and relies on Nix's strengths in providing reproducible environments. Firebase Studio's environment, being built by Nix, ensures that tools added via the packages list are typically correctly pathed and accessible. Community discussions and Nix configurations for Go often focus on providing the Go toolchain and related development tools, assuming Go Modules handle project dependencies.14 The NixOS Wiki page on Go also emphasizes buildGoModule for projects using Go Modules.13

**Table: Recommended Go Development Packages**

| Package Purpose | Nix Attribute Name(s) | Notes |
| :---- | :---- | :---- |
| Go Compiler & Toolchain | pkgs.go, pkgs.go\_1\_22, pkgs.go\_1\_21 (etc.) | Choose a specific version (e.g., pkgs.go\_1\_22) for maximum reproducibility and to match project requirements. 13 |
| Language Server | pkgs.gopls | Provides critical IDE features like code completion, navigation, and diagnostics for Go. 14 |
| Debugger | pkgs.delve | Essential for step-through debugging of Go applications. 13 |
| Formatter/Imports | pkgs.goimports, pkgs.gofumpt (or gofmt from pkgs.go) | For enforcing consistent code style and managing import statements. gofmt is included with pkgs.go. |
| Linter | pkgs.golangci-lint | A fast and comprehensive linter aggregator that runs multiple Go linters. |

## **5\. Managing Environment Variables (Universal)**

Environment variables are a fundamental way to configure applications and tools within a development environment. The .idx/dev.nix file provides an env block for defining these variables universally across the Firebase Studio workspace.

### **5.1. Syntax for Defining Environment Variables**

Environment variables are defined as key-value pairs within an attribute set assigned to the env key in your dev.nix file. The basic syntax is:

Nix

{ pkgs,... }: {  
  \#... other configurations...

  env \= {  
    VARIABLE\_NAME\_1 \= "value\_for\_variable\_1";  
    VARIABLE\_NAME\_2 \= "another\_value";  
    \# Add more variables here  
  };

  \#... idx configurations...  
}

This structure is standard in Nix expressions for defining sets of attributes. An example from a Firebase Studio community post shows env \= { PYTHONUNBUFFERED \= "1"; };.11 General NixOS documentation also illustrates setting environment variables in attribute sets, sometimes using rec for self-reference.16

### **5.2. Simple String Variables**

Most environment variables are simple strings. These are defined directly with their string values enclosed in double quotes:

Nix

env \= {  
  API\_ENDPOINT \= "<https://api.thea-project.example.com/v1>";  
  LOG\_LEVEL \= "debug";  
  FEATURE\_X\_ENABLED \= "true"; \# Booleans are typically represented as strings  
  DEFAULT\_REGION \= "us-central1";  
};

It's important to remember that all environment variable values are ultimately treated as strings by the operating system. Any type conversion (e.g., string to integer for a port number) must be handled by the application consuming the variable.

### **5.3. Referencing Other Nix Variables or Home Directory Paths**

The env block can also define variables whose values are derived from other parts of the Nix configuration or common system paths.

* Home Directory ($HOME):  
  To reference the user's home directory, the $HOME variable can be used within the string value. This relies on the shell, which ultimately uses these environment variables, to perform the expansion of $HOME.  
  Nix  
  env \= {  
    MY\_APP\_CONFIG\_DIR \= "$HOME/.config/my\_thea\_app";  
    LOCAL\_CACHE\_PATH \= "$HOME/.cache/thea\_project\_cache";  
  };

  This pattern is observed in NixOS configurations for setting XDG directories, for example, XDG\_CACHE\_HOME \= "$HOME/.cache";.16 While Nix itself evaluates the dev.nix file, the string values containing $HOME are passed as-is, and the expansion happens when a shell process is started within the environment.  
* Referencing Nix Packages (Store Paths):  
  It's often useful to set environment variables to the store path of a Nix package, for instance, to point to a specific JDK installation for JAVA\_HOME. Nix string interpolation ("${...}") is used for this:  
  Nix  
  env \= {  
    \# Example: Setting JAVA\_HOME to a specific JDK package installed by Nix  
    JAVA\_HOME \= "${pkgs.jdk17\_headless}"; \# pkgs.jdk17\_headless evaluates to /nix/store/...-jdk-17...

    \# Example: Pointing to a binary within a Nix package  
    MY\_CUSTOM\_TOOL\_PATH \= "${pkgs.my\_custom\_tool}/bin/custom-tool-binary";  
  };

  Here, pkgs.jdk17\_headless or pkgs.my\_custom\_tool are Nix attribute paths that resolve to the actual directory in the Nix store where the package is installed.  
* Referencing Other env Variables (within the same block using rec):  
  If an environment variable's value depends on another variable defined within the same env block, the rec keyword (for "recursive attribute set") can be used. This allows self-references within the attribute set.  
  Nix  
  env \= rec { \# Note the 'rec' keyword here  
    PROJECT\_BASE\_PATH \= "/srv/thea\_project";  
    LOG\_FILES\_DIR \= "${PROJECT\_BASE\_PATH}/logs";    \# References PROJECT\_BASE\_PATH  
    TEMP\_FILES\_DIR \= "${PROJECT\_BASE\_PATH}/tmp";   \# References PROJECT\_BASE\_PATH  
    DATABASE\_URL \= "sqlite://${PROJECT\_BASE\_PATH}/database/app.db";  
  };

  This pattern is a standard Nix language feature 16 and can be very useful for constructing complex configurations without repetition. While not always necessary for simpler dev.nix files, it's a powerful option.

Understanding these methods for defining environment variables allows for flexible and robust configuration of project environments within Firebase Studio, catering to both static values and dynamically derived paths.

**Table: Environment Variable Definition Patterns**

| Variable Type | Example Syntax in dev.nix | Notes |
| :---- | :---- | :---- |
| Simple String Value | MY\_SETTING \= "production\_value"; | Standard method for most configuration values. |
| Path Involving Home Directory | USER\_CONFIG\_PATH \= "$HOME/.myapp/config.yaml"; | $HOME is expanded by the shell when the environment is active. 16 |
| Path to a Nix-Managed Package | TOOL\_EXECUTABLE \= "${pkgs.mytool}/bin/mytool"; | ${pkgs.mytool} interpolates to the Nix store path of the mytool package. |
| Integer/Boolean (as String) | SERVER\_PORT \= "8080"; ENABLE\_METRICS \= "false"; | Environment variables are strings; application code handles conversion. |
| Referencing Another env Variable | env \= rec { BASE\_URL \= "/api"; FULL\_URL \= "<https://server.com${BASE\_URL}>"; }; | Requires rec on the env attribute set. Useful for constructing values from other variables within env. 16 |

## **6\. The Developer Workflow in Firebase Studio (Universal)**

A clear, predictable workflow is essential when developers modify the .idx/dev.nix file to customize their Firebase Studio environment. This section outlines the typical steps, from making changes to verifying their application.

### **6.1. Modifying dev.nix**

The process begins with the developer identifying a need to change the environment, such as adding a new tool, updating a package version, or setting an environment variable.

1. **Open .idx/dev.nix:** The developer navigates to the .idx directory in their project and opens the dev.nix file in the Firebase Studio editor.  
2. **Make Changes:** Modifications are made according to the Nix language syntax and the structures outlined in this brief (e.g., adding pkgs.newtool to the packages list or NEW\_VAR \= "value" to the env block).  
3. **Save File:** The developer saves the .idx/dev.nix file.

### **6.2. Triggering Environment Rebuild**

Firebase Studio is designed to react to changes in the .idx/dev.nix file to ensure the workspace environment reflects the specified configuration.

* **Automatic Detection and Prompt/Rebuild:** Upon saving the .idx/dev.nix file, Firebase Studio typically detects the change and will either automatically start rebuilding the environment or prompt the developer to do so.8 The Firebase documentation mentions "Apply new configuration" as a distinct step after editing dev.nix 17, implying an action is taken to make the changes live.  
* **Manual Trigger (Refresh):** If an automatic rebuild does not occur or if a developer wishes to force a re-evaluation of the environment (for instance, after changes to imported .nix files that Studio might not immediately detect, or changes to files like .idx/airules.md), a full refresh of the Firebase Studio browser page can often trigger a workspace rebuild.18

The environment rebuild process involves Nix evaluating the dev.nix file, fetching any new or changed packages, and constructing the new environment. This ensures that the workspace accurately reflects the declarative state defined in dev.nix.

### **6.3. Locating Logs for Failed Rebuilds**

If the environment rebuild fails (e.g., due to a syntax error in dev.nix, a non-existent package, or network issues fetching packages), Firebase Studio must provide access to diagnostic logs.

* The "Get Started" guide for Project IDX (now Firebase Studio) explicitly mentions "Debug environment build failures" as part of configuring the workspace.17 This confirms that mechanisms for diagnosing such failures are intended to be available.  
* **Expected Log Locations:** While specific UI details may vary and evolve, developers should look for:  
  * **Notifications:** Firebase Studio might display error notifications with summaries or links to detailed logs.  
  * **Output Panels/Tabs:** A dedicated "Output," "Problems," or "Terminal" panel within the IDE is a common place to display build logs, including Nix error messages. Look for channels specifically named "Nix," "Environment Build," or similar.  
  * **Workspace Initialization Logs:** Logs related to the overall workspace startup sequence might contain Nix build information.

These logs are critical for identifying issues such as typos in package names, incorrect Nix syntax, unresolved dependencies, or problems with the specified Nixpkgs channel.

### **6.4. Verifying Changes**

After a successful environment rebuild, developers must verify that their intended changes have taken effect. This is typically done using the integrated terminal in Firebase Studio.

* **Verifying Package Installation:**  
  * To check if a newly added package is installed and available in the PATH:  
    Bash  
    which \<tool\_name\>  
    For example, which jq should output a path similar to /nix/store/...-jq-.../bin/jq.  
  * To check the version of the installed tool:  
    Bash  
    \<tool\_name\> \--version  
    For example, jq \--version or node \--version.  
* **Verifying Environment Variables:**  
  * To check the value of a specific environment variable:  
    Bash  
    echo $MY\_VARIABLE\_NAME  
    For example, echo $API\_ENDPOINT.  
  * To list all environment variables and search for a specific one (useful if the exact name is uncertain or to see the broader context):  
    Bash  
    env | grep MY\_VARIABLE\_NAME  
    \# or  
    printenv | grep MY\_VARIABLE\_NAME

These verification steps provide confidence that the dev.nix modifications have been correctly applied and the development environment is configured as intended.

**Table/Checklist: Developer Workflow for .idx/dev.nix Modifications in Firebase Studio**

| Step | Action | Verification / Notes |
| :---- | :---- | :---- |
| 1 | **Plan Changes:** Identify the required packages, package versions, or environment variables. | Use search.nixos.org to find correct Nix package attribute names and available versions (Section 2). |
| 2 | **Edit .idx/dev.nix:** Open the file in Firebase Studio and make the necessary modifications. | Adhere to the THEA foundational template structure and commenting/style guidelines (Section 3, Section 7). |
| 3 | **Save .idx/dev.nix:** Save the changes in the editor. |  |
| 4 | **Trigger/Await Rebuild:** Observe for an automatic rebuild prompt or process initiated by Firebase Studio. If no automatic action, or to force it, refresh the workspace's browser page. | This action applies the new configuration to the environment.17 |
| 5 | **Monitor Rebuild Process:** Pay attention to notifications or output logs within Firebase Studio for the status of the environment build. |  |
| 6 | **Troubleshoot Failures (If Any):** If the rebuild fails, consult Firebase Studio's designated log/output areas for Nix error messages. | Examine logs for issues like "package not found," Nix syntax errors, or channel problems.17 |
| 7 | **Verify Package Changes:** Open a new terminal in Firebase Studio. Use which \<tool\_command\> and/or \<tool\_command\> \--version. | Confirms the package is installed, accessible in the PATH, and is the expected version. |
| 8 | **Verify Environment Variable Changes:** In the terminal, use echo $VARIABLE\_NAME or \`printenv \\ | grep VARIABLE\_NAME\`. |

## **7\. Maintenance and Style Guide (Universal)**

Maintaining clean, readable, and consistent .idx/dev.nix files is crucial for long-term project health, especially in a team environment. Adopting community-accepted best practices and leveraging available tooling can significantly aid in this effort.

### **7.1. Commenting and Code Organization**

Well-commented and organized Nix code is easier to understand, debug, and modify.

* **Commenting:**  
  * Use \# for single-line comments. Nix also supports multi-line comments /\*... \*/, but \# is more common for line-by-line explanations.  
  * **Header Comment:** Every dev.nix file should start with a header comment explaining its purpose, its location (.idx/dev.nix), and ideally, links to key documentation (e.g., the THEA best practices guide, Firebase Studio dev.nix reference, search.nixos.org).  
  * **Section Comments:** Use prominent comments to delineate logical sections within the file (e.g., NIXPKGS CHANNEL, UNIVERSAL PACKAGES, GO ENVIRONMENT, FIREBASE STUDIO CONFIGURATION). This improves scannability.  
  * **Explain Non-Obvious Choices:** Comment any packages, versions, or configurations that might not be immediately obvious to another developer (or to your future self). Explain *why* a particular choice was made.  
  * The principles from the nix.dev documentation style guide, such as aiming for clarity, brevity, and explaining code, are also applicable to writing good comments in .nix files.19  
* **Code Organization:**  
  * **Grouping:** Group related items together. For instance, list all universal development tools in one part of the packages array, followed by language-specific tools in another clearly marked section. Similarly, group related environment variables.  
  * **Structure:** Follow the essential structure outlined in Section 3 (function signature, channel, packages, env, idx).  
  * **Modularity with imports:** For complex projects, the dev.nix file can become very long. Nix allows configurations to be split into multiple .nix files using the imports attribute. For example:  
    Nix  
    imports \= \[  
     ./common-tools.nix  
     ./backend-services.nix  
     ./frontend-tooling.nix  
     ./dev.local.nix \# For user-specific overrides, often gitignored \[12\];  
    This practice significantly enhances maintainability by isolating concerns.12 Each imported file would itself be a Nix expression returning an attribute set whose attributes are merged into the main configuration.  
  * **Indentation and Spacing:** RFC 166 on Nix formatting suggests that indentation should reflect the expression structure, and that line breaks and empty lines should be used thoughtfully to group related code and improve readability.20 Consistent indentation (typically 2 spaces) is key.

### **7.2. Ordering of Packages**

While there isn't a strict, universally enforced standard for the order of packages within the packages list in Nixpkgs itself, adopting a consistent convention within THEA projects is beneficial for readability and maintainability.

* **Alphabetical Order:** Within logical groupings (e.g., universal tools, Go tools), ordering packages alphabetically makes it easier to locate a specific package and to see what's included at a glance.  
* **Logical Grouping First:** Prioritize grouping packages by their purpose (universal, language-specific, database tools, etc.) before applying alphabetical sorting within those groups.  
* **RFC 166 Focus:** The Nix formatting RFC 166 primarily addresses aspects like indentation, line breaks, spacing within lists and attribute sets, and overall structural consistency to ensure code is readable and diffs are clean, rather than mandating alphabetical ordering of list items.20  
* **THEA Recommendation:** It is recommended that THEA teams adopt a convention of **alphabetical ordering for packages within distinct logical sections** of the packages list.

### **7.3. Nix Formatting Tools**

Automated code formatters are invaluable for maintaining a consistent style across all .nix files and reducing cognitive load associated with varying styles. They also minimize stylistic changes in version control diffs.

* **RFC 166 \- Standard Nix Format:** This Request for Comments (RFC 166\) outlines a proposed standard for Nix code formatting. Its goals include producing code that is short, concise, readable, consistent, diffable, and stable.20 Key stylistic elements from RFC 166 include:  
  * Two spaces for each indentation level.  
  * Consistent handling of line breaks and empty lines to structure code.  
  * Rules for formatting attribute sets ({... }) and lists (\[... \]), such as having spaces on the inside of brackets/braces (e.g., \[ item1 item2 \] or { attr \= value; }).  
* **nixfmt:**  
  * nixfmt is recognized as the official formatter for the Nix language, developed with the intent to implement the style defined by RFC 166\.21  
  * It can be used to format files in place (e.g., nixfmt myproject.nix) or read from stdin and output to stdout.  
  * Integration with editors (Neovim, VS Code via extensions like vscode-nix-ide) and pre-commit hooks is possible.21  
* **alejandra:**  
  * alejandra is another popular and powerful Nix code formatter, known for its speed (written in Rust) and its "uncompromising" approach to defining a comprehensive style.22  
  * It also aims for high reliability and provides integrations with common code editors and pre-commit hooks.  
  * alejandra can be configured via an alejandra.toml file for some stylistic choices.22

The existence and active development of these formatters, underpinned by community efforts like RFC 166, demonstrate a strong desire for standardized Nix code presentation. Adopting one of these formatters within THEA and configuring it (if necessary) to align with team preferences (while staying close to RFC 166 principles) is highly recommended. This ensures that dev.nix files, regardless of who authors or modifies them, maintain a consistent and professional appearance.

**Table: dev.nix Maintenance and Style Best Practices**

| Practice Area | Recommendation | Tool/Reference |
| :---- | :---- | :---- |
| Commenting | Provide a file header, comment logical sections, and explain non-obvious choices or complex logic. | Principles from nix.dev Style Guide.19 |
| Indentation | Use 2 spaces per indentation level. Ensure indentation clearly reflects the Nix expression's structure. | RFC 166 20, nixfmt 21, alejandra.22 |
| Code Organization | Group related configurations (packages, env vars). Use imports for modularizing large or complex dev.nix files. | imports feature.12 |
| Package Ordering | Group packages logically (universal, language-specific), then alphabetize within those groups. | Team Convention (recommended). |
| Formatting Automation | Employ a standard Nix formatter (nixfmt or alejandra) integrated into the development workflow (e.g., pre-commit hooks, editor integration). | nixfmt 21, alejandra 22, RFC 166\.20 |
| Line Breaks & Spacing | Follow RFC 166 guidelines for consistent use of line breaks, empty lines, and spacing within lists and attribute sets. | RFC 166\.20 |
| Nixpkgs Channel | Pin to a specific stable channel (e.g., channel \= "stable-24.05";) in dev.nix for better long-term reproducibility and to avoid unexpected package updates. | Firebase Studio dev.nix examples.8 |
| Nix Language Version | While not explicitly set in dev.nix, be aware that Nix language features evolve. Write clear, standard Nix expressions. | Nix Manual. |

## **Conclusions and Recommendations**

The adoption of a standardized approach to .idx/dev.nix file management within Firebase Studio is paramount for enhancing developer productivity, ensuring environment reproducibility, and simplifying project maintenance across all THEA initiatives. The practices detailed in this brief provide a comprehensive foundation for achieving these goals.

**Key Conclusions:**

1. **Reproducibility through Nix:** The core strength of using Nix in Firebase Studio lies in its ability to create declarative, reproducible development environments. This significantly reduces "works on my machine" problems and streamlines onboarding.  
2. **Standardization is Key:** A universal foundational template, consistent package discovery methods, and defined workflows are essential for realizing the full benefits of Nix in a team setting.  
3. **Clarity and Maintainability:** Well-commented, organized, and automatically formatted .idx/dev.nix files are easier to understand, debug, and evolve over time.  
4. **Firebase Studio Integration:** Leveraging Firebase Studio-specific features within the idx block (extensions, previews, lifecycle hooks) alongside standard Nix configurations provides a powerful and tailored development experience.

**Recommendations for THEA:**

1. **Adopt the Foundational dev.nix Template:** Mandate the use of the provided "THEA Foundational dev.nix Template" (Section 3.3) as the starting point for all new projects in Firebase Studio.  
2. **Standardize Package Discovery:** Enforce the use of search.nixos.org for Nix package discovery and ensure developers understand how to identify correct attribute names, especially for versioned packages.  
3. **Implement Language Extension Patterns:** Utilize the demonstrated pattern for adding language-specific configurations (Section 4), adapting it for various languages used within THEA. Emphasize relying on Nix for toolchain management and modern language features (e.g., Go Modules) over manual path configurations like GOPATH where possible.  
4. **Enforce Workflow Adherence:** Train developers on the standard workflow for modifying dev.nix files, including rebuild triggers, log locations, and verification steps (Section 6).  
5. **Utilize Formatting Tools:** Integrate an automated Nix formatter (e.g., nixfmt or alejandra) into the development lifecycle, potentially via pre-commit hooks or editor configurations, to ensure consistent styling (Section 7).  
6. **Channel Pinning:** Consistently use specific stable Nixpkgs channels (e.g., channel \= "stable-24.05";) in the foundational template and update this channel deliberately and periodically across projects to balance stability with access to newer package versions.  
7. **Documentation and Training:** Make this "Foundational Best Practices Brief" readily accessible to all developers. Conduct brief training sessions to ensure understanding and adoption.  
8. **Periodic Review:** Establish a process to periodically review and update these best practices and the foundational template as the Nix ecosystem, Firebase Studio, and THEA's needs evolve.

By implementing these recommendations, THEA can create a more robust, efficient, and consistent development environment standard within Firebase Studio, ultimately benefiting all projects and development teams.

#### **Works cited**

1. Search for Nix packages \- Zero to Nix, accessed on June 9, 2025, [https://zero-to-nix.com/start/nix-search/](https://zero-to-nix.com/start/nix-search/)  
2. Best way to search packages to include in configuration.nix? : r/NixOS \- Reddit, accessed on June 9, 2025, [https://www.reddit.com/r/NixOS/comments/1kooh74/best\_way\_to\_search\_packages\_to\_include\_in/](https://www.reddit.com/r/NixOS/comments/1kooh74/best_way_to_search_packages_to_include_in/)  
3. Packages \- jq \- NixOS Search, accessed on June 9, 2025, [https://search.nixos.org/packages?query=jq](https://search.nixos.org/packages?query=jq)  
4. Packages \- jq-lsp \- NixOS Search, accessed on June 9, 2025, [https://search.nixos.org/packages?channel=unstable\&show=jq-lsp\&query=jq-lsp](https://search.nixos.org/packages?channel=unstable&show=jq-lsp&query=jq-lsp)  
5. Packages \- node \- NixOS Search, accessed on June 9, 2025, [https://search.nixos.org/packages?query=node](https://search.nixos.org/packages?query=node)  
6. Packages \- nodejs \- NixOS Search, accessed on June 9, 2025, [https://search.nixos.org/packages?channel=unstable\&size=50\&sort=relevance\&type=packages\&query=nodejs\_](https://search.nixos.org/packages?channel=unstable&size=50&sort=relevance&type=packages&query=nodejs_)  
7. How to Search For Apps and Tools within Nix Packages | Lambda-Blob, accessed on June 9, 2025, [https://lambdablob.com/posts/nix-search-for-apps-in-packages/](https://lambdablob.com/posts/nix-search-for-apps-in-packages/)  
8. Customize your Firebase Studio workspace \- Google, accessed on June 9, 2025, [https://firebase.google.com/docs/studio/customize-workspace](https://firebase.google.com/docs/studio/customize-workspace)  
9. markdownlint-cli \- NPM, accessed on June 9, 2025, [https://www.npmjs.com/package/markdownlint-cli](https://www.npmjs.com/package/markdownlint-cli)  
10. pkgs/development/node-packages/main-programs.nix ... \- GitLab, accessed on June 9, 2025, [https://gitlab.ri.se/lars.rasmusson/nixpkgs/-/blob/bb3879e8774124e43ee8d52ea67d06a03071fa6a/pkgs/development/node-packages/main-programs.nix](https://gitlab.ri.se/lars.rasmusson/nixpkgs/-/blob/bb3879e8774124e43ee8d52ea67d06a03071fa6a/pkgs/development/node-packages/main-programs.nix)  
11. Working FastHTML (a new Python Web Framework) dev.nix \- Project ..., accessed on June 9, 2025, [https://community.idx.dev/t/working-fasthtml-a-new-python-web-framework-dev-nix/9967](https://community.idx.dev/t/working-fasthtml-a-new-python-web-framework-dev-nix/9967)  
12. dev.nix Reference | Firebase Studio \- Google, accessed on June 9, 2025, [https://firebase.google.com/docs/studio/devnix-reference](https://firebase.google.com/docs/studio/devnix-reference)  
13. Go \- NixOS Wiki, accessed on June 9, 2025, [https://nixos.wiki/wiki/Go](https://nixos.wiki/wiki/Go)  
14. devenv/src/modules/languages/go.nix at main \- GitHub, accessed on June 9, 2025, [https://github.com/cachix/devenv/blob/main/src/modules/languages/go.nix](https://github.com/cachix/devenv/blob/main/src/modules/languages/go.nix)  
15. Anyone using Nix with Go? : r/golang \- Reddit, accessed on June 9, 2025, [https://www.reddit.com/r/golang/comments/1bqldoo/anyone\_using\_nix\_with\_go/](https://www.reddit.com/r/golang/comments/1bqldoo/anyone_using_nix_with_go/)  
16. Environment variables \- NixOS Wiki, accessed on June 9, 2025, [https://nixos.wiki/wiki/Environment\_variables](https://nixos.wiki/wiki/Environment_variables)  
17. Get started with Project IDX \- Google for Developers, accessed on June 9, 2025, [https://developers.google.com/idx/guides/get-started](https://developers.google.com/idx/guides/get-started)  
18. Configure Gemini in Firebase within workspaces \- Google, accessed on June 9, 2025, [https://firebase.google.com/docs/studio/set-up-gemini](https://firebase.google.com/docs/studio/set-up-gemini)  
19. Style guide — nix.dev documentation, accessed on June 9, 2025, [https://nix.dev/contributing/documentation/style-guide.html](https://nix.dev/contributing/documentation/style-guide.html)  
20. rfcs/rfcs/0166-nix-formatting.md at master · NixOS/rfcs \- GitHub, accessed on June 9, 2025, [https://github.com/NixOS/rfcs/blob/master/rfcs/0166-nix-formatting.md](https://github.com/NixOS/rfcs/blob/master/rfcs/0166-nix-formatting.md)  
21. NixOS/nixfmt: The official (but not yet stable) formatter for Nix code \- GitHub, accessed on June 9, 2025, [https://github.com/NixOS/nixfmt](https://github.com/NixOS/nixfmt)  
22. kamadorueda/alejandra: The Uncompromising Nix Code Formatter \- GitHub, accessed on June 9, 2025, [https://github.com/kamadorueda/alejandra](https://github.com/kamadorueda/alejandra)  
23. README.md \- kamadorueda/alejandra \- GitHub, accessed on June 9, 2025, [https://github.com/kamadorueda/alejandra/blob/main/README.md](https://github.com/kamadorueda/alejandra/blob/main/README.md)  
24. Developing golang in nix. Advise needed · Issue \#13670 · NixOS/nixpkgs \- GitHub, accessed on June 9, 2025, [https://github.com/NixOS/nixpkgs/issues/13670](https://github.com/NixOS/nixpkgs/issues/13670)
