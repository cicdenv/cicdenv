data "aws_iam_policy_document" "s3apt_trust" {
  statement {
    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_role" "s3apt" {
  name = "s3apt"

  assume_role_policy = data.aws_iam_policy_document.s3apt_trust.json

  force_detach_policies = true
}

data "aws_iam_policy_document" "s3apt" {
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
      "s3:Put*",
    ]

    resources = [
      "${local.apt_repo_bucket.arn}",
      "${local.apt_repo_bucket.arn}/repo/control-data-cache/*",
      "${local.apt_repo_bucket.arn}/repo/dists/*",
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      aws_cloudwatch_log_group.s3apt.arn,
    ]
  }

  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      aws_secretsmanager_secret.apt_repo_indexer.arn,
    ]
  }
}

resource "aws_iam_policy" "s3apt" {
  name   = "s3apt"
  path   = "/"
  policy = data.aws_iam_policy_document.s3apt.json
}

resource "aws_iam_role_policy_attachment" "s3apt" {
  role       = aws_iam_role.s3apt.name
  policy_arn = aws_iam_policy.s3apt.arn
}
