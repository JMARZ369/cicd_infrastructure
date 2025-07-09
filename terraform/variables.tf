variable "env" {
  description = "Environment name (dev or prod)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 app instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2
}

variable "desired_capacity" {
  type    = number
  default = 1
}

variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_engine_version" {
  type    = string
  default = "8.0"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_port" {
  type    = number
  default = 3306
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/20"
}

variable "az_a" {
  description = "Availability Zone A"
  type        = string
  default     = "us-east-2a"
}

variable "az_b" {
  description = "Availability Zone B"
  type        = string
  default     = "us-east-2b"
}

variable "web_subnet_cidr_a" {
  description = "CIDR block for Web Subnet A"
  type        = string
  default     = "192.168.1.0/24"
}

variable "web_subnet_cidr_b" {
  description = "CIDR block for Web Subnet B"
  type        = string
  default     = "192.168.2.0/24"
}

variable "app_subnet_cidr_a" {
  description = "CIDR block for App Subnet A"
  type        = string
  default     = "192.168.3.0/24"
}

variable "app_subnet_cidr_b" {
  description = "CIDR block for App Subnet B"
  type        = string
  default     = "192.168.4.0/24"
}

variable "db_subnet_cidr_a" {
  description = "CIDR block for DB Subnet A"
  type        = string
  default     = "192.168.5.0/24"
}

variable "db_subnet_cidr_b" {
  description = "CIDR block for DB Subnet B"
  type        = string
  default     = "192.168.6.0/24"
}
