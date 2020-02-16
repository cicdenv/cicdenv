locals {
  private_subnets = data.terraform_remote_state.shared.outputs.private_subnet_ids

  ami_owner = data.terraform_remote_state.iam_organizations.outputs.master_account["id"]
  ami       = data.aws_ami.custom_base.id

  instance_profile = data.terraform_remote_state.jenkins_shared.outputs.agent_instance_profile
  key_pair         = data.terraform_remote_state.jenkins_shared.outputs.jenkins_key_pair

  security_group = data.terraform_remote_state.jenkins_shared.outputs.agent_security_group
}
