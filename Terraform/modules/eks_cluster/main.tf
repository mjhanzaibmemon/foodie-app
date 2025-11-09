resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  version  = var.kubernetes_version
  role_arn = var.role_arn

  access_config {
    authentication_mode = var.authentication_mode
  }

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }

  enabled_cluster_log_types = var.enabled_cluster_log_types
  
  tags                      = var.tags
}
