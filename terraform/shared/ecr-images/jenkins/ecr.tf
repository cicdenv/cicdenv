resource "aws_ecr_repository" "jenkins_server" {
  name = "jenkins-server"
}

data "aws_iam_policy_document" "jenkins_server" {
  statement {
    principals {
      type = "AWS"
      identifiers = local.all_account_roots
    }

    actions = ["ecr:*"]
  }
}

resource "aws_ecr_repository_policy" "jenkins_server" {
  repository = aws_ecr_repository.jenkins_server.name

  policy = data.aws_iam_policy_document.jenkins_server.json
}

resource "aws_ecr_repository" "jenkins_agent" {
  name = "jenkins-agent"
}

data "aws_iam_policy_document" "jenkins_agent" {
  statement {
    principals {
      type = "AWS"
      identifiers = local.all_account_roots
    }

    actions = ["ecr:*"]
  }
}

resource "aws_ecr_repository_policy" "jenkins_agent" {
  repository = aws_ecr_repository.jenkins_agent.name

  policy = data.aws_iam_policy_document.jenkins_agent.json
}
