resource "aws_cloudwatch_log_group" "global_github_oauth_callback" {
  name              = "/aws/lambda/${aws_lambda_function.global_github_oauth_callback.function_name}"
  retention_in_days = 14
}
