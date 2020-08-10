locals {
  vpc = data.terraform_remote_state.network_backend.outputs.vpc
  
  bastion_security_group = data.terraform_remote_state.bastion_backend.outputs.bastion_service.security_group
  
  apt_repo_policy = data.terraform_remote_state.iam_common_policies.outputs.iam.apt_repo.policy

  lambda_bucket = data.terraform_remote_state.lambda.outputs.lambda.bucket

  keys_function_name = "wireguard-keys-generator"
  keys_lambda_key    = "functions/${local.keys_function_name}.zip"
  
  wireguard-tools_layer = data.terraform_remote_state.wireguard-tools_layer.outputs.layer
}
