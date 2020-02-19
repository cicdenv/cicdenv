data "template_file" "jenkins_agent_service" {
  template = file("${path.module}/templates/jenkins-agent.service.tpl")

  vars = {
    jenkins_instance = var.jenkins_instance
    executors        = var.executors

    host_name = local.host_name
    ecr_url   = local.jenkins_agent_image.repository_url
    image     = local.jenkins_agent_image.name
    tag       = "latest"

    server_url    = "jenkins-${var.jenkins_instance}.${local.account_hosted_zone.domain}"

    agent_secrets_arn = local.jenkisn_agent_secrets.arn
  }
}
