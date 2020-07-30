resource "aws_cloudwatch_log_group" "github_oauth_callback" {
  name = "/aws/lambda/${local.oauth_function_name}"
  
  retention_in_days = 14
}
