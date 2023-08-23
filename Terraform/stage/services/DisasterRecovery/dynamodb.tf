resource "aws_dynamodb_table" "this" {
  name         = "product"
  billing_mode = "PAY_PER_REQUEST"
  #  read_capacity = 20
  #  write_capacity = 20
  attribute {
    name = "product_id"
    type = "S"
  }
  hash_key = "product_id"
}