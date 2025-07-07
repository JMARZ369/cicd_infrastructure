variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "az_a" {
  type = string
}

variable "az_b" {
  type = string
}

variable "env" {
  type        = string
  description = "Environment name"
}

variable "db_subnet_cidr_a" {
  type        = string
  description = "CIDR block for DB Subnet A"
}

variable "db_subnet_cidr_b" {
  type        = string
  description = "CIDR block for DB Subnet B"
}

variable "app_sg_id" {
  type        = string
  description = "App security group ID"
}

variable "engine" {
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  type        = number
  default     = 20
}

variable "db_name" {
  type        = string
  default     = "appdb"
}

variable "db_username" {
  type        = string
}

variable "db_password" {
  type        = string
  sensitive   = true
}

variable "db_port" {
  type        = number
  default     = 3306
}
