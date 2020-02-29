resource "aws_iam_role" "global_github_oauth_callback" {
  name = "github-oauth-global-callback"

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

data "aws_iam_policy_document" "global_github_oauth_callback" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      aws_cloudwatch_log_group.global_github_oauth_callback.arn,
    ]
  }
}

resource "aws_iam_policy" "global_github_oauth_callback" {
  name   = "global-github-oauth-callback"
  path   = "/"
  policy = data.aws_iam_policy_document.global_github_oauth_callback.json
}

resource "aws_iam_role_policy_attachment" "global_github_oauth_callback" {
  role       = aws_iam_role.global_github_oauth_callback.name
  policy_arn = aws_iam_policy.global_github_oauth_callback.arn
}
