resource "aws_s3_bucket" "kops_builds" {
  bucket = "kops-builds-${replace(var.domain, ".", "-")}"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
  }
}

data "aws_iam_policy_document" "kops_builds_s3" {
  statement {
    principals {
      type = "AWS"

      identifiers = local.org_account_roots
    }

    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.kops_builds.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.kops_builds.bucket}/*",
    ]
  }

  statement {
    principals {
      type = "AWS"

      identifiers = local.org_account_roots
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.kops_builds.bucket}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = [
        "bucket-owner-full-control",
      ]
    }
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
      "arn:aws:s3:::${aws_s3_bucket.kops_builds.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.kops_builds.bucket}/kops/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:sourceVpce"
      values   = local.vpc_endpoints
    }
  }

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
      "arn:aws:s3:::${aws_s3_bucket.kops_builds.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.kops_builds.bucket}/kops/*",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = var.allowed_cidr_blocks
    }
  }
}

resource "aws_s3_bucket_policy" "kops_builds" {
  bucket = aws_s3_bucket.kops_builds.bucket
  policy = data.aws_iam_policy_document.kops_builds_s3.json
}
