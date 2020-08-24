data "aws_s3_bucket_object" "indexer_lambda" {
  bucket = aws_s3_bucket.apt_repo.id
  key    = local.indexer_lambda_key
}

data "aws_s3_bucket_object" "gpg_lambda" {
  bucket = local.lambda_bucket.id
  key    = local.gpg_lambda_key
}
