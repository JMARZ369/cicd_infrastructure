provider "aws" {
  region = "us-east-2"
}

##############################
# VPC 
##############################
resource "aws_vpc" "main" {
  cidr_block           = "192.168.0.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "CICD_Infra"
  }
}

################################
# Web Module (Public Tier + ALB)
################################
module "web" {
  source = "./modules/web"

  vpc_id            = aws_vpc.main.id
  web_subnet_cidr_a = "192.168.11.0/24"
  web_subnet_cidr_b = "192.168.12.0/24"
  az_a              = "us-east-2a"
  az_b              = "us-east-2b"
  env               = var.env
}

#########################################
# App Module (Private Tier + ASG + NAT)
#########################################
module "app" {
  source = "./modules/app"

  vpc_id            = aws_vpc.main.id
  app_subnet_cidr_a = "192.168.21.0/24"
  app_subnet_cidr_b = "192.168.22.0/24"
  nat_gateway_id    = module.web.nat_gateway_id # TO BE ADDED TO WEB OUTPUTS
  alb_sg_id         = module.web.alb_sg_id
  az_a              = "us-east-2a"
  az_b              = "us-east-2b"
  env               = var.env

  ami_id           = var.ami_id
  instance_type    = var.instance_type
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity
}

################################
# DB Module (RDS Tier - Private)
################################
module "db" {
  source = "./modules/db"

  vpc_id = aws_vpc.main.id
  az_a   = "us-east-2a"
  az_b   = "us-east-2b"
  env    = var.env

  db_subnet_cidr_a = "192.168.31.0/24"
  db_subnet_cidr_b = "192.168.32.0/24"

  app_sg_id = module.app.app_sg_id

  engine            = var.db_engine
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  db_port           = var.db_port
}

module "security" {
  source = "./modules/security"

  vpc_id          = aws_vpc.main.id
  env             = var.env
  ssh_cidr_blocks = ["0.0.0.0/0"]
  web_subnet_ids  = module.web.web_subnet_ids
  app_subnet_ids  = module.app.app_subnet_ids
  web_subnet_cidr = "192.168.11.0/24" # or combine 11.0/24 + 12.0/24 if needed
}
