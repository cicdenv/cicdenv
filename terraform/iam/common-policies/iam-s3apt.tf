resource "aws_iam_role" "apt_repo" {
  name = "apt-repo-access"
  
  assume_role_policy = data.aws_iam_policy_document.apt_repo_trust.json
}

data "aws_iam_policy_document" "apt_repo_trust" {
  statement {
    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [
        local.organization.id,
      ]
    }
  }
}

data "aws_iam_policy_document" "apt_repo" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    
    resources = [
      local.apt_repo_bucket.arn
    ]
  }

  statement {
    actions = [
      "s3:Get*",
    ]

    resources = [
      "${local.apt_repo_bucket.arn}",
      "${local.apt_repo_bucket.arn}/repo/dists/*",
    ]
  }
}

resource "aws_iam_policy" "apt_repo" {
  name   = "S3AptRepositoryReadOnly"
  policy = data.aws_iam_policy_document.apt_repo.json
}

resource "aws_iam_role_policy_attachment" "apt_repo" {
  role       = aws_iam_role.apt_repo.name
  policy_arn = aws_iam_policy.apt_repo.arn
}
