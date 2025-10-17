#!/bin/bash
set -e

echo "🔐 Fetching environment variables from AWS SSM..."
aws ssm get-parameters-by-path --path "/foodie/prod" --with-decryption \
  --query "Parameters[*].[Name,Value]" --output text |
while read -r name value; do
  key=$(basename "$name" | tr '[:lower:]' '[:upper:]')
  echo "$key=$value"
done > .env.generated

echo "✅ Environment variables loaded into .env.generated"
