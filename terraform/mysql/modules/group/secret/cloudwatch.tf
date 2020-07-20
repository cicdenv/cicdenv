resource "aws_cloudwatch_log_group" "lambda" {
  name = "/aws/lambda/${local.function_name}"
  
  retention_in_days = 365
}
