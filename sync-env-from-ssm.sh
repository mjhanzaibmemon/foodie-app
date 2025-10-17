#!/bin/bash

# Set the SSM base path
SSM_PATH="/foodie/prod"
ENV_FILE=".env"

# Clear existing .env
> "$ENV_FILE"

# Fetch and write to .env
aws ssm get-parameters-by-path \
    --path "$SSM_PATH" \
    --recursive \
    --with-decryption \
    --output text \
    --query "Parameters[*].[Name,Value]" |
while IFS=$'\t' read -r name value; do
    var_name=$(basename "$name")
    echo "$var_name=$value" >> "$ENV_FILE"
done

echo ".env file populated from AWS SSM at $SSM_PATH"
