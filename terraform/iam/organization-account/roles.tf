resource "aws_iam_role" "assumed_admin" {
  name = "${terraform.workspace}-admin"
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.assumed_admin_assume_role_policy.json

  max_session_duration = 60 * 60 * 12 # 12 hours in seconds

  description = "Used when performing admin operations from IAM users in the main account."
}

data "aws_iam_policy_document" "assumed_admin_assume_role_policy" {
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
}

data "aws_iam_policy_document" "assumed_admin_inline_policy" {
  statement {
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "assumed_admin_inline_policy" {
  name = "AdministratorAccess"
  role = aws_iam_role.assumed_admin.id

  policy = data.aws_iam_policy_document.assumed_admin_inline_policy.json
}
