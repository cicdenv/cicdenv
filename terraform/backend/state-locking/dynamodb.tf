#
# https://www.terraform.io/docs/backends/types/s3.html#dynamodb_table
#
resource "aws_dynamodb_table" "terraform_lock" {
  name           = var.dynamodb_table
  hash_key       = "LockID"                                                 

  billing_mode = "PAY_PER_REQUEST"

  lifecycle {
    ignore_changes = [read_capacity, write_capacity]
  }

  attribute {
    name = "LockID"
    type = "S"
  }
}
