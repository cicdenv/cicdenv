resource "aws_iam_role" "nginx_tls" {
  name = "nginx-tls-secret-lambda"

  description = "NGINX tls creator / renewer"

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

data "aws_iam_policy_document" "nginx_tls" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      aws_cloudwatch_log_group.nginx_tls.arn,
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
      aws_secretsmanager_secret.nginx_tls.arn,
    ]
  }
}

resource "aws_iam_policy" "nginx_tls" {
  name   = "NginxTlsSecretLambda"
  path   = "/"
  policy = data.aws_iam_policy_document.nginx_tls.json
}

resource "aws_iam_role_policy_attachment" "nginx_tls" {
  role       = aws_iam_role.nginx_tls.name
  policy_arn = aws_iam_policy.nginx_tls.arn
}
