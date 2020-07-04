resource "aws_lambda_function" "nginx_tls" {
  function_name = local.function_name
  role          = aws_iam_role.nginx_tls.arn
  handler       = "lambda.lambda_handler"

  filename         = "tls-function/lambda.zip"
  source_code_hash = filebase64sha256("tls-function/lambda.zip")

  runtime = "python3.8"
  timeout = 15

  depends_on = [
    aws_iam_role_policy_attachment.nginx_tls, 
    aws_cloudwatch_log_group.nginx_tls,
  ]
}

resource "aws_lambda_permission" "secret_manager_call_Lambda" {
    function_name = aws_lambda_function.nginx_tls.function_name
    statement_id  = "AllowExecutionSecretManager"
    action        = "lambda:InvokeFunction"
    principal     = "secretsmanager.amazonaws.com"
}
