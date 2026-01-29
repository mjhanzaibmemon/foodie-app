output "acr_repository_arn" {
  value = aws_ecr_repository.aws_ecr_repository.arn
}
output "acr_repository_url" {
  value = aws_ecr_repository.aws_ecr_repository.repository_url
}

output "ecr_repository_url" {
  description = "ECR repository URL for ECS tasks to pull images"
  value       = aws_ecr_repository.aws_ecr_repository.repository_url
}
