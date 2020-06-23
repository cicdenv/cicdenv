output "ecr" {
  value = {
    jenkins_server = {
      id             = module.ecr_jenkins_server.id
      name           = module.ecr_jenkins_server.name
      arn            = module.ecr_jenkins_server.arn
      registry_id    = module.ecr_jenkins_server.registry_id
      repository_url = module.ecr_jenkins_server.repository_url
      latest         = var.jenkins_server_default_tag
    }
    jenkins_agent = {
      id             = module.ecr_jenkins_agent.id
      name           = module.ecr_jenkins_agent.name
      arn            = module.ecr_jenkins_agent.arn
      registry_id    = module.ecr_jenkins_agent.registry_id
      repository_url = module.ecr_jenkins_agent.repository_url
      latest         = var.jenkins_agent_default_tag
    }
    ci_builds = {
      id             = module.ecr_ci_builds.id
      name           = module.ecr_ci_builds.name
      arn            = module.ecr_ci_builds.arn
      registry_id    = module.ecr_ci_builds.registry_id
      repository_url = module.ecr_ci_builds.repository_url
    }
  }
}
