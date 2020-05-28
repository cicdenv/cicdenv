resource "aws_s3_bucket" "apt_repo" {
  bucket = "apt-repo-${replace(var.domain, ".", "-")}"
  acl    = "private"

  versioning {
    enabled = true
  }
}

data "aws_iam_policy_document" "apt_repo" {
  statement {
    principals {
      type = "AWS"

      identifiers = local.org_account_roots
    }

    actions = [
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.apt_repo.id}",
      "arn:aws:s3:::${aws_s3_bucket.apt_repo.id}/*",
    ]
  }

  statement {
    principals {
      type = "AWS"

      identifiers = local.org_account_roots
    }

    actions = [
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.apt_repo.id}",
      "arn:aws:s3:::${aws_s3_bucket.apt_repo.id}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:sourceVpce"
      values   = local.vpc_endpoints
    }
  }
}

resource "aws_s3_bucket_policy" "apt_repo" {
  bucket = aws_s3_bucket.apt_repo.id

  policy = data.aws_iam_policy_document.apt_repo.json
}
