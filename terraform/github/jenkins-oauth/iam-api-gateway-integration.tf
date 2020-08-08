resource "aws_iam_role" "aws_api_gateway_integration" {
  name = "${local.oauth_function_name}-api-gateway-integration"

  assume_role_policy = data.aws_iam_policy_document.apigateway_trust.json
}

data "aws_iam_policy_document" "apigateway_trust" {
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

data "aws_iam_policy_document" "aws_api_gateway_integration" {
  statement {
    actions = [
      "lambda:InvokeFunction",
    ]

    resources = [
      aws_lambda_function.github_oauth_callback.arn,
    ]
  }
}

resource "aws_iam_policy" "aws_api_gateway_integration" {
  name   = "${local.oauth_function_name}-api-gateway-integration"
  path   = "/"
  policy = data.aws_iam_policy_document.aws_api_gateway_integration.json
}

resource "aws_iam_role_policy_attachment" "aws_api_gateway_integration" {
  role       = aws_iam_role.aws_api_gateway_integration.name
  policy_arn = aws_iam_policy.aws_api_gateway_integration.arn
}
