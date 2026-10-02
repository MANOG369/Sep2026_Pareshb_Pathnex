resource "aws_instance" "pathnex_instance" {
  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t3.micro"

  tags = {
    Name = "pathnex-instance"
  }
}
