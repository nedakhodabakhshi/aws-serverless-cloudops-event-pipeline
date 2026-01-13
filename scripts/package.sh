#!/usr/bin/env bash
set -euo pipefail

REGION="us-east-1"

# Must match deploy.sh
TEMPLATE_BUCKET="serverless-cloudops-event-pipeline-templates-126313"
TEMPLATE_PREFIX="serverless-cloudops-event-pipeline/templates"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TEMPLATES_DIR="${PROJECT_ROOT}/cloudformation"

echo "==> Using region: ${REGION}"
echo "==> Template bucket: ${TEMPLATE_BUCKET}"
echo "==> Template prefix: ${TEMPLATE_PREFIX}"
echo "==> Templates dir: ${TEMPLATES_DIR}"

if [ ! -d "${TEMPLATES_DIR}" ]; then
  echo "ERROR: Templates directory not found: ${TEMPLATES_DIR}"
  exit 1
fi

# Create bucket if missing
if ! aws s3api head-bucket --bucket "${TEMPLATE_BUCKET}" --region "${REGION}" 2>/dev/null; then
  echo "==> Bucket not found. Creating: ${TEMPLATE_BUCKET}"
  aws s3api create-bucket --bucket "${TEMPLATE_BUCKET}" --region "${REGION}"
else
  echo "==> Bucket exists: ${TEMPLATE_BUCKET}"
fi

echo "==> Uploading templates..."
aws s3 cp "${TEMPLATES_DIR}/" "s3://${TEMPLATE_BUCKET}/${TEMPLATE_PREFIX}/" \
  --recursive --exclude "*" --include "*.yaml" --region "${REGION}"

echo "==> Done. Templates uploaded."
echo "==> Next: run ./scripts/deploy.sh"
