resource "aws_iam_role" "kops_node" {
  name               = "kops-node"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource aws_iam_policy kops_node {
  name = "KopsNode"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeRegions"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:BatchGetImage"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "kops_node" {
  role       = aws_iam_role.kops_node.name
  policy_arn = aws_iam_policy.kops_node.arn
}

resource "aws_iam_instance_profile" "kops_node" {
  name = "kops-node"
  role = aws_iam_role.kops_node.name
}
