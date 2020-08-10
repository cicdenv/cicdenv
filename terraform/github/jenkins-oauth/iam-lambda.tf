resource "aws_iam_role" "github_oauth_callback" {
  name = local.oauth_function_name

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

data "aws_iam_policy_document" "github_oauth_callback" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "github_oauth_callback" {
  name   = local.oauth_function_name
  path   = "/"
  policy = data.aws_iam_policy_document.github_oauth_callback.json
}

resource "aws_iam_role_policy_attachment" "github_oauth_callback" {
  role       = aws_iam_role.github_oauth_callback.name
  policy_arn = aws_iam_policy.github_oauth_callback.arn
}

resource "aws_iam_role" "api_gateway_cloudwatch" {
  name = "api-gateway-cloudwatch"

  assume_role_policy = data.aws_iam_policy_document.cloudwatch_trust.json
}
