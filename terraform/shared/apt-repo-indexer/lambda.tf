resource "aws_lambda_function" "s3apt" {
  s3_bucket     = local.apt_repo_bucket.id
  s3_key        = "s3apt.zip"
  function_name = "s3apt"
  description   = "Automatic s3 apt repo indexer."
  role          = aws_iam_role.s3apt.arn
  handler       = "s3apt.lambda_handler"
  memory_size   = 128
  runtime       = "python3.7"
  publish       = true
  timeout       = 900

  source_code_hash = filebase64sha256("s3apt/s3apt.zip")

  environment {
    variables = {
      bucket       = local.apt_repo_bucket.id
      cache_prefix = "repo/control-data-cache"
    }
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3apt.arn
  principal     = "s3.amazonaws.com"
  source_arn    = local.apt_repo_bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = local.apt_repo_bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3apt.arn
    
    events = [
      "s3:ObjectCreated:*",
      "s3:ObjectRemoved:*",
    ]

    filter_prefix = "repo/dists/"
    filter_suffix = ".deb"
  }
}
