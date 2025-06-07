# Playbook: Creating and Maintaining THEA Project Diagrams

**Version:** 0.1.0 (Initial Draft)
**Status:** Draft
**Conceptual Owners:** `Scribe`, `Canon`, `Logos`

## 1. Purpose

This playbook outlines the standard process for creating, storing, and maintaining visual diagrams used within THEA project documentation (e.g., in `README.MD` files, other `docs/`, or playbooks). Consistent diagram management ensures clarity, maintainability, and accessibility.

## 2. Preferred Tooling

*   **Primary Tool:** diagrams.net (formerly Draw.io) is the preferred tool for creating new diagrams due to its flexibility, export options (SVG, PNG), and ability to save source files in an XML format (`.drawio`).
*   **Alternative (for simple, text-based diagrams):** Mermaid.js can be used for diagrams embedded directly in Markdown, but for more complex or polished visuals, diagrams.net is recommended.

## 3. File Storage Conventions

*   **Exported Images (for embedding):**
    *   **Preferred Format:** SVG (`.svg`) for scalability and clarity. PNG (`.png`) is an acceptable alternative.
    *   **Location:** `docs/assets/images/`
    *   **Naming:** Use descriptive, lowercase, hyphenated names (e.g., `thea-continuous-improvement-cycle.svg`).
*   **Source Files (for editing):**
    *   **Format:** Native diagrams.net XML format (`.drawio`).
    *   **Location:** Store the `.drawio` source file in the *same directory* as its primary exported image, or in a clearly marked `source/` subdirectory within `docs/assets/images/` or `docs/assets/diagrams/`. For example:
        *   `docs/assets/images/thea-continuous-improvement-cycle.svg` (exported)
        *   `docs/assets/images/thea-continuous-improvement-cycle.drawio` (source)
    *   **Importance:** Always commit the `.drawio` source file to the repository. This allows others to easily edit and update the diagram later.

## 4. Process Example: THEA Continuous Improvement Cycle Diagram

This section documents the creation of the "THEA Continuous Improvement Cycle" diagram as an example.

### 4.1. Conceptualization
*   The need for a diagram illustrating the feedback loops between THEA, ContextVibes CLI, and Firebase Studio Templates was identified.
*   Core entities and flows were defined through collaborative discussion (User & THEA Collective AI).
    *   **Entities:** THEA Guidance System, Firebase Studio Templates, Developer Experience, Feedback & Improvement Ideas, ContextVibes CLI.
    *   **Key Flows:** (Summarize the main arrows and their meanings - *User: You might want to detail these based on our earlier discussion or the labels in your final diagram.*)
    *   The visual style was inspired by the clarity and professionalism of the "Projekt RaSTEM" diagram.

### 4.2. Creation Steps (using diagrams.net)
1.  A new diagram was created in diagrams.net.
2.  The 5 core entities were added as styled ellipses (colors, fonts, borders defined, text content for each).
3.  The ellipses were arranged visually to represent a cycle.
4.  Connecting arrows were drawn between the entities, with appropriate labels detailing the relationships/flows.
5.  The diagram was reviewed for clarity, accuracy, and visual appeal.
6.  The source file was saved as `docs/assets/images/thea-continuous-improvement-cycle.drawio` (adjust path if different).
7.  The diagram was exported as `docs/assets/images/thea-continuous-improvement-cycle.svg` (adjust path if different).

### 4.3. Embedding
*   The SVG was embedded into the main `README.MD` (Section 6) using the Markdown image syntax:
    `![THEA Continuous Improvement Cycle](docs/assets/images/thea-continuous-improvement-cycle.svg)` (adjust path if different)

## 5. Updating Diagrams
1.  Locate the `.drawio` source file in the repository.
2.  Open it with diagrams.net.
3.  Make necessary modifications.
4.  Save the `.drawio` source file.
5.  Re-export the diagram to its corresponding image format (SVG or PNG), overwriting the old version in `docs/assets/images/`.
6.  Commit both the updated `.drawio` source file and the re-exported image file.
7.  Ensure any documentation referencing the diagram is still accurate.

## 6. Requesting New Diagrams
*   Propose the need for a new diagram by creating a GitHub Issue, outlining its purpose and intended content. This will be reviewed by `Logos`, `Scribe`, and relevant stakeholders.

---
*This playbook helps maintain consistency and quality in THEA'\''s visual documentation.*
