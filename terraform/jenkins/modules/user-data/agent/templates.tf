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
