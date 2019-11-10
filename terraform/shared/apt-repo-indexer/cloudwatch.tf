resource "aws_cloudwatch_log_group" "s3apt" {
  name              = "/aws/lambda/${aws_lambda_function.s3apt.function_name}"
  retention_in_days = 14
}
