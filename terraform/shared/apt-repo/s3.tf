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
      type = "*"

      identifiers = ["*"]
    }

    actions = [
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.apt_repo.id}",
      "arn:aws:s3:::${aws_s3_bucket.apt_repo.id}/repo/dists/*",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = var.allowed_cidr_blocks
    }
  }

  statement {
    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
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
      variable = "aws:PrincipalOrgID"
      values   = [
        local.organization.id,
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "apt_repo" {
  bucket = aws_s3_bucket.apt_repo.id

  policy = data.aws_iam_policy_document.apt_repo.json
}
