data "aws_iam_policy_document" "cloudtrail_trust" {
  statement {
    principals {
      type = "Service"

      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

data "aws_iam_policy_document" "cloudtrail_cloudwatch_logs" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:${local.main_account.partition}:logs:us-east-1:${local.main_account.id}:log-group:cloudtrail-events:*",
      "arn:${local.main_account.partition}:logs:us-west-2:${local.main_account.id}:log-group:cloudtrail-events:*",
    ]
  }
}

resource "aws_iam_role" "cloudtrail_cloudwatch_logs" {
  name               = "cloudtrail-cloudwatch-logs"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_trust.json
}

resource "aws_iam_policy" "cloudtrail_cloudwatch_logs" {
  name   = "cloudtrail-cloudwatch-logs"
  policy = data.aws_iam_policy_document.cloudtrail_cloudwatch_logs.json
}

resource "aws_iam_role_policy_attachment" "cloudtrail_cloudwatch_logs" {
  role       = aws_iam_role.cloudtrail_cloudwatch_logs.name
  policy_arn = aws_iam_policy.cloudtrail_cloudwatch_logs.arn
}
