data "aws_iam_policy_document" "apt_repo" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    
    resources = [
      local.apt_repo_bucket.arn
    ]
  }

  statement {
    actions = [
      "s3:Get*",
    ]

    resources = [
      "${local.apt_repo_bucket.arn}",
      "${local.apt_repo_bucket.arn}/repo/dists/*",
    ]
  }
}

resource "aws_iam_policy" "apt_repo" {
  name   = "S3AptRepositoryReadOnly"
  policy = data.aws_iam_policy_document.apt_repo.json
}
