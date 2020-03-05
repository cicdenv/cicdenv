output "jenkins_server_image_repo" {
  value = {
    id             = aws_ecr_repository.jenkins_server.id
    name           = aws_ecr_repository.jenkins_server.name
    arn            = aws_ecr_repository.jenkins_server.arn
    registry_id    = aws_ecr_repository.jenkins_server.registry_id
    repository_url = aws_ecr_repository.jenkins_server.repository_url
    latest         = "2.223-2020.03.01-01"
  }
}

output "jenkins_agent_image_repo" {
  value = {
    id             = aws_ecr_repository.jenkins_agent.id
    name           = aws_ecr_repository.jenkins_agent.name
    arn            = aws_ecr_repository.jenkins_agent.arn
    registry_id    = aws_ecr_repository.jenkins_agent.registry_id
    repository_url = aws_ecr_repository.jenkins_agent.repository_url
    latest         = "2.223-2020.03.01-01"
  }
}

output "ci_builds_image_repo" {
  value = {
    id             = aws_ecr_repository.ci_builds.id
    name           = aws_ecr_repository.ci_builds.name
    arn            = aws_ecr_repository.ci_builds.arn
    registry_id    = aws_ecr_repository.ci_builds.registry_id
    repository_url = aws_ecr_repository.ci_builds.repository_url
  }
}
