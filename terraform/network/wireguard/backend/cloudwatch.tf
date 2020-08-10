resource "aws_cloudwatch_log_group" "wireguard_keys" {
  name = "/aws/lambda/${local.keys_function_name}"
  
  retention_in_days = 14
}
