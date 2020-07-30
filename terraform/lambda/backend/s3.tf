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

      identifiers = [
        "*",
      ]
    }

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.lambda.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.lambda.bucket}/*",
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

resource "aws_s3_bucket_policy" "lambda" {
  bucket = aws_s3_bucket.lambda.bucket
  policy = data.aws_iam_policy_document.lambda.json
}
