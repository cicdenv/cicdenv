resource "aws_cloudwatch_log_group" "kops_ca" {
  name = "/aws/lambda/${aws_lambda_function.kops_ca.function_name}"
  
  retention_in_days = 14
}
