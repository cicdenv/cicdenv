data "template_file" "jenkins_server_disks" {
  template = file("${path.module}/templates/jenkins-server-disks.sh.tpl")

  vars = {
    jenkins_instance = var.jenkins_instance
    efs_dns_name     = local.persistent_config_efs.dns_name
  }
}

data "template_file" "jenkins_server_service" {
  template = file("${path.module}/templates/jenkins-server.service.tpl")

  vars = {
    jenkins_instance = var.jenkins_instance

    host_name = local.host_name
    ecr_url   = local.jenkins_server_image.repository_url
    image     = local.jenkins_server_image.name
    tag       = local.jenkins_server_image.latest

    server_url  = local.server_url
    content_url = local.content_url

    github_secrets_arn = local.jenkins_github_secrets.arn
    
    github_oauth_redirect_uri = local.github_oauth_redirect_uri

    aws_region = var.region
    
    aws_main_account_id = local.main_account.id
  }
}
