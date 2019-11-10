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

resource "aws_s3_bucket_policy" "kops_state" {
  bucket = aws_s3_bucket.kops_state.bucket
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.kops_state.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.kops_state.bucket}/*"
      ],
      "Principal": {
        "AWS": ${jsonencode(local.org_account_roots)}
      }
    },
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": ${jsonencode(local.org_account_roots)}
      },
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.kops_state.bucket}/*"
      ],
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": [
            "bucket-owner-full-control"
          ]
        }
      }
    }
  ]
}
EOF
}
