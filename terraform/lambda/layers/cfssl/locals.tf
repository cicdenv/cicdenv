locals {
  lambda_bucket = data.terraform_remote_state.lambda.outputs.lambda.bucket

  layer_name = "cfssl"
  layer_key  = "layers/${local.layer_name}.zip"
}
