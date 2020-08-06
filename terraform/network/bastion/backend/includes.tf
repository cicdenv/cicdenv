data "aws_s3_bucket_object" "event_subscriber_lambda" {
  bucket = local.lambda_bucket.id
  key    = local.event_subscriber_lambda_key
}
