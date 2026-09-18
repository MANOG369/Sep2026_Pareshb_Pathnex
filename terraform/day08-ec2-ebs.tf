resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "pathnex_ec2" {
  ami           = "ami-08188a5a4dfdbd573"
  instance_type = "t3.medium"
  security_groups = [aws_security_group.allow_ssh_http.name]

  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = 30
  }
}
