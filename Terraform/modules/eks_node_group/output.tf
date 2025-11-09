output "node_group_name" {
  description = "Node Group Name"
  value       = aws_eks_node_group.eks_node_group.node_group_name
}
output "node_group_arn" {
  value = aws_eks_node_group.eks_node_group.arn
}

output "node_group_id" {
  value = aws_eks_node_group.eks_node_group.id
}