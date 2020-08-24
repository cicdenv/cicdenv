resource "aws_iam_role" "indexer" {
  name = "s3apt-indexer"

  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json

  force_detach_policies = true
}

data "aws_iam_policy_document" "indexer" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    resources = [
      aws_s3_bucket.apt_repo.arn,
    ]
  }

  statement {
    actions = [
      "s3:Get*",
      "s3:Put*",
    ]

    resources = [
      "${aws_s3_bucket.apt_repo.arn}",
      "${aws_s3_bucket.apt_repo.arn}/repo/control-data-cache/*",
      "${aws_s3_bucket.apt_repo.arn}/repo/dists/*",
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      aws_secretsmanager_secret.gpg.arn,
    ]
  }
}

resource "aws_iam_policy" "indexer" {
  name   = "S3AptIndexer"
  path   = "/"
  policy = data.aws_iam_policy_document.indexer.json
}

resource "aws_iam_role_policy_attachment" "indexer" {
  role       = aws_iam_role.indexer.name
  policy_arn = aws_iam_policy.indexer.arn
}
