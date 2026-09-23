terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# Default VPC
data "aws_vpc" "default" {
  default = true
}

# Two subnets in different Availability Zones
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Security group for ALB
resource "aws_security_group" "alb" {
  name        = "pathnex-day15-alb-sg"
  description = "Allow HTTP to ALB"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP from Internet"
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
}

# Security group for EC2
resource "aws_security_group" "ec2" {
  name        = "pathnex-day15-ec2-sg"
  description = "Allow HTTP from ALB"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "pathnex_ec2" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.ec2.id]

  user_data = <<-EOF2
    #!/bin/bash
    dnf install -y httpd
    systemctl enable httpd
    systemctl start httpd

    cat > /var/www/html/index.html <<'HTML'
    <html>
      <body>
        <h1>Hello from Pathnex Day 15</h1>
        <h2>Terraform + Application Load Balancer</h2>
      </body>
    </html>
    HTML
  EOF2

  tags = {
    Name = "Pathnex-Day15-EC2"
  }
}

# Application Load Balancer
resource "aws_lb" "pathnex_lb" {
  name               = "pathnex-day15-lb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb.id]

  subnets = [
    data.aws_subnets.default.ids[0],
    data.aws_subnets.default.ids[1]
  ]

  tags = {
    Name = "Pathnex-Day15-ALB"
  }
}

# Target group
resource "aws_lb_target_group" "pathnex_tg" {
  name     = "pathnex-day15-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

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
    Name = "Pathnex-Day15-TG"
  }
}

# Attach EC2 to target group
resource "aws_lb_target_group_attachment" "pathnex_ec2" {
  target_group_arn = aws_lb_target_group.pathnex_tg.arn
  target_id        = aws_instance.pathnex_ec2.id
  port             = 80
}

# ALB listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.pathnex_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pathnex_tg.arn
  }
}
