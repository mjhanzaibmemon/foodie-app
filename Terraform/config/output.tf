################################################################################
#                         Terraform Outputs                                    #
################################################################################

# ALB Outputs
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = module.alb.alb_arn
}

# ECS Outputs
output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs_cluster.cluster_name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = "foodie-service-${var.environment}"
}

# ECR Output
output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.ecr_repository_url
}

# RDS Outputs
output "rds_endpoint" {
  description = "RDS database endpoint (host:port)"
  value       = module.rds_instance.db_endpoint_address
}

output "rds_identifier" {
  description = "RDS instance identifier"
  value       = "foodie-${var.environment}-db"
}

# Redis Outputs
output "redis_endpoint" {
  description = "Redis primary endpoint address"
  value       = module.redis.primary_endpoint_address
}

# VPC Outputs
output "vpc_id" {
  description = "VPC ID (existing or newly created)"
  value       = local.vpc_id
}

# Secrets Manager Update Status
output "secrets_manager_updated" {
  description = "Confirms Secrets Manager was updated with DB_HOST and REDIS_HOST"
  value       = var.db_secrets_arn != "" ? "YES - Secret updated with DB_HOST and REDIS_HOST" : "NO - db_secrets_arn not provided"
}

# Application URL
output "application_url" {
  description = "Application URL (HTTP)"
  value       = "http://${module.alb.alb_dns_name}"
}

# Environment Info
output "environment" {
  description = "Current deployment environment"
  value       = var.environment
}

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}
