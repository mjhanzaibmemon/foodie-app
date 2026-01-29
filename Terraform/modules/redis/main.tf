// Security group for Redis allowing access from provided CIDRs
resource "aws_security_group" "this" {
  name   = var.sg_name
  vpc_id = var.vpc_id

  # Revoke rules before resource destruction
  revoke_rules_on_delete = true

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_name
  }
}

resource "aws_elasticache_subnet_group" "this" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids

  tags = {
    Name = var.subnet_group_name
  }
}

resource "aws_elasticache_replication_group" "this" {
  count                         = var.use_replication_group ? 1 : 0
  replication_group_id          = var.replication_group_id
  description                   = var.replication_group_description
  engine                        = "redis"
  engine_version                = var.engine_version
  node_type                     = var.node_type
  automatic_failover_enabled    = var.automatic_failover_enabled
  port                          = var.port

  subnet_group_name = aws_elasticache_subnet_group.this.name

  security_group_ids = [aws_security_group.this.id]

  apply_immediately = var.apply_immediately

  tags = {
    Name = var.replication_group_id
  }
}

resource "aws_elasticache_cluster" "this" {
  count        = var.use_replication_group ? 0 : 1
  cluster_id   = var.replication_group_id
  engine       = "redis"
  engine_version = var.engine_version
  node_type    = var.node_type
  num_cache_nodes = 1
  port         = var.port

  subnet_group_name = aws_elasticache_subnet_group.this.name

  security_group_ids = [aws_security_group.this.id]

  # Apply changes immediately during destroy
  apply_immediately = true

  tags = {
    Name = var.replication_group_id
  }
}
