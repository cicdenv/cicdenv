resource "aws_iam_role" "gpg" {
  name = local.gpg_function_name

  description = "S3 Apt Repo - gpg key creator / renewer"

  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
}

data "aws_iam_policy_document" "gpg" {
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
      "s3:Put*",
    ]

    resources = [
      "${aws_s3_bucket.apt_repo.arn}/repo/dists/key.asc",
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
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
      "secretsmanager:PutSecretValue",
      "secretsmanager:UpdateSecretVersionStage",
    ]
    resources = [
      aws_secretsmanager_secret.gpg.arn,
    ]
  }
}

resource "aws_iam_policy" "gpg" {
  name   = "S3AptRepoGpgSecretLambda"
  path   = "/"
  policy = data.aws_iam_policy_document.gpg.json
}

resource "aws_iam_role_policy_attachment" "gpg" {
  role       = aws_iam_role.gpg.name
  policy_arn = aws_iam_policy.gpg.arn
}
