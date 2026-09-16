resource "aws_instance" "PathnexEC2" {
  ami           = "ami-0e34b50e714a297f1"
  instance_type = "t2.medium"

  tags = {
    Name = "Pathnex-Server"
  }

  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = 50
  }
}
