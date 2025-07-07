variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "app_subnet_cidr_a" {
  type        = string
  description = "CIDR block for app subnet A"
}

variable "app_subnet_cidr_b" {
  type        = string
  description = "CIDR block for app subnet B"
}

variable "nat_gateway_id" {
  type        = string
  description = "NAT Gateway ID from the web tier"
}

variable "alb_sg_id" {
  type        = string
  description = "Security Group ID of the ALB (for inbound access)"
}

variable "env" {
  type        = string
  description = "Environment name"
}

variable "az_a" {
  type        = string
}

variable "az_b" {
  type        = string
}

variable "ami_id" {
  type        = string
  description = "AMI ID for app instances"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  type        = number
  default     = 1
}

variable "max_size" {
  type        = number
  default     = 2
}

variable "desired_capacity" {
  type        = number
  default     = 1
}
