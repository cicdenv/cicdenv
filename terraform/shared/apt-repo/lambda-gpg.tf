resource "aws_lambda_function" "gpg" {
  function_name = local.gpg_function_name
  role          = aws_iam_role.gpg.arn
  handler       = "lambda.lambda_handler"

  s3_bucket = local.lambda_bucket.id
  s3_key    = local.gpg_lambda_key

  # https://github.com/terraform-providers/terraform-provider-aws/issues/7385
  # source_code_hash = base64sha256(data.aws_s3_bucket_object.gpg_lambda.etag)
  s3_object_version = data.aws_s3_bucket_object.gpg_lambda.version_id

  runtime = "python3.8"
  timeout = 15

  layers = [
    local.gnupg2_layer.arn,
  ]

  environment {
    variables = {
      BUCKET     = aws_s3_bucket.apt_repo.id
      KEY_PREFIX = "repo/dists"
      EMAIL      = "fred.vogt+apt-repo-gpg@gmail.com"
    }
  }
}

resource "aws_lambda_permission" "secret_manager_call_gpg_Lambda" {
    function_name = aws_lambda_function.gpg.function_name
    statement_id  = "AllowExecutionSecretManager"
    action        = "lambda:InvokeFunction"
    principal     = "secretsmanager.amazonaws.com"
}
