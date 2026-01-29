resource "aws_db_parameter_group" "this" {
  name   = var.name
  family = var.family

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.key
      value = parameter.value
    }
  }

  tags = {
    Name = var.name
  }
}
