resource "aws_db_instance" "this" {
  identifier = var.identifier

  engine         = "mysql"
  engine_version = var.engine_version

  instance_class = var.instance_class

  username = var.username
  password = var.password
  db_name  = var.db_name

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  storage_type = var.storage_type

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [var.sg_id]

  publicly_accessible = false

  # Required settings for resource destruction
  skip_final_snapshot    = true
  deletion_protection    = false
  delete_automated_backups = true

  tags = {
    Name = var.identifier
  }
}
