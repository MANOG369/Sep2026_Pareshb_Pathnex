resource "aws_dynamodb_table" "pathnex_table" {
  name           = "pathnex-table"
  hash_key       = "id"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }
}
