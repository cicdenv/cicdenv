resource "aws_ecr_repository" "bastion_sshd_worker" {
  name                 = "bastion-sshd-worker"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository_policy" "bastion_sshd_worker" {
  repository = aws_ecr_repository.bastion_sshd_worker.name

  # arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage",
        "ecr:GetLifecyclePolicy",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:ListTagsForResource",
        "ecr:DescribeImageScanFindings"
      ],
      "Principal": {
        "AWS": ${jsonencode(local.org_account_roots)}
      }
    }
  ]
}
EOF
}
