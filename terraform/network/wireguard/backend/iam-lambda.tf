resource "aws_iam_role" "wireguard_keys" {
  name = "wireguard-keys-secret-lambda"

  description = "wireguard keys creator / renewer"

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

data "aws_iam_policy_document" "wireguard_keys" {
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
      aws_secretsmanager_secret.wireguard_keys.arn,
    ]
  }
}

resource "aws_iam_policy" "wireguard_keys" {
  name   = "WireguardKeysSecretLambda"
  path   = "/"
  policy = data.aws_iam_policy_document.wireguard_keys.json
}

resource "aws_iam_role_policy_attachment" "wireguard_keys" {
  role       = aws_iam_role.wireguard_keys.name
  policy_arn = aws_iam_policy.wireguard_keys.arn
}
