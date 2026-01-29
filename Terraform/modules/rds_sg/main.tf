resource "aws_security_group" "this" {
  name   = var.name
  vpc_id = var.vpc_id

  # Revoke rules before resource destruction
  revoke_rules_on_delete = true

  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
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
    Name = var.name
  }
}
