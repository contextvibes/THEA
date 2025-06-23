#!/bin/bash
# scripts/verify.sh
# A robust script to verify that all required local files, GCP projects,
# resources, and IAM permissions are correctly configured.

# This script intentionally does NOT use 'set -e' because its purpose is
# to run a series of checks and report on all of them, not to fail on the
# first error.

# --- Verification Helper ---

# A robust helper to execute a command and print its status.
# Usage: _check "Description of the check" "command to run"
_check() {
    local description=$1
    local command_to_run=$2

    # Use 'eval' to correctly execute the command string, which may contain pipes.
    # Redirect stdout and stderr to /dev/null to suppress output.
    if eval "${command_to_run}" > /dev/null 2>&1; then
        echo -e "  [✅] ${description}"
    else
        echo -e "  [❌] ${description}"
    fi
}

# --- Main Execution Block ---

echo "--> Verifying all required infrastructure..."

# 1. Verify Projects
echo
echo "--> Checking for GCP Projects..."
_check "Assets Project:  ${ASSETS_PROJECT_ID}"  "gcloud projects describe '${ASSETS_PROJECT_ID}' --quiet"
_check "Storage Project: ${STORAGE_PROJECT_ID}" "gcloud projects describe '${STORAGE_PROJECT_ID}' --quiet"
_check "Compute Project: ${COMPUTE_PROJECT_ID}" "gcloud projects describe '${COMPUTE_PROJECT_ID}' --quiet"

# 2. Verify Resources
echo
echo "--> Checking for key resources..."
_check "Artifact Registry: ${ARTIFACT_REGISTRY_NAME}" "gcloud artifacts repositories describe '${ARTIFACT_REGISTRY_NAME}' --project='${ASSETS_PROJECT_ID}' --location='${ASSETS_GCP_REGION}' --quiet"
_check "GCS Bucket: gs://${GCS_BUCKET_NAME}"          "gcloud storage buckets describe 'gs://${GCS_BUCKET_NAME}' --project='${STORAGE_PROJECT_ID}' --quiet"

# Determine the effective service account to check for
project_number=$(gcloud projects describe "${COMPUTE_PROJECT_ID}" --format='value(projectNumber)' --quiet 2>/dev/null || echo "")
default_sa="${project_number}-compute@developer.gserviceaccount.com"
effective_sa=${TARGET_PRINCIPAL_SA:-$default_sa}
_check "Service Account: ${effective_sa}"             "gcloud iam service-accounts describe '${effective_sa}' --project='${COMPUTE_PROJECT_ID}' --quiet"

# 3. Verify Local Files
echo
echo "--> Checking for local files..."
_check "Local key file: ./sa-key.json" "test -f ./sa-key.json"

# 4. Verify IAM Permissions
echo
echo "--> Checking IAM Permissions..."
current_user=$(gcloud config get-value account --quiet)
run_service_agent="service-${project_number}@gcp-sa-run.iam.gserviceaccount.com"

_check "Permission: Developer can write to Artifact Registry" \
       "gcloud artifacts repositories get-iam-policy '${ARTIFACT_REGISTRY_NAME}' --project='${ASSETS_PROJECT_ID}' --location='${ASSETS_GCP_REGION}' --format=json | grep -q -E '\"user:${current_user}\".*\"roles/artifactregistry.writer\"'"

_check "Permission: Cloud Run can read from Artifact Registry" \
       "gcloud artifacts repositories get-iam-policy '${ARTIFACT_REGISTRY_NAME}' --project='${ASSETS_PROJECT_ID}' --location='${ASSETS_GCP_REGION}' --format=json | grep -q -E '\"serviceAccount:${run_service_agent}\".*\"roles/artifactregistry.reader\"'"

_check "Permission: Application SA can write to GCS Bucket" \
       "gcloud storage buckets get-iam-policy 'gs://${GCS_BUCKET_NAME}' --project='${STORAGE_PROJECT_ID}' --format=json | grep -q -E '\"serviceAccount:${effective_sa}\".*\"roles/storage.objectAdmin\"'"

echo -e "\n[ OK ] Verification checks complete."