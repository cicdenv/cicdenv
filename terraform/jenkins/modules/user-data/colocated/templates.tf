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
    tag       = "latest"

    server_url = "jenkins-${var.jenkins_instance}.${local.account_hosted_zone.domain}"
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
    tag       = "latest"

    server_url    = "jenkins-${var.jenkins_instance}.${local.account_hosted_zone.domain}"
    tunneling_url = "jenkins-${var.jenkins_instance}-tcp.${local.account_hosted_zone.domain}"
  }
}
