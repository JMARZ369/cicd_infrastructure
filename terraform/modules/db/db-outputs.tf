output "db_subnet_ids" {
  value       = [aws_subnet.db_subnet_a.id, aws_subnet.db_subnet_b.id]
  description = "DB subnet IDs"
}

output "db_sg_id" {
  value       = aws_security_group.db_sg.id
  description = "RDS DB Security Group ID"
}

output "db_endpoint" {
  value       = aws_db_instance.rds_instance.endpoint
  description = "RDS endpoint"
}
