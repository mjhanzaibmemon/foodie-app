variable "vpc_id" {
}

variable "tags_name" {
  description = "Name tag for the Internet Gateway"
  type        = string
  default     = "igw-main"
}