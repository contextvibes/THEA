#!/bin/bash
# Orion's Start-of-Day CHECKLIST for AI-Assisted Dev Framework Oversight
# IMPORTANT: This script is a checklist. Run Git commands and checks manually.
# --- Helper Functions ---
print_header() { echo ""; echo "---------------------------------------------------------------------"; echo "## $1"; echo "---------------------------------------------------------------------"; } 
print_task_group() { echo ""; echo "  TASK GROUP: $1"; } 
print_action_item() { echo "    - ACTION: $1"; } 
print_review_item() { echo "    - REVIEW: $1"; } 
print_strategic_thought() { echo "    - STRATEGIC THOUGHT: $1"; } 
# --- Start of Day ---
clear
print_header "ORION'S START-OF-DAY CHECKLIST - ai-assisted-dev-framework"
echo "Good morning, Orion! Let's review priorities and status for the framework."
echo "Today's Date: $(date +'%Y-%m-%d %H:%M:%S')" 
echo "Framework Root Directory: $(pwd)" 
echo ""
# --- 1. Framework Repository Status ---
print_header "1. FRAMEWORK REPOSITORY STATUS (ai-assisted-dev-framework)"
print_action_item "Manually run 'git pull origin main' (or your default branch) to ensure your local is up-to-date."
print_action_item "Manually run 'git status' to review any uncommitted changes."
echo ""
# --- 2. Key Framework Documentation - Progress Review ---
print_header "2. KEY FRAMEWORK DOCUMENTATION - FOCUS ITEMS"
print_task_group "Core Template Population (Responsibility: Athena/Canon/Scribe)"
print_review_item "Verify 'playbooks/project_initiation/AI_PROJECT_BRIEF_TEMPLATE.MD' is populated."
print_review_item "Verify 'docs/research_findings/Logos_Versatile_Teams_AI_Personas_Framework_v1.md' contains full research report."
print_review_item "Verify 'playbooks/ai_guidance/go_core_airules.md' contains Core Go AI Rules."
echo ""
print_task_group "TEAM_HANDBOOK.MD Progress (Responsibility: Scribe, with team input)"
print_review_item "Content of TEAM_HANDBOOK.MD sections (Intro, Operating Phil, Roles, AI Integration)."
echo ""
print_task_group "Detailed Competency Profile Progress (Responsibility: Scribe, with persona leads)"
print_review_item "Profiles for ORION.MD, ATHENA.MD, LOGOS.MD, and other persona stubs."
echo ""
print_task_group "Framework Root Documents (Responsibility: Scribe/Canon, with Athena/Orion input)"
print_review_item "Content plan/draft for main README.MD and CONTRIBUTING.MD."
echo ""
# --- 3. ORION'S STRATEGIC FOCUS ---
print_header "3. ORION'S STRATEGIC FOCUS"
print_strategic_thought "Be available for strategic questions from Athena."
print_strategic_thought "Finalize 'Operating Philosophy' (core values) for TEAM_HANDBOOK.MD."
print_strategic_thought "Consider governance model for the framework."
echo ""
# --- 4. FRAMEWORK REPO DEV ENVIRONMENT & TOOLING ---
print_header "4. FRAMEWORK REPO DEV ENVIRONMENT & TOOLING"
print_review_item "Status of ContextVibes CLI in './bin/'."
print_action_item "If CLI not found/working, consult with Sparky."
echo ""
print_header "END OF START-OF-DAY CHECKLIST"
echo "Primary focus areas: Finalizing framework assets for v0.0.1."
echo ""
