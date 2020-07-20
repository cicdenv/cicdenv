output "security_groups" {
  value = {
    server = {
      id = aws_security_group.mysql_shared.id
    }
  }
}

output "mysql_backups" {
  value = {
    bucket = {
      id   = aws_s3_bucket.mysql_backups.id
      name = aws_s3_bucket.mysql_backups.bucket
      arn  = aws_s3_bucket.mysql_backups.arn
    }
    key = {
      key_id = aws_kms_key.mysql_backups.key_id
      alias  = aws_kms_alias.mysql_backups.name
      arn    = aws_kms_key.mysql_backups.arn
    }
  }
}
