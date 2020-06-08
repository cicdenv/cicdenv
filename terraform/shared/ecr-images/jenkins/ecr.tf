resource "aws_ecr_repository" "jenkins_server" {
  name = "jenkins-server"
}

resource "aws_ecr_repository_policy" "jenkins_server" {
  repository = aws_ecr_repository.jenkins_server.name

  policy = data.aws_iam_policy_document.multi_account_read_access.json
}

resource "aws_ecr_repository" "jenkins_agent" {
  name = "jenkins-agent"
}

resource "aws_ecr_repository_policy" "jenkins_agent" {
  repository = aws_ecr_repository.jenkins_agent.name

  policy = data.aws_iam_policy_document.multi_account_read_access.json
}

resource "aws_ecr_repository" "ci_builds" {
  name = "ci-builds"
}

resource "aws_ecr_repository_policy" "ci_builds" {
  repository = aws_ecr_repository.ci_builds.name

  policy = data.aws_iam_policy_document.multi_account_readwrite_access.json
}
