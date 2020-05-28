data "aws_iam_policy_document" "iam_user_updates" {
  statement {
    sid = "owner"

    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }

    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive",
    ]

    resources = [
      aws_sns_topic.iam_user_updates.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        data.aws_caller_identity.current.account_id
      ]
    }
  }
  
  statement {
    sid = "aws"

    principals {
      type = "Service"

      identifiers = [
        "events.amazonaws.com",
      ]
    }

    actions = [
      "sns:Publish"
    ]

    resources = [
      aws_sns_topic.iam_user_updates.arn
    ]
  }

  statement {
    sid = "subacct"

    principals {
      type = "AWS"
      
      identifiers = local.all_account_roots
    }

    actions = [
      "SNS:Subscribe",
    ]

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
