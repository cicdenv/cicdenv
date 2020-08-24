resource "aws_cloudwatch_log_group" "gpg" {
  name = "/aws/lambda/${local.gpg_function_name}"

  retention_in_days = 14
}
