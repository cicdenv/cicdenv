resource "aws_iam_role" "oidc_jwks" {
  name = local.oidc_jwks_function_name

  description = "Open ID Connect - IDP json web keys source (jwks) creator / renewer"

  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
}

data "aws_iam_policy_document" "oidc_jwks" {
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
      aws_secretsmanager_secret.oidc_jwks.arn,
    ]
  }

  statement {
    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.oidc.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.oidc.bucket}/*",
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.oidc.bucket}/*",
    ]
  }
}

resource "aws_iam_policy" "oidc_jwks" {
  name   = "OpenIDConnectIdpJWKSSecretLambda"
  path   = "/"
  policy = data.aws_iam_policy_document.oidc_jwks.json
}

resource "aws_iam_role_policy_attachment" "oidc_jwks" {
  role       = aws_iam_role.oidc_jwks.name
  policy_arn = aws_iam_policy.oidc_jwks.arn
}
