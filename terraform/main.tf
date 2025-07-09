provider "aws" {
  region = "us-east-2"
}

##############################
# VPC (Shared across modules)
##############################
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "video-edit-vpc"
  }
}

##############################
# Web Module (Public Tier + ALB + ASG)
##############################
module "web" {
  source = "./modules/web"

  vpc_id             = aws_vpc.main.id
  web_subnet_cidr_a  = var.web_subnet_cidr_a
  web_subnet_cidr_b  = var.web_subnet_cidr_b
  az_a               = var.az_a
  az_b               = var.az_b
  env                = var.env

  ami_id             = var.ami_id
  instance_type      = var.instance_type
  min_size           = var.min_size
  max_size           = var.max_size
  desired_capacity   = var.desired_capacity
}

##############################
# App Module (Private Tier + ASG + NAT Access)
##############################
module "app" {
  source = "./modules/app"

  vpc_id             = aws_vpc.main.id
  app_subnet_cidr_a  = var.app_subnet_cidr_a
  app_subnet_cidr_b  = var.app_subnet_cidr_b
  nat_gateway_id     = module.web.nat_gateway_id
  alb_sg_id          = module.web.alb_sg_id
  az_a               = var.az_a
  az_b               = var.az_b
  env                = var.env

  ami_id             = var.ami_id
  instance_type      = var.instance_type
  min_size           = var.min_size
  max_size           = var.max_size
  desired_capacity   = var.desired_capacity
}

##############################
# DB Module (RDS + Private Subnets)
##############################
module "db" {
  source = "./modules/db"

  vpc_id             = aws_vpc.main.id
  db_subnet_cidr_a   = var.db_subnet_cidr_a
  db_subnet_cidr_b   = var.db_subnet_cidr_b
  az_a               = var.az_a
  az_b               = var.az_b
  env                = var.env

  app_sg_id          = module.app.app_sg_id

  engine             = var.db_engine
  engine_version     = var.db_engine_version
  instance_class     = var.db_instance_class
  allocated_storage  = var.db_allocated_storage
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  db_port            = var.db_port
}

##############################
# Security Module (SGs, NACLs, IAM)
##############################
module "security" {
  source = "./modules/security"

  vpc_id           = aws_vpc.main.id
  env              = var.env
  ssh_cidr_blocks  = ["0.0.0.0/0"]  # Replace this with a secure /32 IP
  web_subnet_ids   = module.web.web_subnet_ids
  app_subnet_ids   = module.app.app_subnet_ids
  web_subnet_cidr  = var.web_subnet_cidr_a
}
