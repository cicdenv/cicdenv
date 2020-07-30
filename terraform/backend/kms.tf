data "aws_iam_policy_document" "terraform_state_key" {
  statement {
    principals {
      type = "AWS"

      identifiers = [
        local.main_account.root,
      ]
    }

    actions = [
      "kms:*",
    ]

    resources = [
      "*",
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
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:Generate*",
      "kms:Describe*",
      "kms:Get*",
      "kms:List*",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [
        aws_organizations_organization.organization.id,
      ]
    }
  }
}

resource "aws_kms_key" "terraform" {
  description = "Used for terraform state"
  policy      = data.aws_iam_policy_document.terraform_state_key.json
}
