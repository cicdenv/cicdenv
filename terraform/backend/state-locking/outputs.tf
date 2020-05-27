output "terraform_lock_dynamodb_table" {
  value = {
    name     = aws_dynamodb_table.terraform_lock.name
    hash_key = aws_dynamodb_table.terraform_lock.hash_key
  }
}
