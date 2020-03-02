resource "aws_ecr_repository" "jenkins_server" {
  name = "jenkins-server"
}

resource "aws_ecr_repository_policy" "jenkins_server" {
  repository = aws_ecr_repository.jenkins_server.name

  policy = local.multi_account_access_policy.json
}

resource "aws_ecr_repository" "jenkins_agent" {
  name = "jenkins-agent"
}

resource "aws_ecr_repository_policy" "jenkins_agent" {
  repository = aws_ecr_repository.jenkins_agent.name

  policy = local.multi_account_access_policy.json
}

resource "aws_ecr_repository" "ci_builds" {
  name = "ci-builds"
}

resource "aws_ecr_repository_policy" "ci_builds" {
  repository = aws_ecr_repository.ci_builds.name

  policy = local.multi_account_access_policy.json
}
