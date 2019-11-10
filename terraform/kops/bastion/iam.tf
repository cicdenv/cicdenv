data "aws_iam_policy_document" "kops_bastion" {
  # AmazonS3ReadOnlyAccess
  statement {
    effect = "Allow"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    resources = [
      "*",
    ]
  }

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

resource "aws_iam_policy" "kops_bastion" {
  name   = "KopsBastion"
  policy = data.aws_iam_policy_document.kops_bastion.json
}

resource "aws_iam_role_policy_attachment" "kops_bastion" {
  role       = module.bastion.role_name
  policy_arn = aws_iam_policy.kops_bastion.arn
}
