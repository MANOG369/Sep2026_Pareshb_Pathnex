terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  alias  = "mumbai"
  region = "ap-south-1"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

data "aws_ssm_parameter" "al2023_mumbai" {
  provider = aws.mumbai
  name     = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

data "aws_ssm_parameter" "al2023_virginia" {
  provider = aws.virginia
  name     = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# -------------------------
# Mumbai VPC
# -------------------------

resource "aws_vpc" "mumbai" {
  provider   = aws.mumbai
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "Day16-Mumbai-VPC"
  }
}

resource "aws_subnet" "mumbai" {
  provider          = aws.mumbai
  vpc_id            = aws_vpc.mumbai.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Day16-Mumbai-Subnet"
  }
}

resource "aws_internet_gateway" "mumbai" {
  provider = aws.mumbai
  vpc_id   = aws_vpc.mumbai.id

  tags = {
    Name = "Day16-Mumbai-IGW"
  }
}

resource "aws_route_table" "mumbai" {
  provider = aws.mumbai
  vpc_id   = aws_vpc.mumbai.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mumbai.id
  }

  tags = {
    Name = "Day16-Mumbai-RT"
  }
}

resource "aws_route_table_association" "mumbai" {
  provider       = aws.mumbai
  subnet_id      = aws_subnet.mumbai.id
  route_table_id = aws_route_table.mumbai.id
}

resource "aws_security_group" "mumbai" {
  provider = aws.mumbai
  name     = "day16-mumbai-sg"
  vpc_id   = aws_vpc.mumbai.id

  tags = {
    Name = "Day16-Mumbai-SG"
  }
}

resource "aws_instance" "mumbai" {
  provider      = aws.mumbai
  ami           = data.aws_ssm_parameter.al2023_mumbai.value
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.mumbai.id

  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.mumbai.id
  ]

  tags = {
    Name = "Day16-Mumbai-EC2"
  }
}

# -------------------------
# Virginia VPC
# -------------------------

resource "aws_vpc" "virginia" {
  provider   = aws.virginia
  cidr_block = "10.20.0.0/16"

  tags = {
    Name = "Day16-Virginia-VPC"
  }
}

resource "aws_subnet" "virginia" {
  provider          = aws.virginia
  vpc_id            = aws_vpc.virginia.id
  cidr_block        = "10.20.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Day16-Virginia-Subnet"
  }
}

resource "aws_internet_gateway" "virginia" {
  provider = aws.virginia
  vpc_id   = aws_vpc.virginia.id

  tags = {
    Name = "Day16-Virginia-IGW"
  }
}

resource "aws_route_table" "virginia" {
  provider = aws.virginia
  vpc_id   = aws_vpc.virginia.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.virginia.id
  }

  tags = {
    Name = "Day16-Virginia-RT"
  }
}

resource "aws_route_table_association" "virginia" {
  provider       = aws.virginia
  subnet_id      = aws_subnet.virginia.id
  route_table_id = aws_route_table.virginia.id
}

resource "aws_security_group" "virginia" {
  provider = aws.virginia
  name     = "day16-virginia-sg"
  vpc_id   = aws_vpc.virginia.id

  tags = {
    Name = "Day16-Virginia-SG"
  }
}

resource "aws_instance" "virginia" {
  provider      = aws.virginia
  ami           = data.aws_ssm_parameter.al2023_virginia.value
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.virginia.id

  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.virginia.id
  ]

  tags = {
    Name = "Day16-Virginia-EC2"
  }
}

# -------------------------
# Outputs
# -------------------------

output "mumbai_instance_id" {
  value = aws_instance.mumbai.id
}

output "mumbai_public_ip" {
  value = aws_instance.mumbai.public_ip
}

output "virginia_instance_id" {
  value = aws_instance.virginia.id
}

output "virginia_public_ip" {
  value = aws_instance.virginia.public_ip
}
