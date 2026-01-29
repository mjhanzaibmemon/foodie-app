variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "target_port" {
  description = "Port for the target group"
  type        = number
  default     = 8080
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "health_check_healthy_threshold" {
  description = "Number of consecutive health checks successes required to be healthy"
  type        = number
  default     = 2  # Fast enough for deployment
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive health check failures required to be unhealthy"
  type        = number
  default     = 3  # More tolerant to avoid false positives
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 15  # Faster checks for quicker detection (was 30)
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}

variable "health_check_matcher" {
  description = "HTTP codes to match for health check"
  type        = string
  default     = "200-299"
}
