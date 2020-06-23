locals {
  all_account_roots = data.terraform_remote_state.accounts.outputs.all_roots

  # arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
  ecr_read_actions = [
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

  ecr_write_actions = [
    "ecr:InitiateLayerUpload",
    "ecr:UploadLayerPart",
    "ecr:CompleteLayerUpload",
    "ecr:PutImage",
  ]

  # arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser
  ecr_readwrite_actions = flatten([local.ecr_read_actions, local.ecr_write_actions])

  ecr_permissions = {
    r  = local.ecr_read_actions
    rw = local.ecr_readwrite_actions
  }

  subaccount_permissions = local.ecr_permissions[var.subaccount_permissions]
}
