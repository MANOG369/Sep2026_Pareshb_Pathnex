resource "aws_vpc" "pathnex_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "pathnex-vpc"
  }
}
