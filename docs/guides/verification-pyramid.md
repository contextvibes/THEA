# Guide: The Verification Pyramid

## 1. Purpose

This document provides the definitive, step-by-step sequence for verifying the
quality and correctness of contributions to the THEA framework. It follows the
principles of the "Testing Pyramid," starting with fast, automated local checks
and progressing to collaborative human review. Following this sequence is the
standard process for ensuring a change is ready to be merged.

## 2. The Verification Pyramid: A Step-by-Step Guide

This sequence is designed to provide the fastest possible feedback by catching
errors at the earliest and cheapest stage.

### Level 1: Static Analysis (The Foundation)

- **What:** Automated checks that analyze files for style and formatting without
  understanding their content.
- **Why:** This is the fastest way to ensure all contributions are stylistically
  consistent and adhere to project standards.
- **Commands (from project root):**

  ```bash
  # Check for formatting issues with Prettier
  npx prettier --check .

  # Check for linting issues in Markdown
  npx markdownlint-cli2 "**/*.md"
  ```

### Level 2: Content & Logic Review (The Middle)

- **What:** A self-review of the changes to ensure they are logical, correct,
  and meet the goals of the task.
- **Why:** This is where the contributor verifies the actual substance of their
  work. Does this new playbook make sense? Does this schema change solve the
  problem? This step catches logical flaws before they get to a reviewer.
- **Process:** Reread your changes. Test the instructions in your new guide.
  Think like someone who has never seen this before.

### Level 3: Collaborative Review (The Peak)

- **What:** The final, human-centric test. This is the Pull Request (PR) review
  process where another team member reviews the changes.
- **Why:** This is the ultimate verification. It proves that the changes are not
  only technically correct but also clear, well-documented, and strategically
  aligned with the project's goals.
- **Process:** Open a Pull Request and request a review from the appropriate
  Persona/Owner as defined in `docs/index.md`.
