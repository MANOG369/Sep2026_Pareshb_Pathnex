resource "aws_lb" "pathnex_lb" {
  name               = "pathnex-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_ssh_http.id]
  subnets            = [aws_subnet.public.id]
}

resource "aws_instance" "pathnex_ec2" {
  ami           = "ami-08188a5a4dfdbd573"
  instance_type = "t2.micro"

  security_groups = [aws_security_group.allow_ssh_http.name]

  tags = {
    Name = "Pathnex-EC2"
  }
}
