data "aws_iam_policy_document" "jenkins_trust" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }

    principals {
      type = "AWS"

      identifiers = [
        local.main_account_root,
      ]
    }
  }
}

resource "aws_iam_policy" "jenkins_common" {
  name   = "JenkinsCommon"
  policy = data.aws_iam_policy_document.jenkins_common.json
}

data "aws_iam_policy_document" "jenkins_common" {
  # ecr login
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
    ]

    resources = [
      "*",
    ]
  }

  # secrets manager
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      local.jenkins_env_secrets.arn,
    ]
  }

  # kms
  statement {
    effect = "Allow"

    actions = [
      "kms:Decrypt",
    ]

    resources = [
      local.jenkins_key.arn,
    ]
  }
}
