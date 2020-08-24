resource "aws_cloudwatch_log_group" "indexer" {
  name = "/aws/lambda/${local.indexer_function_name}"

  retention_in_days = 14
}
