locals {
  domain = var.domain

  account_hosted_zone = data.terraform_remote_state.domains.outputs.account_public_zone

  subnets = data.terraform_remote_state.network.outputs.subnets
  
  apt_repo_policy = data.terraform_remote_state.iam_common_policies.outputs.apt_repo_policy

  ecr_jenkins_server = data.terraform_remote_state.ecr_jenkins.outputs.jenkins_server_image_repo
  ecr_jenkins_agent  = data.terraform_remote_state.ecr_jenkins.outputs.jenkins_agent_image_repo
  ecr_ci_builds      = data.terraform_remote_state.ecr_jenkins.outputs.ci_builds_image_repo

  jenkins_key            = data.terraform_remote_state.jenkins_backend.outputs.jenkins_key
  jenkins_env_secrets    = data.terraform_remote_state.jenkins_backend.outputs.jenkins_env_secrets
  jenkins_agent_secrets  = data.terraform_remote_state.jenkins_backend.outputs.jenkins_agent_secrets
  jenkins_server_secrets = data.terraform_remote_state.jenkins_backend.outputs.jenkins_server_secrets

  jenkins_github_secrets           = data.terraform_remote_state.jenkins_backend.outputs.jenkins_github_secrets
  jenkins_github_localhost_secrets = data.terraform_remote_state.jenkins_backend.outputs.jenkins_github_localhost_secrets

  vpc_id = data.terraform_remote_state.network.outputs.vpc.id

  ssh_key = "~/.ssh/kops_rsa.pub"

  bastion_security_group = data.terraform_remote_state.network.outputs.bastion_service.security_group

  main_account = data.terraform_remote_state.accounts.outputs.main_account
}
