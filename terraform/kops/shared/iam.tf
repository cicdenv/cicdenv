resource "aws_iam_role" "kops_ca" {
  name = local.kops_ca_function_name

  description = "KOPS - CA creator / renewer"

  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
}

data "aws_iam_policy_document" "lambda_trust" {
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

data "aws_iam_policy_document" "kops_ca" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      aws_cloudwatch_log_group.kops_ca.arn,
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
      aws_secretsmanager_secret.kops_ca.arn,
    ]
  }
}

resource "aws_iam_policy" "kops_ca" {
  name   = "KopsCaSecretLambda"
  path   = "/"
  policy = data.aws_iam_policy_document.kops_ca.json
}

resource "aws_iam_role_policy_attachment" "kops_ca" {
  role       = aws_iam_role.kops_ca.name
  policy_arn = aws_iam_policy.kops_ca.arn
}
