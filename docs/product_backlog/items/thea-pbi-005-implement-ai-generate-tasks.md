---
title: "PBI: Implement AI Assistant 'generate' Commands"
date: 2025-06-23T09:00:00Z
lastmod: 2025-06-23T09:00:00Z
draft: false
type: "pbi"
description: "This PBI covers implementing the info-only placeholder tasks `thea-prompt-generate` and `thea-playbook-generate` with real functionality."
tags: ["taskfile", "ai-assistant", "generator", "feature"]
params:
  pbi_id: "THEA-PBI-005"
  status: "Proposed"
  priority: "Medium"
  personas_involved:
    - name: Athena
      role: Lead
    - name: Metis
      role: Consultant
---
## 1. PBI Goal & Justification
**Goal:** Implement the `thea-prompt-generate` and `thea-playbook-generate` tasks to provide real value.
**Justification:** These commands are currently info-only placeholders. Implementing them will complete the AI Assistant feature set, allowing users to quickly scaffold new THEA artifacts.

## 2. Acceptance Criteria
- **AC1:** `task thea-prompt-generate` runs an interactive script that asks the user for a prompt name and creates a new prompt file from a template.
- **AC2:** `task thea-playbook-generate` runs an interactive script that asks the user for a playbook name and creates a new playbook file from a template.
