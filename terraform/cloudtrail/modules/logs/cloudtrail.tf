resource "aws_cloudtrail" "cloudtrail" {
  name = "cloudtrail"

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn  = var.cloud_watch_logs_role_arn

  s3_key_prefix  = "cloudtrail"
  s3_bucket_name = var.s3_bucket_name

  enable_log_file_validation = true

  kms_key_id = var.kms_key_id
}
