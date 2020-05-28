output "jenkins_key" {
  value = {
    key_id = aws_kms_key.jenkins.key_id
    alias  = aws_kms_alias.jenkins.name
    arn    = aws_kms_key.jenkins.arn
  }
}

output "secrets" {
  value = {
    env = {
      name = aws_secretsmanager_secret.jenkins_env.name
      arn  = aws_secretsmanager_secret.jenkins_env.arn
    }
    agent = {
      name = aws_secretsmanager_secret.jenkins_agent.name
      arn  = aws_secretsmanager_secret.jenkins_agent.arn
    }
    server = {
      name = aws_secretsmanager_secret.jenkins_server.name
      arn  = aws_secretsmanager_secret.jenkins_server.arn
    }
    github = {
      ec2 = {
        name = aws_secretsmanager_secret.jenkins_github.name
        arn  = aws_secretsmanager_secret.jenkins_github.arn
      }
      localhost = {
        name = aws_secretsmanager_secret.jenkins_github_localhost.name
        arn  = aws_secretsmanager_secret.jenkins_github_localhost.arn
      }
    }
  }
}
