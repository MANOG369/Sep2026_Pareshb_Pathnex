terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "eu_west"
  region = "eu-west-1"
}

resource "aws_s3_bucket" "pathnex_bucket" {
  provider = aws.us_east

  bucket = "pathnex-backup-bucket"

  tags = {
    Name = "Pathnex Disaster Recovery Backup"
  }
}

resource "aws_s3_bucket_versioning" "pathnex_bucket_versioning" {
  provider = aws.us_east

  bucket = aws_s3_bucket.pathnex_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "pathnex_backup_bucket_eu" {
  provider = aws.eu_west

  bucket = "pathnex-backup-bucket-eu"

  tags = {
    Name = "Pathnex Disaster Recovery Backup EU"
  }
}

resource "aws_s3_bucket_versioning" "pathnex_backup_bucket_eu_versioning" {
  provider = aws.eu_west

  bucket = aws_s3_bucket.pathnex_backup_bucket_eu.id

  versioning_configuration {
    status = "Enabled"
  }
}
