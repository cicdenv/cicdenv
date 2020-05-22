resource "aws_iam_user" "admin" {
  for_each = var.admins

  name = each.key
  path = "/users/"
  
  force_destroy = true
}

resource "aws_iam_user_login_profile" "admin" {
  for_each = var.admins

  user                    = each.key
  password_length         = "20"
  password_reset_required = "true"
  pgp_key                 = "keybase:${each.value.pgp_key}"
}

resource "aws_iam_access_key" "admin" {
  for_each = var.admins

  user    = each.key
  pgp_key = "keybase:${each.value.pgp_key}"
}

resource "aws_iam_user_ssh_key" "admin" {
  for_each = var.admins

  username   = each.key
  encoding   = "SSH"
  public_key = each.value.ssh_key
}
