# Public Subnets
resource "aws_subnet" "web_subnet_a" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.web_subnet_cidr_a
  availability_zone       = var.az_a
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-web-subnet-a"
  }
}

resource "aws_subnet" "web_subnet_b" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.web_subnet_cidr_b
  availability_zone       = var.az_b
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-web-subnet-b"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "web_igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.env}-igw"
  }
}

# Route Table + Associations
resource "aws_route_table" "web_public_rt" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.env}-web-public-rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.web_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.web_igw.id
}

resource "aws_route_table_association" "web_subnet_a_rt_assoc" {
  subnet_id      = aws_subnet.web_subnet_a.id
  route_table_id = aws_route_table.web_public_rt.id
}

resource "aws_route_table_association" "web_subnet_b_rt_assoc" {
  subnet_id      = aws_subnet.web_subnet_b.id
  route_table_id = aws_route_table.web_public_rt.id
}

# NAT Gateway
resource "aws_eip" "web_nat_eip" {
  depends_on = [aws_internet_gateway.web_igw]
  tags = {
    Name = "${var.env}-nat-eip"
  }
}

resource "aws_nat_gateway" "web_nat" {
  allocation_id = aws_eip.web_nat_eip.id
  subnet_id     = aws_subnet.web_subnet_a.id
  tags = {
    Name = "${var.env}-nat-gateway"
  }
}

# ALB + SG
resource "aws_security_group" "alb_sg" {
  name        = "${var.env}-alb-sg"
  description = "Allow HTTP inbound to ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-alb-sg"
  }
}

resource "aws_lb" "web_alb" {
  name               = "${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.web_subnet_a.id, aws_subnet.web_subnet_b.id]
  tags = {
    Name = "${var.env}-alb"
  }
}

resource "aws_lb_target_group" "web_tg" {
  name        = "${var.env}-web-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.env}-web-tg"
  }
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# ASG Launch Template for Web Tier
resource "aws_launch_template" "web_lt" {
  name_prefix   = "${var.env}-web-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.alb_sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.env}-web-instance"
    }
  }
}

# Web ASG
resource "aws_autoscaling_group" "web_asg" {
  name                      = "${var.env}-web-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = [aws_subnet.web_subnet_a.id, aws_subnet.web_subnet_b.id]

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.web_tg.arn]

  tag {
    key                 = "Name"
    value               = "${var.env}-web-instance"
    propagate_at_launch = true
  }
}
