output "endpoint" {
  value = aws_db_instance.this.address
}
output "db_endpoint_address" {
  description = "Database endpoint address for applications to connect"
  value       = aws_db_instance.this.address
}