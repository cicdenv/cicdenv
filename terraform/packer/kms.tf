data "aws_iam_policy_document" "ebs" {
  statement {
    principals {
      type = "AWS"

      identifiers = local.allowed_account_roots
    }

    actions = [
      "kms:*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_kms_key" "ebs" {
  description = "Used for ebs root volumes"
  policy      = data.aws_iam_policy_document.ebs.json
}

resource "aws_kms_alias" "ebs" {
  name          = "alias/ebs"
  target_key_id = aws_kms_key.ebs.key_id
}
