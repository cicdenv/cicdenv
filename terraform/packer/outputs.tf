output "key" {
  value = {
    key_id = aws_kms_key.ebs.key_id
    arn    = aws_kms_key.ebs.arn
    alias  = aws_kms_alias.ebs.name
  }
}

output "allowed_account_ids" {
  value = join(",", local.allowed_account_ids)
}
