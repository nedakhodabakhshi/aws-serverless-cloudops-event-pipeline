#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# CONFIG (edit if needed)
# -----------------------------
REGION="us-east-1"
STACK_NAME="serverless-cloudops-event-pipeline"
PROJECT_NAME="serverless-cloudops-event-pipeline"

# Must match scripts/package.sh
TEMPLATE_BUCKET="serverless-cloudops-event-pipeline-templates-126313"
TEMPLATE_PREFIX="serverless-cloudops-event-pipeline/templates"

# Optional: leave empty to auto-generate input bucket name
INPUT_BUCKET_NAME=""

# Failure simulation flags (true فقط برای تست)
FORCE_FAIL="false"
RANDOM_FAIL="false"

# -----------------------------
# Resolve project root (works in Git Bash)
# -----------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TEMPLATE_FILE="${PROJECT_ROOT}/cloudformation/main.yaml"

echo "==> Project root: ${PROJECT_ROOT}"
echo "==> Using template: ${TEMPLATE_FILE}"
echo "==> Deploying stack: ${STACK_NAME} (region: ${REGION})"

aws cloudformation deploy \
  --region "${REGION}" \
  --stack-name "${STACK_NAME}" \
  --template-file "${TEMPLATE_FILE}" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    ProjectName="${PROJECT_NAME}" \
    TemplateBucketName="${TEMPLATE_BUCKET}" \
    TemplatePrefix="${TEMPLATE_PREFIX}" \
    InputBucketName="${INPUT_BUCKET_NAME}" \
    ForceFail="${FORCE_FAIL}" \
    RandomFail="${RANDOM_FAIL}"

echo "==> Deploy complete."
echo "==> Stack outputs:"
aws cloudformation describe-stacks \
  --region "${REGION}" \
  --stack-name "${STACK_NAME}" \
  --query "Stacks[0].Outputs" \
  --output table
