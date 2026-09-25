terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_vpc" "pathnex" {
  cidr_block = "10.30.0.0/16"

  tags = {
    Name = "day18-pathnex-vpc"
  }
}

resource "aws_internet_gateway" "pathnex" {
  vpc_id = aws_vpc.pathnex.id

  tags = {
    Name = "day18-pathnex-igw"
  }
}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.pathnex.id
  cidr_block              = "10.30.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "day18-public-1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.pathnex.id
  cidr_block              = "10.30.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "day18-public-2"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.pathnex.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pathnex.id
  }

  tags = {
    Name = "day18-public-route-table"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "allow_http" {
  name        = "day18-alb-sg"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.pathnex.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "day18-alb-security-group"
  }
}

resource "aws_security_group" "allow_web" {
  name        = "day18-web-sg"
  description = "Allow HTTP from ALB"
  vpc_id      = aws_vpc.pathnex.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_http.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "day18-web-security-group"
  }
}

resource "aws_launch_template" "pathnex" {
  name_prefix   = "day18-pathnex-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.allow_web.id
  ]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    dnf install -y nginx
    systemctl enable nginx
    systemctl start nginx
    echo "Day 18 Pathnex Auto Scaling Web Server" > /usr/share/nginx/html/index.html
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "day18-pathnex-web"
    }
  }
}

resource "aws_lb" "pathnex" {
  name               = "day18-pathnex-lb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.allow_http.id
  ]

  subnets = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]

  tags = {
    Name = "day18-pathnex-alb"
  }
}

resource "aws_lb_target_group" "pathnex" {
  name     = "day18-pathnex-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.pathnex.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "day18-pathnex-target-group"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.pathnex.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pathnex.arn
  }
}

resource "aws_autoscaling_group" "pathnex" {
  name = "day18-pathnex-asg"

  min_size         = 2
  max_size         = 5
  desired_capacity = 3

  vpc_zone_identifier = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]

  target_group_arns = [
    aws_lb_target_group.pathnex.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.pathnex.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "day18-pathnex-asg-instance"
    propagate_at_launch = true
  }
}

output "load_balancer_dns" {
  value = aws_lb.pathnex.dns_name
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.pathnex.name
}
