resource "aws_iam_role" "aws_iam_role" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
}

