output "acr_repository_arn" {
  value = aws_ecr_repository.aws_ecr_repository
}
output "acr_repository_url" {
  value = aws_ecr_repository.aws_ecr_repository.repository_url
}