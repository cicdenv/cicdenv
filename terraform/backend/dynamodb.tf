resource "aws_dynamodb_table" "vpc_endpoints" {
  name           = "vpc-endpoints"
  hash_key       = "VPCeID"                                                 

  billing_mode = "PAY_PER_REQUEST"

  lifecycle {
    ignore_changes = [read_capacity, write_capacity]
  }

  attribute {
    name = "VPCeID"
    type = "S"
  }
}
