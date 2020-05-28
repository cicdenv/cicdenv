resource "aws_iam_role" "identity_resolver" {
  name = "identity-resolver"
  
  assume_role_policy = data.aws_iam_policy_document.identity_resolver_trust.json
}

data "aws_iam_policy_document" "identity_resolver_trust" {
  statement {
    principals {
      type = "AWS"

      identifiers = local.all_account_roots
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

data "aws_iam_policy_document" "iam_ssh_authorized_keys" {
  statement {
    actions = [
      "iam:ListUsers",
      "iam:GetGroup",
      "iam:GetSSHPublicKey",
      "iam:ListSSHPublicKeys",
      "iam:GetUser",
      "iam:ListGroups",
      "ec2:DescribeTags",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "iam_ssh_authorized_keys" {
  name   = "GetIamSSHAuthorizedKeys"
  policy = data.aws_iam_policy_document.iam_ssh_authorized_keys.json
}

resource "aws_iam_role_policy_attachment" "iam_ssh_authorized_keys" {
  role       = aws_iam_role.identity_resolver.name
  policy_arn = aws_iam_policy.iam_ssh_authorized_keys.arn
}
