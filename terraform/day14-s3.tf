resource "aws_s3_bucket" "pathnex_bucket" {
  bucket = "pathnex-bucket"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "pathnex-log-bucket"
    target_prefix = "logs/"
  }
}
