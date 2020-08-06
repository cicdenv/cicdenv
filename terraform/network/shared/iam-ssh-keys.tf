resource "aws_iam_role" "ssh_keys" {
  name = "shared-ec2-keypair-secret-generator"

  description = "shared ec2 ssh-key creator / renewer"

  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
}

data "aws_iam_policy_document" "ssh_keys" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      aws_cloudwatch_log_group.ssh_keys.arn,
    ]
  }

  statement {
    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
      "secretsmanager:PutSecretValue",
      "secretsmanager:UpdateSecretVersionStage",
    ]
    resources = [
      aws_secretsmanager_secret.ssh_keys.arn,
    ]
  }
}

resource "aws_iam_policy" "ssh_keys" {
  name   = "SharedEC2KeyPairSecretGenerator"
  path   = "/"
  policy = data.aws_iam_policy_document.ssh_keys.json
}

resource "aws_iam_role_policy_attachment" "ssh_keys" {
  role       = aws_iam_role.ssh_keys.name
  policy_arn = aws_iam_policy.ssh_keys.arn
}
