locals {
  domain = var.domain

  account_hosted_zone = data.terraform_remote_state.domains.outputs.account_public_zone

  public_subnets  = data.terraform_remote_state.shared.outputs.public_subnet_ids
  private_subnets = data.terraform_remote_state.shared.outputs.private_subnet_ids

  apt_repo_policy_arn = data.terraform_remote_state.iam_common_policies.outputs.apt_repo_policy_arn

  ecr_jenkins_server_arn = data.terraform_remote_state.ecr_jenkins.outputs.jenkins_server_image_repo.arn
  ecr_jenkins_server_url = data.terraform_remote_state.ecr_jenkins.outputs.jenkins_server_image_repo.repository_url

  ecr_jenkins_agent_arn = data.terraform_remote_state.ecr_jenkins.outputs.jenkins_agent_image_repo.arn
  ecr_jenkins_agent_url = data.terraform_remote_state.ecr_jenkins.outputs.jenkins_agent_image_repo.repository_url

  jenkins_key            = data.terraform_remote_state.jenkins_backend.outputs.jenkins_key
  jenkins_env_secrets    = data.terraform_remote_state.jenkins_backend.outputs.jenkins_env_secrets
  jenkins_server_secrets = data.terraform_remote_state.jenkins_backend.outputs.jenkins_server_secrets

  vpc_id = data.terraform_remote_state.shared.outputs.vpc_id

  ssh_key = "~/.ssh/kops_rsa.pub"

  bastion_service_security_group_id = data.terraform_remote_state.shared.outputs.bastion_service_security_group_id
  kops_node_security_group_id       = data.terraform_remote_state.shared.outputs.nodes_security_group_id
}
