resource "aws_iam_role" "bastion" {
  name = "bastion"
  
  assume_role_policy = data.aws_iam_policy_document.bastion_trust.json

  force_detach_policies = true
}

data "aws_iam_policy_document" "bastion_trust" {
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
  }
}

data "aws_iam_policy_document" "bastion" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      var.assume_role_arn,
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

resource "aws_iam_instance_profile" "bastion" {
  name = "bastion"
  role = aws_iam_role.bastion.name
}
