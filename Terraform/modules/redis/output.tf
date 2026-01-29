output "replication_group_id" {
	value = try(aws_elasticache_replication_group.this[0].replication_group_id, aws_elasticache_cluster.this[0].id)
}

output "primary_endpoint_address" {
	value = try(aws_elasticache_replication_group.this[0].primary_endpoint_address, aws_elasticache_cluster.this[0].cache_nodes[0].address)
}

output "port" {
	value = try(aws_elasticache_replication_group.this[0].port, aws_elasticache_cluster.this[0].port)
}

output "security_group_id" {
	value = aws_security_group.this.id
}
