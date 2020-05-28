data "aws_iam_policy_document" "terraform_state_key" {
  statement {
    principals {
      type = "AWS"

      identifiers = local.all_account_roots
    }

    actions = [
      "kms:*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_kms_key" "terraform" {
  description = "Used for terraform state"
  policy      = data.aws_iam_policy_document.terraform_state_key.json
}
