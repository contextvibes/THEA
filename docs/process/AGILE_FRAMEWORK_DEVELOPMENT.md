# Agile Framework Development Process for THEA

Version: 0.2.0 (incorporates Lessons Learned process)

This document outlines the Scrum-based approach adopted for the iterative development and evolution of THEA (Tooling & Heuristics for Efficient AI-Development) and the broader `ai-assisted-dev-framework`.

## 1. Adoption of Scrum

To ensure adaptability, iterative progress, and continuous improvement, the development of this framework itself will follow the Scrum framework. Our core guiding principle of "Think Big, Start Small, Learn Fast" is enacted through this agile approach.

## 2. Core Roles

* **Product Owner (PO):** `Orion`
  * Responsible for maximizing the value of the framework.
  * Owns and manages the Product Backlog, including defining and prioritizing Product Backlog Items (PBIs).
* **Scrum Master (SM):** `Helms`
  * Responsible for ensuring the Scrum process is understood and enacted.
  * Facilitates Scrum events and helps remove impediments for the Development Team.
* **Development Team:** Coordinated by `Athena`
  * A cross-functional group of conceptual personas responsible for creating the framework assets (THEA artifacts, documentation, playbooks, etc.).
  * Key members include `Scribe` (documentation), `Canon` (standards), `Logos` (research & conceptual integrity), `Kernel` (tooling & ContextVibes liaison), `Sparky` (environment). Other personas contribute as needed for specific PBIs.
  * The Development Team is self-managing in how it performs the work selected from the Sprint Backlog.

## 3. Release Goal for Initial Foundation (v0.1.0 of THEA)

Our current overarching goal for the initial foundational release is:

> "Establish THEA (v0.1.0) with a clean repository structure, core schemas for guidance artifacts, foundational documentation (`README.MD`, `CONTRIBUTING.MD`, `GLOSSARY.MD`), defined processes (including this one), and placeholders for initial Go prompts & heuristics, making it a ready platform for building out THEA's AI guidance capabilities."

## 4. Product Backlog

The Product Backlog is the single source of truth for all work undertaken on the framework. It is a living document, managed in GitHub Issues, continuously refined and prioritized by the Product Owner (`Orion`).

Actionable insights and improvements identified through our "Lessons Learned & Knowledge Capture Process" (see Section 7) are converted into PBIs and added to this backlog.

## 5. Sprint Length

We will initially aim for **1-week Sprints** to maintain momentum, allow for rapid feedback, and iteratively build towards our release goals.

## 6. Definition of Done (DoD) for Framework Assets

1. **Clear Purpose:** The asset's purpose and intended audience are clearly stated or evident.
2. **Content Complete (Sprint Scope):** All planned work for the PBI is complete as per its acceptance criteria.
3. **Reviewed & Approved:**
    * Drafted/Implemented by primary author(s).
    * Reviewed by at least one other relevant core persona (or as defined by PBI).
    * Pull Request (if applicable) approved and merged.
    * Final acceptance by Product Owner (`Orion`) or delegated authority (`Athena`) for the PBI.
4. **Formatting & Standards:** Adheres to Markdown linting rules, consistent naming, project style guides (e.g., for schemas). No known broken links.
5. **Accessibility:** Stored in the correct repository location.
6. **Committed & Integrated:** Asset committed and merged to the `main` branch (or relevant integration branch).

## 7. Lessons Learned & Knowledge Capture within Scrum

Continuous improvement is vital. We integrate lessons learned directly into our Scrum process:

### 7.1. Identifying & Capturing Lessons

Lessons can be identified at any time, but formal opportunities include:

* **During Sprint Retrospectives:** (Facilitated by `Helms`) This is a **primary venue**. The team discusses what went well, what could be improved, and key takeaways (technical, process, tooling, AI collaboration).
* **Post-Incident Reviews:** After resolving significant issues or bugs in the framework itself or its development.
* **Tooling/Process Refinement Discussions:** When a team member identifies a better way to use a tool or a more efficient process.
* **AI Collaboration Insights (for THEA):** Specific learnings from developing or testing THEA's prompts and heuristics.

### 7.2. Processing Lessons Learned

* **Initial Discussion:** Lessons are briefly discussed with relevant team members or during the Sprint Retrospective.
* **PBI Creation for Actionable Insights:** If a lesson leads to an actionable improvement for THEA or the framework (e.g., new document, playbook update, schema change, tooling suggestion, process refinement):
  * A Product Backlog Item (PBI) is created in GitHub Issues by any team member, or by `Helms` following a retrospective.
  * The PBI must clearly state the lesson learned and the proposed action/improvement.
  * `Orion` (PO) will prioritize these PBIs in the Product Backlog.
  * Relevant conceptual personas will be involved in the PBI's refinement and execution.
* **Knowledge Dissemination:**
  * Documented learnings (new guides, playbook updates, tooling examples) are added to the appropriate locations (e.g., `docs/guides/`, `playbooks/tooling_examples/`).
  * `KNOWLEDGE_BASE_INDEX.MD` is updated by `Canon` or `Scribe` to index these new resources.
  * Significant new learning resources or process changes are communicated to the team by `Athena` or `Canon`.

## 8. Scrum Events

* **Sprint Planning:** To select PBIs for the upcoming Sprint and define a Sprint Goal.
* **Daily Scrum (Daily Check-ins):** `Helms` facilitates brief, regular check-ins (e.g., via team chat or short virtual stand-ups) with active PBI assignees to ensure alignment, track progress against the Sprint Goal, and identify impediments.
* **Sprint Review:** At the end of each Sprint, the Development Team presents the "Done" framework assets (increment) to `Orion` and other stakeholders for feedback.
* **Sprint Retrospective:** The team (`Orion`, `Helms`, `Athena`, core contributors for the Sprint) reflects on the Sprint process and identifies actionable improvements for future Sprints and for the framework itself (feeding into Section 7).

---
*(This document is part of THEA and the ai-assisted-dev-framework, and will evolve.)*
