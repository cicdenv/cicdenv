resource "aws_iam_role" "kops_node" {
  name               = "kops-node"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

data "aws_iam_policy_document" "kops_node" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:BatchGetImage",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "kops_node" {
  name   = "KopsNode"
  policy = data.aws_iam_policy_document.kops_node.json
}

resource "aws_iam_role_policy_attachment" "kops_node" {
  role       = aws_iam_role.kops_node.name
  policy_arn = aws_iam_policy.kops_node.arn
}

resource "aws_iam_role_policy_attachment" "kops_node_apt_repo" {
  role       = aws_iam_role.kops_node.name
  policy_arn = local.apt_repo_policy.arn
}

resource "aws_iam_instance_profile" "kops_node" {
  name = "kops-node"
  role = aws_iam_role.kops_node.name
}
