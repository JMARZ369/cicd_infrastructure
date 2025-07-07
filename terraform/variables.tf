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
  default     = "t3.micro"
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
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
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
