resource "aws_subnet" "app_subnet_a" {
  vpc_id            = var.vpc_id
  cidr_block        = var.app_subnet_cidr_a
  availability_zone = var.az_a
  tags = {
    Name = "${var.env}-app-subnet-a"
  }
}

resource "aws_subnet" "app_subnet_b" {
  vpc_id            = var.vpc_id
  cidr_block        = var.app_subnet_cidr_b
  availability_zone = var.az_b
  tags = {
    Name = "${var.env}-app-subnet-b"
  }
}

resource "aws_route_table" "app_rt" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.env}-app-private-rt"
  }
}

resource "aws_route" "nat_route" {
  route_table_id         = aws_route_table.app_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id
}

resource "aws_route_table_association" "app_subnet_a_assoc" {
  subnet_id      = aws_subnet.app_subnet_a.id
  route_table_id = aws_route_table.app_rt.id
}

resource "aws_route_table_association" "app_subnet_b_assoc" {
  subnet_id      = aws_subnet.app_subnet_b.id
  route_table_id = aws_route_table.app_rt.id
}

resource "aws_security_group" "app_sg" {
  name        = "${var.env}-app-sg"
  description = "Allow inbound from ALB only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
    description     = "Allow HTTP from ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-app-sg"
  }
}

resource "aws_launch_template" "app_lt" {
  name_prefix   = "${var.env}-app-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.env}-app-instance"
    }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "${var.env}-app-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = [aws_subnet.app_subnet_a.id, aws_subnet.app_subnet_b.id]
  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.env}-app-instance"
    propagate_at_launch = true
  }
}
