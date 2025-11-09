resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = var.policy_attachment_role_name
  policy_arn = var.cluster_policy_arn
}

