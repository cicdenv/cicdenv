data "local_file" "mfa_policy" {
    filename = "${path.module}/files/mfa-policy.json"
}

resource "aws_iam_policy" "mfa" {
  name        = "mfa-required"
  path        = "/users/"
  description = "Enable self-management of and require MFA"
  policy      = data.local_file.mfa_policy.content
}
