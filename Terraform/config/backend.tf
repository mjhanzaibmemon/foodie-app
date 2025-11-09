terraform {
  backend "s3" {
    bucket  = "terraformstatefileuse2"  # your S3 bucket name
    key     = "infra/terraform.tfstate" # path within the bucket
    region  = "us-east-2"               # AWS region
    encrypt = true
  }
}
