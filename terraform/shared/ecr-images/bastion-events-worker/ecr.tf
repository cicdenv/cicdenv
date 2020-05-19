resource "aws_ecr_repository" "bastion_events_worker" {
  name                 = "bastion-events-worker"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository_policy" "bastion_events_worker" {
  repository = aws_ecr_repository.bastion_events_worker.name

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
