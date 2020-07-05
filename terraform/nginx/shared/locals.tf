locals {
  apt_repo_policy = data.terraform_remote_state.iam_common_policies.outputs.iam.apt_repo.policy

  vpc_id = data.terraform_remote_state.network.outputs.vpc.id

  bastion_security_group = data.terraform_remote_state.network.outputs.bastion_service.security_group

  function_name = "nginx-tls"
  
  nginx_image  = data.terraform_remote_state.ecr_nginx.outputs.ecr_repo
}
