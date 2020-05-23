resource "aws_iam_role" "packer_build" {
  name = "packer-build"
  
  assume_role_policy = data.aws_iam_policy_document.packer_trust.json

  force_detach_policies = true
}

data "aws_iam_policy_document" "packer_trust" {
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

data "aws_iam_policy_document" "packer_build" {
  # AmazonEC2ContainerRegistryReadOnly
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "packer_build" {
  name   = "PackerBuild"
  policy = data.aws_iam_policy_document.packer_build.json
}

resource "aws_iam_role_policy_attachment" "packer_build" {
  role       = aws_iam_role.packer_build.name
  policy_arn = aws_iam_policy.packer_build.arn
}

resource "aws_iam_role_policy_attachment" "apt_repo" {
  role       = aws_iam_role.packer_build.name
  policy_arn = local.apt_repo_policy.arn
}

resource "aws_iam_instance_profile" "packer_build" {
  name = "packer-build"
  role = aws_iam_role.packer_build.name
}
