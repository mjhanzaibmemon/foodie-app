variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN for EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for EKS control plane"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to the cluster"
  type        = map(string)
}

variable "authentication_mode" {
  
}

variable "endpoint_private_access" {
  description = "Enable private API server endpoint"
  type        = bool
}

variable "endpoint_public_access" {
  description = "Enable public API server endpoint"
  type        = bool
}

variable "public_access_cidrs" {
  description = "CIDR blocks allowed for public API access"
  type        = list(string)
}

variable "service_ipv4_cidr" {
  description = "Service IPv4 CIDR block for Kubernetes networking"
  type        = string
}

variable "enabled_cluster_log_types" {
  description = "List of enabled cluster log types"
  type        = list(string)
}


