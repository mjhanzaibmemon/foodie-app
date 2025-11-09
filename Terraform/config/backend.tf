terraform {
  backend "s3" {
    bucket         = "devtest9280"   # your S3 bucket name
    key            = "infra/terraform.tfstate"    # path within the bucket
    region         = "us-east-1"                # AWS region
    encrypt        = true
  }
}
