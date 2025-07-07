output "web_subnet_ids" {
  description = "IDs of public web subnets"
  value       = [aws_subnet.web_subnet_a.id, aws_subnet.web_subnet_b.id]
}

output "web_igw_id" {
  description = "ID of Internet Gateway"
  value       = aws_internet_gateway.web_igw.id
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.web_alb.dns_name
}

output "alb_sg_id" {
  description = "Security Group ID for ALB"
  value       = aws_security_group.alb_sg.id
}

output "alb_target_group_arn" {
  description = "Target group ARN for use in ASG later"
  value       = aws_lb_target_group.web_tg.arn
}

output "nat_gateway_id" {
  value       = aws_nat_gateway.web_nat.id
  description = "NAT Gateway ID for private tier use"
}
