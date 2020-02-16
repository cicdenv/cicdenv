locals {
  instance_profile = data.terraform_remote_state.jenkins_shared.outputs.server_instance_profile
}
