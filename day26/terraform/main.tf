data "aws_vpc" "existing_vpc" {
  id = "vpc-0cdee2a0cde955069"
}

resource "aws_cloudwatch_log_group" "pathnex_flow_logs_group" {
  name = "pathnex-flow-logs"
}

resource "aws_flow_log" "pathnex_flow_log" {
  log_destination      = aws_cloudwatch_log_group.pathnex_flow_logs_group.arn
  log_destination_type = "cloud-watch-logs"
  vpc_id               = data.aws_vpc.existing_vpc.id
  traffic_type         = "ALL"
}
