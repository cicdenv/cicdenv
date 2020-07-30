data "aws_caller_identity" "current" {}

data "aws_route53_zone" "public_hosted_zone" {
  name = "${var.domain}."
}

data "aws_s3_bucket_object" "lambda" {
  bucket = local.lambda_bucket.id
  key    = local.oauth_lambda_key
}
