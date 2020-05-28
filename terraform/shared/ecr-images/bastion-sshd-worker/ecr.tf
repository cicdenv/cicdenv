resource "aws_ecr_repository" "bastion_sshd_worker" {
  name                 = "bastion-sshd-worker"
  image_tag_mutability = "MUTABLE"
}

data "aws_iam_policy_document" "bastion_sshd_worker" {
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

resource "aws_ecr_repository_policy" "bastion_sshd_worker" {
  repository = aws_ecr_repository.bastion_sshd_worker.name
  policy     = data.aws_iam_policy_document.bastion_sshd_worker.json
}
