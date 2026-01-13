#!/usr/bin/env bash
set -euo pipefail

REGION="us-east-1"
STACK_NAME="serverless-cloudops-event-pipeline"

echo "==> Deleting stack: ${STACK_NAME} (region: ${REGION})"
aws cloudformation delete-stack --region "${REGION}" --stack-name "${STACK_NAME}"

echo "==> Waiting for delete to complete..."
aws cloudformation wait stack-delete-complete --region "${REGION}" --stack-name "${STACK_NAME}"

echo "==> Stack deleted."
