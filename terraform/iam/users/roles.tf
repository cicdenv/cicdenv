resource "aws_iam_role" "main_admin" {
  name = "main-admin"
  path = "/users/"

  assume_role_policy = data.aws_iam_policy_document.main_admin_assume_role_policy.json

  max_session_duration = 60 * 60 * 12 # 12 hours in seconds

  description = "Used when performing admin operations from IAM users in the main account."
}

data "aws_iam_policy_document" "main_admin_assume_role_policy" {
  statement {
    principals {
      type = "AWS"
      
      identifiers = [for iam_user in aws_iam_user.admin : iam_user.arn]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_role_policy_attachment" "main_admin" {
  role       = aws_iam_role.main_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
