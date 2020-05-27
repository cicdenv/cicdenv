resource "aws_lambda_function" "github_oauth_callback" {
  filename      = "github-oauth-callback/lambda.zip"
  function_name = "jenkins-github-oauth-AWS_PROXY"
  role          = aws_iam_role.github_oauth_callback.arn
  handler       = "lambda.lambda_handler"
  runtime       = "python3.7"

  source_code_hash = filebase64sha256("github-oauth-callback/lambda.zip")
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.github_oauth_callback.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${local.account_id}:${aws_api_gateway_rest_api.jenkins_github_oauth_callbacks.id}/*/*"
}
