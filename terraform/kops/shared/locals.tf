locals {
  vpc = data.terraform_remote_state.network_shared.outputs.vpc
  
  bastion = data.terraform_remote_state.bastion_backend.outputs.bastion_service

  account = terraform.workspace == "main" ? data.terraform_remote_state.accounts.outputs.main_account : data.terraform_remote_state.accounts.outputs.organization_accounts[terraform.workspace]

  lambda_bucket = data.terraform_remote_state.lambda.outputs.lambda.bucket

  kops_ca_function_name = "kops-ca-generator"
  kops_ca_lambda_key    = "functions/${local.kops_ca_function_name}.zip"

  cfssl_layer = data.terraform_remote_state.cfssl_layer.outputs.layer
}
