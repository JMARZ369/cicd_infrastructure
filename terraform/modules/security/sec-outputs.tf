output "general_sg_id" {
  value       = aws_security_group.general_sg.id
  description = "General purpose security group ID"
}

output "ec2_role_name" {
  value       = aws_iam_role.ec2_role.name
  description = "IAM role name for EC2"
}
