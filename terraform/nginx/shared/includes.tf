data "aws_s3_bucket_object" "lambda" {
  bucket = local.lambda_bucket.id
  key    = local.tls_lambda_key
}
