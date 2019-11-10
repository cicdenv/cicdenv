output "state_store" {
  value = aws_s3_bucket.kops_state.bucket
}

output "kops_state_bucket_arn" {
  value = aws_s3_bucket.kops_state.arn
}

output "kops_state_key_arn" {
  value = aws_kms_key.kops_state.arn
}
