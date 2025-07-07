variable "vpc_id" {
  type = string
}

variable "env" {
  type = string
}

variable "ssh_cidr_blocks" {
  type        = list(string)
  default     = ["0.0.0.0/0"] # change this in prod!
}

variable "web_subnet_ids" {
  type = list(string)
}

variable "app_subnet_ids" {
  type = list(string)
}

variable "web_subnet_cidr" {
  type = string
  description = "CIDR block for web tier (used in app ACL rule)"
}
