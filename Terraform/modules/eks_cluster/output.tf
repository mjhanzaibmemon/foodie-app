output "cluster_name" {
  description = "EKS Cluster name"
  value       = aws_eks_cluster.eks_cluster.name
}

# output "cluster_endpoint" {
#   description = "EKS Cluster endpoint"
#   value       = aws_eks_cluster.eks_cluster.endpoint
# }

output "cluster_arn" {
  description = "EKS Cluster ARN"
  value       = aws_eks_cluster.eks_cluster.arn
}

output "cluster_id" {
  description = "EKS Cluster ID"
  value       = aws_eks_cluster.eks_cluster.id
}
