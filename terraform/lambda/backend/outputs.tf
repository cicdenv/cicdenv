output "lambda" {
  value = {
    bucket = {
      id   = aws_s3_bucket.lambda.id
      name = aws_s3_bucket.lambda.bucket
      arn  = aws_s3_bucket.lambda.arn
    }
  }
}
