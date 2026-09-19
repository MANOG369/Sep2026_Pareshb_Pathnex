resource "aws_eip" "pathnex_eip" {
  instance = aws_instance.pathnex_ec2.id
}

resource "aws_instance" "pathnex_ec2" {
  ami           = "ami-08188a5a4dfdbd573"
  instance_type = "t3.medium"

  tags = {
    Name = "Pathnex-EC2"
  }
}
