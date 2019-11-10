resource "aws_iam_group" "admin" {
  name = "admin"
  path = "/users/"
}

resource "aws_iam_group_policy_attachment" "admin" {
  group      = aws_iam_group.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "admin_mfa" {
  group      = aws_iam_group.admin.name
  policy_arn = data.terraform_remote_state.iam_common.outputs.mfa_policy_arn
}

resource "aws_iam_group_membership" "admin" {
  name  = "admin-group-membership"
  group = aws_iam_group.admin.name

  users = aws_iam_user.admin.*.name
}
