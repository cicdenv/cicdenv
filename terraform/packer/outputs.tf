output "key_id" {
  value = aws_kms_key.ebs.arn
}

output "key_alias" {
  value = aws_kms_alias.ebs.arn
}

output "allowed_account_ids" {
  value = join(",", local.allowed_account_ids)
}
