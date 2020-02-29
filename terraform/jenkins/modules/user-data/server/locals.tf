locals {
  site_hosted_zone    = data.terraform_remote_state.domains.outputs.main_public_zone
  account_hosted_zone = data.terraform_remote_state.domains.outputs.account_public_zone

  host_name = "jenkins-server-${var.jenkins_instance}-${terraform.workspace}"
  
  jenkins_server_image = data.terraform_remote_state.ecr_jenkins.outputs.jenkins_server_image_repo

  persistent_config_efs = data.terraform_remote_state.jenkins_shared.outputs.persistent_config_efs
  
  jenkins_env_secrets    = data.terraform_remote_state.jenkins_backend.outputs.jenkins_env_secrets
  jenkins_server_secrets = data.terraform_remote_state.jenkins_backend.outputs.jenkins_server_secrets
  jenkins_github_secrets = data.terraform_remote_state.jenkins_backend.outputs.jenkins_github_secrets

  server_url  = "https://jenkins-${var.jenkins_instance}.${local.account_hosted_zone.domain}"
  content_url = "https://builds-${var.jenkins_instance}.${local.account_hosted_zone.domain}"
  
  github_oauth_redirect_uri = "https://jenkins.${local.site_hosted_zone.domain}/securityRealm/finishLogin/${terraform.workspace}/${var.jenkins_instance}"
}
