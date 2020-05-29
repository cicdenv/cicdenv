locals {
  subnets = data.terraform_remote_state.network.outputs.subnets

  instance_profile = data.terraform_remote_state.jenkins_shared.outputs.iam.agent.instance_profile
  key_pair         = data.terraform_remote_state.jenkins_shared.outputs.jenkins_key_pair

  security_group = data.terraform_remote_state.jenkins_shared.outputs.security_groups.agent
}
