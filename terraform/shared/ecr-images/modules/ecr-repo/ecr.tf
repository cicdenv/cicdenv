resource "aws_ecr_repository" "repo" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"
}

data "aws_iam_policy_document" "repo" {
  statement {
    principals {
      type = "AWS"
      
      identifiers = local.all_account_roots
    }

    # arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
    actions = local.subaccount_permissions
  }
}

resource "aws_ecr_repository_policy" "repo" {
  repository = aws_ecr_repository.repo.name
  policy     = data.aws_iam_policy_document.repo.json
}
