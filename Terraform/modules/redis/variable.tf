variable "vpc_id" {
	description = "VPC id where redis will be deployed"
}

variable "subnet_ids" {
	type        = list(string)
	description = "List of subnet ids for ElastiCache subnet group"
}

variable "subnet_group_name" {
	default     = "redis-subnet-group"
}

variable "sg_name" {
	default = "redis-sg"
}

variable "ingress_cidrs" {
	type    = list(string)
	default = ["10.0.0.0/16"]
}

variable "port" {
	default = 6379
}

variable "replication_group_id" {
	default = "redis-replication-group"
}

variable "replication_group_description" {
	default = "Redis replication group for application caching"
}

variable "engine_version" {
	default = "6.x"
}

variable "node_type" {
	default = "cache.t3.small"
}

variable "number_cache_clusters" {
	default = 1
}

variable "automatic_failover_enabled" {
	default = false
}

variable "apply_immediately" {
	default = false
}

variable "use_replication_group" {
	description = "When true create an ElastiCache replication group; when false create a single-node cluster"
	type        = bool
	default     = true
}