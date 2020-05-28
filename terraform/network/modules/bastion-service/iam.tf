resource "aws_iam_role" "bastion" {
  name = "bastion"
  
  assume_role_policy = data.aws_iam_policy_document.bastion_trust.json

  force_detach_policies = true
}

data "aws_iam_policy_document" "bastion_trust" {
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

data "aws_iam_policy_document" "bastion" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      var.assume_role.arn,
    ]
  }

  statement {
    actions = [
      "ecr:GetAuthorizationToken",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
    ]

    resources = [
      local.ecr_bastion_sshd_worker.arn,
      local.ecr_bastion_events_worker.arn,
    ]
  }
}

resource "aws_iam_policy" "bastion" {
  name   = "BastionService"
  policy = data.aws_iam_policy_document.bastion.json
}

resource "aws_iam_role_policy_attachment" "bastion" {
  role       = aws_iam_role.bastion.name
  policy_arn = aws_iam_policy.bastion.arn
}

resource "aws_iam_role_policy_attachment" "apt_repo" {
  role       = aws_iam_role.bastion.name
  policy_arn = local.apt_repo_policy.arn
}

resource "aws_iam_instance_profile" "bastion" {
  name = "bastion"
  role = aws_iam_role.bastion.name
}
