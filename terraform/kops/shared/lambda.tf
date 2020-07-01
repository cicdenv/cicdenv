resource "aws_lambda_layer_version" "cfssl" {
  layer_name   = "cfssl"
  description  = "cfsslcfssl"
  license_info = "MIT"

  compatible_runtimes = ["python3.8"]

  filename         = "ca-function/layer.zip"
  source_code_hash = filebase64sha256("ca-function/layer.zip")
}

resource "aws_lambda_function" "kops_ca" {
  function_name = "kops-ca"
  role          = aws_iam_role.kops_ca.arn
  handler       = "lambda.lambda_handler"

  filename         = "ca-function/lambda.zip"
  source_code_hash = filebase64sha256("ca-function/lambda.zip")

  runtime = "python3.8"
  timeout = 15

  layers = [
    aws_lambda_layer_version.cfssl.arn,
  ]
}

resource "aws_lambda_permission" "secret_manager_call_Lambda" {
    function_name = aws_lambda_function.kops_ca.function_name
    statement_id  = "AllowExecutionSecretManager"
    action        = "lambda:InvokeFunction"
    principal     = "secretsmanager.amazonaws.com"
}
