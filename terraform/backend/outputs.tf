output "vpc_endpoints_dynamodb_table" {
  value = {
    name     = aws_dynamodb_table.vpc_endpoints.name
    hash_key = aws_dynamodb_table.vpc_endpoints.hash_key
  }
}
