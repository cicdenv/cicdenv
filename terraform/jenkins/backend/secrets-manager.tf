resource "aws_secretsmanager_secret" "jenkins_env" {
  name = "jenkins-env"

  description = "Jenkins CI host secrets"

  policy = data.aws_iam_policy_document.jenkins_secret.json

  kms_key_id = aws_kms_key.jenkins.id
}

resource "aws_secretsmanager_secret" "jenkins_server" {
  name = "jenkins-server"

  description = "Jenkins CI server secrets"

  policy = data.aws_iam_policy_document.jenkins_secret.json

  kms_key_id = aws_kms_key.jenkins.id
}
