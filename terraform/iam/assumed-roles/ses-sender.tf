resource "aws_iam_role" "ses_sender" {
  name = "ses-sender"
  
  assume_role_policy = data.aws_iam_policy_document.ses_sender_trust.json
}

data "aws_iam_policy_document" "ses_sender_trust" {
  statement {
    principals {
      type = "AWS"

      identifiers = [
        local.main_account.root,
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
  
  statement {
    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }

    actions = [
      "sts:AssumeRole",
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

data "aws_iam_policy_document" "send_email" {
  statement {
    actions = [
      "SES:SendEmail",
      "SES:SendRawEmail",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "send_email" {
  name   = "SendSESEmails"
  policy = data.aws_iam_policy_document.send_email.json
}

resource "aws_iam_role_policy_attachment" "send_email" {
  role       = aws_iam_role.ses_sender.name
  policy_arn = aws_iam_policy.send_email.arn
}
