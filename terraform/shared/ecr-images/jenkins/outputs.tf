output "jenkins_server_image_repo" {
  value = {
    id             = aws_ecr_repository.jenkins_server.id
    name           = aws_ecr_repository.jenkins_server.name
    arn            = aws_ecr_repository.jenkins_server.arn
    registry_id    = aws_ecr_repository.jenkins_server.registry_id
    repository_url = aws_ecr_repository.jenkins_server.repository_url
    latest         = "2.222-2020.02.23-02"
  }
}

output "jenkins_agent_image_repo" {
  value = {
    id             = aws_ecr_repository.jenkins_agent.id
    name           = aws_ecr_repository.jenkins_agent.name
    arn            = aws_ecr_repository.jenkins_agent.arn
    registry_id    = aws_ecr_repository.jenkins_agent.registry_id
    repository_url = aws_ecr_repository.jenkins_agent.repository_url
    latest         = "2.222-2020.02.23-02"
  }
}
