variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "enable_container_insights" {
  description = "Enable Container Insights"
  type        = bool
  default     = true
}

variable "default_capacity_provider_base" {
  description = "Number of tasks to place on FARGATE by default"
  type        = number
  default     = 1
}
