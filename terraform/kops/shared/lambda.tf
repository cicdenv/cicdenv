resource "aws_lambda_function" "kops_ca" {
  function_name = local.kops_ca_function_name
  role          = aws_iam_role.kops_ca.arn
  handler       = "lambda.lambda_handler"

  s3_bucket = local.lambda_bucket.id
  s3_key    = local.kops_ca_lambda_key

  # https://github.com/terraform-providers/terraform-provider-aws/issues/7385
  # source_code_hash = base64sha256(data.aws_s3_bucket_object.kops_ca_lambda.etag)
  s3_object_version = data.aws_s3_bucket_object.kops_ca_lambda.version_id

  runtime = "python3.8"
  timeout = 15

  layers = [
    local.cfssl_layer.arn,
  ]
  
  depends_on = [
    aws_iam_role_policy_attachment.kops_ca, 
    aws_cloudwatch_log_group.kops_ca,
  ]
}

resource "aws_lambda_permission" "secret_manager_call_Lambda" {
    function_name = aws_lambda_function.kops_ca.function_name
    statement_id  = "AllowExecutionSecretManager"
    action        = "lambda:InvokeFunction"
    principal     = "secretsmanager.amazonaws.com"
}
