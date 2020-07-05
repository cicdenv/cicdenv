resource "aws_lambda_function" "ssh_keys" {
  function_name = local.ssh_keys_function_name
  role          = aws_iam_role.ssh_keys.arn
  handler       = "lambda.lambda_handler"

  filename         = "ssh-keys/lambda.zip"
  source_code_hash = filebase64sha256("ssh-keys/lambda.zip")

  runtime = "python3.8"
  timeout = 30

  depends_on = [
    aws_iam_role_policy_attachment.ssh_keys, 
    aws_cloudwatch_log_group.ssh_keys,
  ]
}

resource "aws_lambda_permission" "ssh_keys" {
    function_name = aws_lambda_function.ssh_keys.function_name
    statement_id  = "AllowExecutionSecretManager"
    action        = "lambda:InvokeFunction"
    principal     = "secretsmanager.amazonaws.com"
}
