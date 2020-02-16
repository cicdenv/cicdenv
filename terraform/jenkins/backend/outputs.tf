output "jenkins_key" {
  value = {
    id = aws_kms_key.jenkins.key_id
    arn = aws_kms_key.jenkins.arn
    alias = aws_kms_alias.jenkins.name
  }
}

output "jenkins_env_secrets" {
  value = {
    name = aws_secretsmanager_secret.jenkins_env.name
    arn  = aws_secretsmanager_secret.jenkins_env.arn
  }
}

output "jenkins_server_secrets" {
  value = {
    name = aws_secretsmanager_secret.jenkins_server.name
    arn  = aws_secretsmanager_secret.jenkins_server.arn
  }
}
