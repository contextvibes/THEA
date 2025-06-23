---
title: "PBI: Re-implement Dynamic Taskfile Variables"
date: 2025-06-23T09:00:00Z
lastmod: 2025-06-23T09:00:00Z
draft: false
type: "pbi"
description: "This PBI covers the work to safely re-introduce dynamic variables like CURRENT_USER into the Taskfile system."
tags: ["taskfile", "variables", "refactor", "maintenance"]
params:
  pbi_id: "THEA-PBI-006"
  status: "Proposed"
  priority: "Medium"
  personas_involved:
    - name: Sparky
      role: Lead
---
## 1. PBI Goal & Justification
**Goal:** Safely restore the dynamic variables (`CURRENT_USER`, `ARTIFACT_REGISTRY_REPO`) that were removed from the main `Taskfile.yml` to fix a parsing error.
**Justification:** These variables are needed for tasks like `run` to display contextual information. The previous implementation caused parsing errors in some environments. A more robust solution is needed, likely by defining the variables only within the specific task files that require them, rather than globally.

## 2. Acceptance Criteria
- **AC1:** A robust method for defining dynamic variables is implemented.
- **AC2:** The `run` task (once implemented) can correctly display the `CURRENT_USER` in its menu without causing a global parsing error.
