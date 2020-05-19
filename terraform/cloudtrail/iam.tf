data "aws_iam_policy_document" "cloudtrail_trust" {
  statement {
    effect  = "Allow"
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "cloudtrail_cloudwatch_logs" {
  statement {
    sid = "WriteCloudWatchLogs"

    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:cloudtrail-events:*",
      "arn:${data.aws_partition.current.partition}:logs:us-west-2:${data.aws_caller_identity.current.account_id}:log-group:cloudtrail-events:*",
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
