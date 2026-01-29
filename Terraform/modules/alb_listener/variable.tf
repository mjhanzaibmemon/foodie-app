variable "alb_arn" {
  description = "ARN of the load balancer"
  type        = string
}

variable "listener_port" {
  description = "Port for the listener"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Protocol for the listener (HTTP or HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "target_group_arn" {
  description = "ARN of the target group"
  type        = string
}
