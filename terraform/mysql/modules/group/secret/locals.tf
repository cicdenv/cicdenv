locals {
  function_name = "mysql-${var.name}-${var.suffix}"osted_zone

  lambda_bucket = data.terraform_remote_state.lambda.outputs.lambda.bucket
  lambda_key    = "functions/${var.lambda}.zip"
}
