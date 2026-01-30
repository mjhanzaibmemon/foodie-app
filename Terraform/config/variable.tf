################################################################################
#                         ECS Configuration Variables                          #
################################################################################

variable "ecs_task_cpu" {
  description = "ECS Fargate task CPU units (256=0.25vCPU, 512=0.5vCPU, etc.)"
  type        = number
  default     = 256
}

variable "ecs_task_memory" {
  description = "ECS Fargate task memory in MB"
  type        = number
  default     = 512
}

variable "ecs_desired_count" {
  description = "Desired number of ECS Fargate tasks"
  type        = number
  default     = 10
}

variable "ecs_container_image" {
  description = "Docker image URI for ECS task (from ECR)"
  type        = string
  default     = "" # Override with ECR image URL in terraform.tfvars
}

variable "ecs_container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 80
}

################################################################################
#                         General Configuration Variables                      #
################################################################################

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ecr_repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "foodie-ecr"
}

variable "alb_name" {
  description = "Application Load Balancer name (NOT USED - hardcoded in main.tf)"
  type        = string
  default     = "foodie-alb"
}

variable "alb_listener_port" {
  description = "ALB listener port"
  type        = number
  default     = 80
}

################################################################################
#                         RDS Configuration Variables                          #
################################################################################

variable "rds_allocated_storage" {
  description = "Allocated storage for RDS instance in GB"
  type        = number
  default     = 20
}

variable "rds_max_allocated_storage" {
  description = "Maximum allocated storage for RDS autoscaling in GB"
  type        = number
  default     = 90
}

variable "rds_identifier" {
  description = "RDS instance identifier (NOT USED - hardcoded in main.tf as foodie-{env}-db)"
  type        = string
  default     = "foodie-db"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.m5.large"
}

variable "rds_engine" {
  description = "RDS engine type"
  type        = string
  default     = "mysql"
}

variable "rds_engine_version" {
  description = "RDS engine version"
  type        = string
  default     = "8.0"
}

variable "rds_storage_type" {
  description = "RDS storage type"
  type        = string
  default     = "gp3"
}

variable "rds_db_name" {
  description = "RDS database name"
  type        = string
  default     = "etra_foodie"
}

variable "rds_parameter_group_name" {
  description = "RDS parameter group name"
  type        = string
  default     = "foodie-sql-parameters"
}

# Note: Tags are set inline in each resource/module in main.tf
# Environment is dynamic via var.environment passed from workflow

################################################################################
#                         Secrets Manager Configuration                        #
################################################################################

variable "db_secrets_arn" {
  description = "ARN of the Secrets Manager secret containing DB credentials (DB_USER, DB_PASS)"
  type        = string
  default     = "" # Must be provided via GitHub secrets or terraform.tfvars
}

