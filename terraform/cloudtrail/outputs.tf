output "cloudtrail_logs" {
  value = {
    bucket = {
      id   = aws_s3_bucket.cloudtrail.id
      name = aws_s3_bucket.cloudtrail.bucket
      arn  = aws_s3_bucket.cloudtrail.arn
    }
    key = {
      key_id = aws_kms_key.cloudtrail.key_id
      alias  = aws_kms_alias.cloudtrail.name
      arn    = aws_kms_key.cloudtrail.arn
    }
  }
}