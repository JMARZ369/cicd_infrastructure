resource "aws_subnet" "db_subnet_a" {
  vpc_id            = var.vpc_id
  cidr_block        = var.db_subnet_cidr_a
  availability_zone = var.az_a
  tags = {
    Name = "${var.env}-db-subnet-a"
  }
}

resource "aws_subnet" "db_subnet_b" {
  vpc_id            = var.vpc_id
  cidr_block        = var.db_subnet_cidr_b
  availability_zone = var.az_b
  tags = {
    Name = "${var.env}-db-subnet-b"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.env}-db-subnet-group"
  subnet_ids = [aws_subnet.db_subnet_a.id, aws_subnet.db_subnet_b.id]
  tags = {
    Name = "${var.env}-db-subnet-group"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "${var.env}-db-sg"
  description = "Allow DB access from App SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [var.app_sg_id]
    description     = "Allow traffic from App SG"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-db-sg"
  }
}

resource "aws_db_instance" "rds_instance" {
  identifier             = "${var.env}-rds"
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  multi_az               = true
  skip_final_snapshot    = true

  tags = {
    Name = "${var.env}-rds"
  }
}