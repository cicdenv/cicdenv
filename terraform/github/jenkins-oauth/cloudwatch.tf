resource "aws_cloudwatch_log_group" "github_oauth_callback" {
  name = "/aws/lambda/${aws_lambda_function.github_oauth_callback.function_name}"
  
  retention_in_days = 14
}
