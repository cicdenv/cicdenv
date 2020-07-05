resource "aws_cloudwatch_log_group" "ssh_keys" {
  name              = "/aws/lambda/${local.ssh_keys_function_name}"
  retention_in_days = 14
}
