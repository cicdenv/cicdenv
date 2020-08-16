resource "aws_cloudwatch_log_group" "oidc_jwks" {
  name = "/aws/lambda/${local.oidc_jwks_function_name}"
  
  retention_in_days = 14
}
