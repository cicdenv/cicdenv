resource "aws_iam_user" "admin" {
  count = length(local.admin_users)

  name = local.admin_users[count.index]
  path = "/users/"
  
  force_destroy = true
}

resource "aws_iam_user_login_profile" "admin" {
  count = length(aws_iam_user.admin.*.name)

  user                    = local.admin_users[count.index]
  pgp_key                 = "keybase:${lookup(local.admin_pgp_keys, local.admin_users[count.index])}"
  password_length         = "20"
  password_reset_required = "true"
}

resource "aws_iam_access_key" "admin" {
  count = length(aws_iam_user.admin.*.name)

  user    = local.admin_users[count.index]
  pgp_key = "keybase:${lookup(local.admin_pgp_keys, local.admin_users[count.index])}"
}

resource "aws_iam_user_ssh_key" "admin" {
  count = length(aws_iam_user.admin.*.name)

  username   = local.admin_users[count.index]
  encoding   = "SSH"
  public_key = lookup(local.admin_ssh_keys, local.admin_users[count.index])
}
