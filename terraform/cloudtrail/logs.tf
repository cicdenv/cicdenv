module "logs_us-west-2" {
  source = "./modules/logs"

  cloud_watch_logs_role_arn = aws_iam_role.cloudtrail_cloudwatch_logs.arn

  s3_bucket_name = aws_s3_bucket.cloudtrail.id

  kms_key_id = aws_kms_key.cloudtrail.arn
}

module "logs_us-east-1" {
  source = "./modules/logs"

  cloud_watch_logs_role_arn = aws_iam_role.cloudtrail_cloudwatch_logs.arn
  
  s3_bucket_name = aws_s3_bucket.cloudtrail.id

  kms_key_id = aws_kms_key.cloudtrail.arn

  providers = {
    aws = aws.us-east-1
  }
}
