resource "aws_iam_role" "aws_iam_role" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy

  # Force detach policies during destruction for clean removal
  force_detach_policies = true
}

