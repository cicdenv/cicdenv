resource "aws_lambda_function" "rotator" {
  function_name = local.function_name
  role          = aws_iam_role.lambda.arn
  handler       = "lambda.lambda_handler"

  filename         = var.filename
  source_code_hash = filebase64sha256(var.filename)

  runtime = "python3.8"
  timeout = 15

  depends_on = [
    aws_iam_role_policy_attachment.lambda, 
    aws_cloudwatch_log_group.lambda,
  ]
}

resource "aws_lambda_permission" "secret_manager_call_Lambda" {
    function_name = aws_lambda_function.rotator.function_name
    statement_id  = "AllowExecutionSecretManager"
    action        = "lambda:InvokeFunction"
    principal     = "secretsmanager.amazonaws.com"
}
