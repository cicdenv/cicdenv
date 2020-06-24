locals {
  domain = var.domain

  account_hosted_zone = data.terraform_remote_state.domains.outputs.account_public_zone

  subnets = data.terraform_remote_state.network.outputs.subnets
  
  apt_repo_policy = data.terraform_remote_state.iam_common_policies.outputs.iam.apt_repo.policy

  ecr_jenkins_server = data.terraform_remote_state.ecr_jenkins.outputs.ecr.jenkins_server
  ecr_jenkins_agent  = data.terraform_remote_state.ecr_jenkins.outputs.ecr.jenkins_agent
  ecr_ci_builds      = data.terraform_remote_state.ecr_jenkins.outputs.ecr.ci_builds

  jenkins_key            = data.terraform_remote_state.jenkins_backend.outputs.jenkins_key
  jenkins_env_secrets    = data.terraform_remote_state.jenkins_backend.outputs.secrets.env
  jenkins_agent_secrets  = data.terraform_remote_state.jenkins_backend.outputs.secrets.agent
  jenkins_server_secrets = data.terraform_remote_state.jenkins_backend.outputs.secrets.server

  jenkins_github_secrets           = data.terraform_remote_state.jenkins_backend.outputs.secrets.github.ec2
  jenkins_github_localhost_secrets = data.terraform_remote_state.jenkins_backend.outputs.secrets.github.localhost

  vpc_id = data.terraform_remote_state.network.outputs.vpc.id

  ssh_key = "~/.ssh/kops_rsa.pub"

  bastion_security_group = data.terraform_remote_state.network.outputs.bastion_service.security_group

  main_account = data.terraform_remote_state.accounts.outputs.main_account
  this_account = {
    id = data.aws_caller_identity.current.account_id
  }
}
