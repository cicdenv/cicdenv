resource "aws_cloudwatch_log_group" "nginx_tls" {
  name = "/aws/lambda/${local.function_name}"
  
  retention_in_days = 14
}
