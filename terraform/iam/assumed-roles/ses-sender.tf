resource "aws_iam_role" "ses_sender" {
  name = "ses-sender"
  
  assume_role_policy = data.aws_iam_policy_document.ses_sender_trust.json
}

data "aws_iam_policy_document" "ses_sender_trust" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "AWS"

      identifiers = local.all_account_roots
    }
  }
}

data "aws_iam_policy_document" "send_email" {
  statement {
    effect = "Allow"

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
