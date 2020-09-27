resource "aws_iam_role" "wireguard" {
  name = "wireguard"
  
  assume_role_policy = data.aws_iam_policy_document.wireguard_trust.json

  force_detach_policies = true
}

data "aws_iam_policy_document" "wireguard_trust" {
  statement {
    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

data "aws_iam_policy_document" "wireguard" {
  # secrets manager
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      aws_secretsmanager_secret.wireguard_keys.arn,
    ]
  }
}

resource "aws_iam_policy" "wireguard" {
  name   = "WireguardService"
  policy = data.aws_iam_policy_document.wireguard.json
}

resource "aws_iam_role_policy_attachment" "wireguard" {
  role       = aws_iam_role.wireguard.name
  policy_arn = aws_iam_policy.wireguard.arn
}

resource "aws_iam_role_policy_attachment" "apt_repo" {
  role       = aws_iam_role.wireguard.name
  policy_arn = local.apt_repo_policy.arn
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.wireguard.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "wireguard" {
  name = "wireguard"
  role = aws_iam_role.wireguard.name
}
