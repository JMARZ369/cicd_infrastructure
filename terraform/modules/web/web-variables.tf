variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "web_subnet_cidr_a" {
  description = "CIDR block for Web Subnet A"
  type        = string
}

variable "web_subnet_cidr_b" {
  description = "CIDR block for Web Subnet B"
  type        = string
}

variable "az_a" {
  description = "Availability Zone A"
  type        = string
}

variable "az_b" {
  description = "Availability Zone B"
  type        = string
}

variable "env" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use in the Launch Template"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for ASG"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum number of EC2 instances in ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of EC2 instances in ASG"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances in ASG"
  type        = number
  default     = 1
}
