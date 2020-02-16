locals {
  account_hosted_zone = data.terraform_remote_state.domains.outputs.account_public_zone

  host_name = "jenkins-server-${var.jenkins_instance}-${terraform.workspace}"
  
  jenkins_server_image = data.terraform_remote_state.ecr_jenkins.outputs.jenkins_server_image_repo
  jenkins_agent_image  = data.terraform_remote_state.ecr_jenkins.outputs.jenkins_agent_image_repo

  persistent_config_efs = data.terraform_remote_state.jenkins_shared.outputs.persistent_config_efs
  
  jenkins_env_secrets    = data.terraform_remote_state.jenkins_backend.outputs.jenkins_env_secrets
  jenkins_server_secrets = data.terraform_remote_state.jenkins_backend.outputs.jenkins_server_secrets
}
