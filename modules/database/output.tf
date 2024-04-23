output "db_instance_endpoint" {
  value       = aws_db_instance.default.address
  description = "The endpoint of the RDS database instance."
}

output "db_instance_address" {
  value       = aws_db_instance.default.address
  description = "The database server address."
}

output "db_security_group_id" {
  value       = aws_security_group.db.id
  description = "The ID of the security group for the database instance."
}
