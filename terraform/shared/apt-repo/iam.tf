data "aws_iam_policy_document" "apt_repo" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    resources = [
      aws_s3_bucket.apt_repo.arn
    ]
  }

  statement {
    actions = [
      "s3:Get*",
    ]
    resources = [
      "${aws_s3_bucket.apt_repo.arn}",
      "${aws_s3_bucket.apt_repo.arn}/repo/dists/*",
    ]
  }
}

resource "aws_iam_policy" "apt_repo" {
  name   = "S3AptRepositoryReadOnly"
  policy = data.aws_iam_policy_document.apt_repo.json
}
