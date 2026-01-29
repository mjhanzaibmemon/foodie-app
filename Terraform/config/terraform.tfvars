# NOTE: environment and aws_region are passed from workflow via -var flags
# DO NOT set environment or aws_region here - they come from GitHub secrets
#   -var="environment=${DEPLOY_ENV}"
#   -var="aws_region=${AWS_REGION}"

ecs_task_cpu      = 256
ecs_task_memory   = 512
ecs_desired_count = 2

# ECR repository name (shared across environments)
ecr_repository_name = "foodie-ecr"

alb_listener_port = 80

# RDS settings (identifier format: foodie-{environment}-db)
rds_instance_class    = "db.t3.micro"
rds_engine_version    = "8.0"
rds_allocated_storage = 20
ecs_container_image   = ""

# Tags are set in variable.tf with dynamic environment from var.environment
# No need to override here
