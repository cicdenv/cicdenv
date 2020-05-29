locals {
  server_instance_profile = data.terraform_remote_state.jenkins_shared.outputs.iam.server.instance_profile
  server_security_groups  = [data.terraform_remote_state.jenkins_shared.outputs.security_groups["server"]] 
}
