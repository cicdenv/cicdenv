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
  }
}

data "template_file" "jenkins_agent_service" {
  template = file("${path.module}/templates/jenkins-agent.service.tpl")

  vars = {
    jenkins_instance = var.jenkins_instance
    executors        = var.executors

    host_name = local.host_name
    ecr_url   = local.jenkins_agent_image.repository_url
    image     = local.jenkins_agent_image.name
    tag       = local.jenkins_agent_image.latest

    server_url = local.server_url
    
    agent_secrets_arn = local.jenkins_agent_secrets.arn
  }
}
