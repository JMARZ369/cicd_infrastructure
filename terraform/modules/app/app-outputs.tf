output "app_subnet_ids" {
  value       = [aws_subnet.app_subnet_a.id, aws_subnet.app_subnet_b.id]
  description = "App subnet IDs"
}

output "app_sg_id" {
  value       = aws_security_group.app_sg.id
  description = "App Security Group ID"
}

output "app_asg_name" {
  value       = aws_autoscaling_group.app_asg.name
  description = "App Auto Scaling Group name"
}
