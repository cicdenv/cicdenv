resource "aws_lambda_function" "github_oauth_callback" {
  function_name = local.oauth_function_name
  role          = aws_iam_role.github_oauth_callback.arn
  handler       = "lambda.lambda_handler"

  s3_bucket = local.lambda_bucket.id
  s3_key    = local.oauth_lambda_key

  # https://github.com/terraform-providers/terraform-provider-aws/issues/7385
  # source_code_hash = base64sha256(data.aws_s3_bucket_object.lambda.etag)
  s3_object_version = data.aws_s3_bucket_object.lambda.version_id

  runtime = "python3.7"
}

#resource "aws_lambda_permission" "apigateway" {
#  statement_id  = "AllowExecutionFromAPIGateway"
#  action        = "lambda:InvokeFunction"
#  function_name = aws_lambda_function.github_oauth_callback.function_name
#  principal     = "apigateway.amazonaws.com"
#
#  source_arn = "${aws_api_gateway_rest_api.jenkins_github_oauth_callbacks.execution_arn}/*/GET/securityRealm/finishLogin/*/*"
#}
