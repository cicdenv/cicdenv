data "aws_s3_bucket_object" "kops_ca_lambda" {
  bucket = local.lambda_bucket.id
  key    = local.kops_ca_lambda_key
}
