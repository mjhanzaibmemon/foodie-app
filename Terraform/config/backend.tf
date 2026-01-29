terraform {
  # Backend configuration is provided at runtime via -backend-config flags
  # This allows different environments (dev/stage/prod) to use different state files
  #
  # Example init command:
  #   terraform init \
  #     -backend-config="bucket=my-terraform-state-bucket" \
  #     -backend-config="key=infra/dev/terraform.tfstate" \
  #     -backend-config="region=us-east-1"
  backend "s3" {
    encrypt = true
    # bucket, key, and region are provided via -backend-config at init time
  }
}