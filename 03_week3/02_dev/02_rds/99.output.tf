output "dev_rds_address" {
  value       = aws_db_instance.dev_rds.address
  description = "Connect to the database at this endpoint"
}

output "dev_rds_port" {
  value       = aws_db_instance.dev_rds.port
  description = "The port the database is listening on"
}
