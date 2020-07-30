resource "aws_s3_bucket" "lambda" {
  bucket = "lambda-${replace(var.domain, ".", "-")}"

  versioning {
    enabled    = true
    mfa_delete = false
  }
}

data "aws_iam_policy_document" "lambda" {
  statement {
    principals {
      type = "AWS"

      identifiers = local.org_account_roots
    }

    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.lambda.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.lambda.bucket}/*",
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
      "arn:aws:s3:::${aws_s3_bucket.lambda.bucket}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = [
        "bucket-owner-full-control",
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "lambda" {
  bucket = aws_s3_bucket.lambda.bucket
  policy = data.aws_iam_policy_document.lambda.json
}
