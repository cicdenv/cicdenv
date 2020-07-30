data "aws_s3_bucket_object" "layer" {
  bucket = local.lambda_bucket.id
  key    = local.layer_key
}
