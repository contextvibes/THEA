# Contributing to THEA (Tooling & Heuristics for Efficient AI-Development)

Thank you for your interest in contributing to THEA! This framework is designed to be an evolving toolkit, and your insights are invaluable. As THEA itself is developed using agile principles, contributions will typically be integrated via our Product Backlog and Sprint process.

## 1. How THEA is Developed

We use a Scrum-based approach to manage the development and iteration of THEA. Please refer to `docs/process/AGILE_FRAMEWORK_DEVELOPMENT.MD` for details on:
*   Our development roles (Product Owner: `Orion`, Scrum Master: `Helms`, Development Team coordinated by `Athena`).
*   Our Product Backlog and how items are prioritized.
*   Our Sprint process and Definition of Done.

## 2. Types of Contributions & Lessons Learned

We welcome various types of contributions, including direct improvements to THEA's artifacts and the valuable **lessons learned** from using the framework and related tools. Your insights help us grow! Consider contributing:

*   **Improvements to Existing THEA Artifacts:**
    *   Suggesting clarifications, additions, or corrections to existing prompts, heuristics, schemas (`thea/`).
    *   Enhancements to core documentation like `README.md`, `TEAM_HANDBOOK.MD`, persona profiles, or user guides (`docs/`).
*   **New THEA Artifacts:**
    *   Proposing new prompt templates or heuristic rules for different languages, tools, or specific AI models.
    *   Suggesting new schemas or rule sets.
*   **Technical Learnings & Best Practices:**
    *   Documenting effective use of specific language features (e.g., Go concurrency patterns) that could inform THEA's guidance.
    *   Sharing performance optimization techniques or debugging strategies relevant to AI-assisted development.
*   **Tooling Insights & Feedback:**
    *   Sharing effective configurations for IDEs, linters, or other dev tools relevant to THEA contributors (e.g., for `.idx/dev.nix`).
    *   Documenting useful scripts or automation snippets (to be added to `playbooks/tooling_examples/` or `scripts/`).
    *   Providing feedback for core tools like `ContextVibes CLI` (to be channeled through `Nexus`).
*   **Process Improvements:**
    *   Suggesting refinements to our Scrum process for THEA development.
    *   Proposing better ways to manage documentation or review THEA artifacts.
*   **AI Collaboration Best Practices:**
    *   Sharing effective prompting strategies for specific tasks when working with THEA/ContextVibes.
    *   Documenting how to structure information for optimal AI understanding (e.g., improvements to `AI_PROJECT_BRIEF_TEMPLATE.MD`).
    *   Reporting limitations or biases observed in AI assistance and how to mitigate them.
*   **Documentation Enhancements:**
    *   Identifying gaps in existing THEA documentation.
    *   Proposing new templates, guides, or playbook entries.
*   **Bug Reports or Issues with THEA:** Identifying errors, inconsistencies, or areas where THEA's guidance is unclear or could be improved.

## 3. How to Propose a Contribution or Share a Lesson Learned

1.  **Initial Discussion (Recommended):** For significant new features, THEA artifacts, or structural changes, it's best to first discuss your idea with:
    *   `Athena` (THEA Development Coordinator / AI Strategy Lead)
    *   `Orion` (Product Owner for THEA)
    This helps align the proposal with THEA's strategic direction and current priorities.
2.  **Create a GitHub Issue:** For all proposals, bug reports, or documented lessons learned that require action, please create an Issue in this repository's issue tracker. This is the primary way to get your contribution into the backlog.
    *   Clearly describe the suggestion, the problem it solves, or the lesson learned.
    *   If it's a lesson learned leading to a framework improvement, state the lesson and the proposed action/artifact.
    *   Use appropriate labels if you're familiar with them.
3.  **Prepare a Draft (If Applicable):**
    *   For documentation changes, you can prepare a draft or specific suggestions.
    *   For new THEA artifacts (prompts, heuristics), a clear outline or a prototype adhering to existing schemas (see `thea/schemas/`) is highly beneficial.
    *   For "Lessons Learned" that result in new documents (e.g., a new tooling example in `playbooks/tooling_examples/`), draft that document. **If you are collaborating with the THEA Collective AI to draft such documents, please refer to the '[Playbook: Capturing Lessons Learned with AI Collaboration (User-Mediated Document Flow)](../playbooks/process_guidance/capturing_lessons_with_ai_via_documents.md)' for the recommended workflow.**
4.  **Integration into the Product Backlog:**
    *   `Orion`, as Product Owner, will review new issues with `Athena`.
    *   Accepted proposals will be formulated as Product Backlog Items (PBIs) and prioritized.
    *   The THEA Development Team (coordinated by `Athena`) will then pick up the PBI in a future Sprint. You may be asked to collaborate on its implementation.

## 4. Contribution Guidelines

*   **Clarity and Conciseness:** Ensure your contributions are clear, concise, and easy to understand.
*   **Adhere to Schemas:** When contributing new THEA artifacts (prompts, heuristics), ensure they follow the defined schemas in `thea/schemas/`.
*   **Markdown Formatting:** For documentation, please adhere to our Markdown standards (see `.markdownlint.jsonc`).
*   **Respect Existing Structure:** When modifying existing documents, try to maintain the established structure and tone unless the change explicitly aims to improve them.
*   **Focus on Reusability:** Aim for contributions that are broadly applicable.
*   **"Think Big, Start Small, Learn Fast":** We encourage innovative ideas, but proposals should ideally allow for iterative implementation and learning.
*   **"Be Kind":** All interactions and contributions should align with our core operating principle of kindness and respectful collaboration.

## 5. Getting Help

If you have questions about contributing or THEA itself, please reach out to:
*   `Athena`: For general THEA strategy, content, and AI integration aspects.
*   `Helms`: For questions about our Scrum process.
*   `Canon`: For documentation standards and structure.
*   `Kernel`: For technical aspects related to ContextVibes interaction or THEA artifact tooling.

We appreciate your help in making THEA a valuable resource for everyone!

---
*(This `CONTRIBUTING.MD` is managed by @Scribe and @Canon, with strategic guidance from @Orion and @Athena.)*