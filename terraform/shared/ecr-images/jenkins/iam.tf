data "aws_iam_policy_document" "multi_account_access" {
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
