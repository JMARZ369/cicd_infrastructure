##############################
# Security Groups (Optional General SGs)
##############################

resource "aws_security_group" "general_sg" {
  name        = "${var.env}-general-sg"
  description = "General SG for future use"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
    description = "SSH access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-general-sg"
  }
}

##############################
# Network ACLs
##############################

resource "aws_network_acl" "web_acl" {
  vpc_id = var.vpc_id
  subnet_ids = var.web_subnet_ids
  tags = {
    Name = "${var.env}-web-acl"
  }

  ingress {
    rule_no    = 100
    protocol   = "6"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_network_acl" "app_acl" {
  vpc_id = var.vpc_id
  subnet_ids = var.app_subnet_ids
  tags = {
    Name = "${var.env}-app-acl"
  }

  ingress {
    rule_no    = 100
    protocol   = "6"
    action = "allow"
    cidr_block = var.web_subnet_cidr
    from_port  = 80
    to_port    = 80
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

##############################
# IAM Role for EC2 Instances
##############################

resource "aws_iam_role" "ec2_role" {
  name = "${var.env}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
