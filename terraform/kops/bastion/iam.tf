resource "aws_iam_role" "iam_user_event_subscriber" {
  name = "iam-user-event-subscriber"

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

data "aws_iam_policy_document" "iam_user_event_subscriber" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      aws_cloudwatch_log_group.iam_user_event_subscriber.arn,
    ]
  }

  statement {
    actions = [
      # For dropping ENIs in our VPC - AWSLambdaVPCAccessExecutionRole
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      # For looking up bastion hosts
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "ec2:DescribeInstances",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "iam_user_event_subscriber" {
  name   = "iam-user-event-subscriber"
  path   = "/"
  policy = data.aws_iam_policy_document.iam_user_event_subscriber.json
}

resource "aws_iam_role_policy_attachment" "iam_user_event_subscriber" {
  role       = aws_iam_role.iam_user_event_subscriber.name
  policy_arn = aws_iam_policy.iam_user_event_subscriber.arn
}
