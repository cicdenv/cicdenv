data "aws_iam_policy_document" "iam_user_updates" {
  statement {
    sid = "owner"

    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        data.aws_caller_identity.current.account_id
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.iam_user_updates.arn
    ]
  }
  
  statement {
    sid = "aws"

    actions = [
      "sns:Publish"
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [
      aws_sns_topic.iam_user_updates.arn
    ]
  }

  statement {
    sid = "subacct"

    actions = [
      "SNS:Subscribe",
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = local.org_account_roots
    }

    resources = [
      aws_sns_topic.iam_user_updates.arn
    ]
  }
}

resource "aws_sns_topic_policy" "iam_user_updates" {
  arn =  aws_sns_topic.iam_user_updates.arn
  policy = data.aws_iam_policy_document.iam_user_updates.json
  
  provider = aws.us-east-1
}
