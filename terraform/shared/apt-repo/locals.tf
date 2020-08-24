locals {
  organization = data.terraform_remote_state.accounts.outputs.organization

  main_account = data.terraform_remote_state.accounts.outputs.main_account
  
  lambda_bucket = data.terraform_remote_state.lambda.outputs.lambda.bucket
  
  indexer_function_name = "s3apt-indexer"
  indexer_lambda_key    = "${local.indexer_function_name}.zip"

  gpg_function_name = "s3apt-gpg"
  gpg_lambda_key    = "functions/${local.gpg_function_name}.zip"

  gnupg2_layer = data.terraform_remote_state.gnupg2_layer.outputs.layer
}
