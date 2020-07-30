resource "aws_ecr_repository" "repo" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"
}

data "aws_iam_policy_document" "repo" {
  statement {
    principals {
      type = "AWS"
      
      identifiers = [
        local.main_account.root,
      ]
    }

    actions = [
      "ecr:*",
    ]
  }

  statement {
    principals {
      type = "AWS"
      
      identifiers = [
        "*",
      ]
    }

    actions = local.subaccount_permissions

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [
        local.organization.id,
      ]
    }
  }
}

resource "aws_ecr_repository_policy" "repo" {
  repository = aws_ecr_repository.repo.name
  policy     = data.aws_iam_policy_document.repo.json
}
