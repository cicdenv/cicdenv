resource "aws_iam_role" "github_oauth_callback" {
  name = "jenkins-github-oauth-callback"

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
      aws_cloudwatch_log_group.github_oauth_callback.arn,
    ]
  }
}

resource "aws_iam_policy" "github_oauth_callback" {
  name   = "jenkins-github-oauth-callback"
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

data "aws_iam_policy_document" "cloudwatch_trust" {
  statement {
    principals {
      type = "Service"

      identifiers = [
        "apigateway.amazonaws.com",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_role_policy" "cloudwatch" {
  name = "ApiGatewayCloudwatch"
  role = aws_iam_role.api_gateway_cloudwatch.id

  policy = data.aws_iam_policy_document.cloudwatch.json
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]

    resources = [
      "*",
    ]
  }
}
