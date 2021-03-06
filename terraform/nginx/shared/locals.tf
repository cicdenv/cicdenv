locals {
  apt_repo_policy = data.terraform_remote_state.iam_common_policies.outputs.iam.apt_repo.policy

  vpc = data.terraform_remote_state.network_shared.outputs.vpc

  bastion_security_group = data.terraform_remote_state.bastion_backend.outputs.bastion_service.security_group
  
  nginx_image  = data.terraform_remote_state.ecr_nginx.outputs.ecr_repo

  lambda_bucket = data.terraform_remote_state.lambda.outputs.lambda.bucket

  tls_function_name = "nginx-tls-generator"
  tls_lambda_key    = "functions/${local.tls_function_name}.zip"
}
