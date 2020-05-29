locals {
  instance_profile = data.terraform_remote_state.jenkins_shared.outputs.iam.server.instance_profile
  security_groups  = [for role in ["server", "agent"] : data.terraform_remote_state.jenkins_shared.outputs.security_groups[role]] 
}
