variable "vpc_id" {
  description = "CICD_Infra"
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
  description = "dev"
  type        = string
}
