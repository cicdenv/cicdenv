resource "aws_secretsmanager_secret" "jenkins_env" {
  name = "jenkins-env"

  description = "Jenkins CI host secrets"

  policy = data.aws_iam_policy_document.jenkins_secret.json

  kms_key_id = aws_kms_key.jenkins.id
}

resource "aws_secretsmanager_secret" "jenkins_agent" {
  name = "jenkins-agent"

  description = "Jenkins CI agent secrets"

  policy = data.aws_iam_policy_document.jenkins_secret.json

  kms_key_id = aws_kms_key.jenkins.id
}

resource "aws_secretsmanager_secret" "jenkins_server" {
  name = "jenkins-server"

  description = "Jenkins CI server identity"

  policy = data.aws_iam_policy_document.jenkins_secret.json

  kms_key_id = aws_kms_key.jenkins.id
}

resource "aws_secretsmanager_secret" "jenkins_github" {
  name = "jenkins-github"

  description = "Jenkins CI Github access"

  policy = data.aws_iam_policy_document.jenkins_secret.json

  kms_key_id = aws_kms_key.jenkins.id
}

resource "aws_secretsmanager_secret" "jenkins_github_localhost" {
  name = "jenkins-github-localhost"

  description = "Jenkins CI localhost Github access"

  policy = data.aws_iam_policy_document.jenkins_secret.json

  kms_key_id = aws_kms_key.jenkins.id
}
