output "state_store" {
  value = {
    bucket = {
      id   = aws_s3_bucket.kops_state.id
      name = aws_s3_bucket.kops_state.bucket
      arn  = aws_s3_bucket.kops_state.arn
    }
    key = {
      key_id = aws_kms_key.kops_state.key_id
      alias  = aws_kms_alias.kops_state.name
      arn    = aws_kms_key.kops_state.arn
    }
  }
}
