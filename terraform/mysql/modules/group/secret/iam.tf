resource "aws_iam_role" "lambda" {
  name = "${local.function_name}-secret-lambda"

  description = "MySQL (${var.name}) ${var.suffix} creator / renewer"

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

data "aws_iam_policy_document" "lambda" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      aws_cloudwatch_log_group.lambda.arn,
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
      aws_secretsmanager_secret.this.arn,
    ]
  }
}

resource "aws_iam_policy" "lambda" {
  name   = "MySQL${var.name}${title(var.suffix)}SecretLambda"
  path   = "/"
  policy = data.aws_iam_policy_document.lambda.json
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}
