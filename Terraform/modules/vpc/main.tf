resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block

  # DNS settings - required for proper functioning
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.tags_name
  }
}
