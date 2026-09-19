resource "aws_launch_configuration" "example" {
  name          = "example-config"
  image_id      = "ami-08188a5a4dfdbd573"
  instance_type = "t3.medium"
}

resource "aws_autoscaling_group" "example" {
  desired_capacity = 2
  max_size         = 3
  min_size         = 1
  vpc_zone_identifier = [
    "subnet-0f6587ec903acbb1f",
    "subnet-0d03133a315fa5c2a",
    "subnet-05d034677a256d28e"
  ]

  launch_configuration = aws_launch_configuration.example.id
}
