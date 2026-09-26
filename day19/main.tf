terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_cloudwatch_log_group" "pathnex_log_group" {
  name = "pathnex-log-group"
}

resource "aws_cloudwatch_log_stream" "pathnex_log_stream" {
  log_group_name = aws_cloudwatch_log_group.pathnex_log_group.name
  name           = "pathnex-log-stream"
}
