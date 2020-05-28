resource "aws_ecr_repository" "bastion_events_worker" {
  name                 = "bastion-events-worker"
  image_tag_mutability = "MUTABLE"
}

data "aws_iam_policy_document" "bastion_events_worker" {
  statement {
    principals {
      type = "AWS"
      identifiers = local.all_account_roots
    }

    # arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
    actions = [
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
      "ecr:DescribeImageScanFindings",
    ]
  }
}

resource "aws_ecr_repository_policy" "bastion_events_worker" {
  repository = aws_ecr_repository.bastion_events_worker.name
  policy     = data.aws_iam_policy_document.bastion_events_worker.json
}
