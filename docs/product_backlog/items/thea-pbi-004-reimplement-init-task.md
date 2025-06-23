---
title: "PBI: Re-implement Robust `init` Task"
date: 2025-06-23T09:00:00Z
lastmod: 2025-06-23T09:00:00Z
draft: false
type: "pbi"
description: "This PBI covers the work to restore the original, robust functionality of the `init` task, which validates the `.env` file."
tags: ["taskfile", "init", "validation", "maintenance"]
params:
  pbi_id: "THEA-PBI-004"
  status: "Proposed"
  priority: "High"
  personas_involved:
    - name: Kernel
      role: Lead
    - name: Sparky
      role: Consultant
---
## 1. PBI Goal & Justification
**Goal:** Restore the critical safety-check functionality of the `init` task.
**Justification:** Several tasks (like `deploy`, `run`) depend on a correctly configured `.env` file. The original `init` task checked for the file's existence and validated that placeholder values were replaced. This was lost during refactoring and must be restored to prevent runtime errors.

## 2. Acceptance Criteria
- **AC1:** The `tasks/_init.yml` file is updated with logic that calls a new `scripts/init.sh`.
- **AC2:** The `init.sh` script checks if `.env` exists. If not, it copies it from `.env.example` and exits with a message.
- **AC3:** The `init.sh` script checks if `.env` contains any "your-" placeholder values. If so, it fails with an error message.
- **AC4:** Tasks that depend on environment variables (e.g., `deploy`, `verify`) have `deps: [init]` restored in the main `Taskfile.yml`.
