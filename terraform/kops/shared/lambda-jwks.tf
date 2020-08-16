resource "aws_lambda_function" "oidc_jwks" {
  function_name = local.oidc_jwks_function_name
  role          = aws_iam_role.oidc_jwks.arn
  handler       = "lambda.lambda_handler"

  s3_bucket = local.lambda_bucket.id
  s3_key    = local.oidc_jwks_lambda_key

  # https://github.com/terraform-providers/terraform-provider-aws/issues/7385
  # source_code_hash = base64sha256(data.aws_s3_bucket_object.kops_ca_lambda.etag)
  s3_object_version = data.aws_s3_bucket_object.oidc_jwks_lambda.version_id

  runtime = "python3.8"
  timeout = 15

  environment {
    variables = {
      OIDC_BUCKET = aws_s3_bucket.oidc.id
    }
  }
  
  layers = [
    local.jwks_layer.arn,
  ]
}

resource "aws_lambda_permission" "secret_manager_call_oidc_jwks_Lambda" {
    function_name = aws_lambda_function.oidc_jwks.function_name
    statement_id  = "AllowExecutionSecretManager"
    action        = "lambda:InvokeFunction"
    principal     = "secretsmanager.amazonaws.com"
}
