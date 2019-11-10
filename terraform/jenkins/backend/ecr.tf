resource "aws_ecr_repository" "jenkins" {
  count = length(var.ecr_repos)

  name = var.ecr_repos[count.index]
}

data "aws_iam_policy_document" "jenkins" {
  statement {
    principals {
      type = "AWS"
      identifiers = local.all_account_roots
    }

    actions = ["ecr:*"]
  }
}

resource "aws_ecr_repository_policy" "jenkins" {
  count = length(var.ecr_repos)

  repository = aws_ecr_repository.jenkins[count.index].name

  policy = data.aws_iam_policy_document.jenkins.json
}
