resource "aws_iam_role" "terraform_admin" {
  name = "terraform-admin"
  path = "/users/"

  assume_role_policy = data.aws_iam_policy_document.terraform_admin_assume_role_policy.json

  max_session_duration = 60 * 60 * 12 # 12 hours in seconds

  description = "Used when performing admin operations from IAM users in the main account."
}

data "aws_iam_policy_document" "terraform_admin_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = aws_iam_user.admin.*.arn
    }
  }
}

resource "aws_iam_role_policy_attachment" "terraform_admin" {
  role       = aws_iam_role.terraform_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
