resource "aws_cloudwatch_log_group" "kops_ca" {
  name = "/aws/lambda/${local.kops_ca_function_name}"
  
  retention_in_days = 14
}
