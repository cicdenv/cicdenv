data "aws_iam_policy_document" "iam_user_updates" {
  statement {
    sid = "owner"

    principals {
      type = "AWS"

      identifiers = [
        local.main_account.root,
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
      
      identifiers = [
        "*",
      ]
    }

    actions = [
      "SNS:Subscribe",
    ]

    resources = [
      aws_sns_topic.iam_user_updates.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [
        local.organization.id,
      ]
    }
  }
}

resource "aws_sns_topic_policy" "iam_user_updates" {
  arn =  aws_sns_topic.iam_user_updates.arn
  policy = data.aws_iam_policy_document.iam_user_updates.json
  
  provider = aws.us-east-1
}
