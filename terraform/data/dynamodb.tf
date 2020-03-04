resource "aws_dynamodb_table" "kops_clusters" {
  name           = "kops-clusters"
  hash_key       = "FQDN"                                                 

  billing_mode = "PAY_PER_REQUEST"

  lifecycle {
    ignore_changes = [read_capacity, write_capacity]
  }

  attribute {
    name = "FQDN"
    type = "S"
  }
}
