resource "aws_s3_bucket" "kops_state" {
  bucket = "kops.${var.domain}"
  acl    = "private"
  versioning {
    enabled    = true
    mfa_delete = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        
        kms_master_key_id = aws_kms_key.kops_state.arn
      }
    }
  }
}

data "aws_iam_policy_document" "kops_state_s3" {
  statement {
    principals {
      type = "AWS"

      identifiers = local.org_account_roots
    }

    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.kops_state.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.kops_state.bucket}/*",
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
      "arn:aws:s3:::${aws_s3_bucket.kops_state.bucket}/*",
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

resource "aws_s3_bucket_policy" "kops_state" {
  bucket = aws_s3_bucket.kops_state.bucket
  policy = data.aws_iam_policy_document.kops_state_s3.json
}
