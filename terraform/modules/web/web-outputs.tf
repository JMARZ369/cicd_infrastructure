output "web_subnet_ids" {
  description = "IDs of public web subnets"
  value       = [aws_subnet.web_subnet_a.id, aws_subnet.web_subnet_b.id]
}

output "web_igw_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.web_igw.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway (for app/db tier access to internet)"
  value       = aws_nat_gateway.web_nat.id
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.web_alb.dns_name
}

output "alb_sg_id" {
  description = "Security Group ID used by the ALB"
  value       = aws_security_group.alb_sg.id
}

output "alb_target_group_arn" {
  description = "Target group ARN for use in ASG"
  value       = aws_lb_target_group.web_tg.arn
}

output "web_asg_name" {
  description = "Name of the Auto Scaling Group for the web tier"
  value       = aws_autoscaling_group.web_asg.name
}
