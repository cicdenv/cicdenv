locals {
  instance_profile = data.terraform_remote_state.jenkins_shared.outputs.colocated_instance_profile
}
