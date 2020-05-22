resource "aws_iam_policy" "mfa" {
  name        = "mfa-required"
  path        = "/users/"
  description = "Enable self-management of and require MFA"
  policy      = file("${path.module}/files/mfa-policy.json")
}
