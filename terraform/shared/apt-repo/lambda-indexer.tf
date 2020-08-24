resource "aws_lambda_function" "indexer" {
  function_name = local.indexer_function_name
  role          = aws_iam_role.indexer.arn
  handler       = "lambda.lambda_handler"

  s3_bucket = aws_s3_bucket.apt_repo.id
  s3_key    = local.indexer_lambda_key

  # https://github.com/terraform-providers/terraform-provider-aws/issues/7385
  # source_code_hash = base64sha256(data.aws_s3_bucket_object.kops_ca_lambda.etag)
  s3_object_version = data.aws_s3_bucket_object.indexer_lambda.version_id

  runtime = "python3.8"
  timeout = 900

  description = "Automatic s3 apt repo indexer."

  environment {
    variables = {
      BUCKET       = aws_s3_bucket.apt_repo.id
      CACHE_PREFIX = "repo/control-data-cache"
      SECRET_ID    = aws_secretsmanager_secret.gpg.name
    }
  }
  
  layers = [
    local.gnupg2_layer.arn,
  ]
}

resource "aws_lambda_permission" "indexer" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.indexer.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.apt_repo.arn
}

resource "aws_s3_bucket_notification" "indexer" {
  bucket = aws_s3_bucket.apt_repo.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.indexer.arn
    
    events = [
      "s3:ObjectCreated:*",
    ]

    filter_prefix = "repo/dists/"
    filter_suffix = ".deb"
  }

  lambda_function {
    lambda_function_arn = aws_lambda_function.indexer.arn
    
    events = [
      "s3:ObjectCreated:*",
    ]

    filter_prefix = "repo/dists/"
    filter_suffix = "key.asc"
  }

  lambda_function {
    lambda_function_arn = aws_lambda_function.indexer.arn
    
    events = [
      "s3:ObjectRemoved:*",
    ]

    filter_prefix = "repo/dists/"
  }
}
