resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_policy" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": ${jsonencode(local.org_account_roots)}
      },
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ],
      "Resource": "arn:aws:s3:::${var.bucket}"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": ${jsonencode(local.org_account_roots)}
      },
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::${var.bucket}/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": ${jsonencode(local.org_account_roots)}
      },
      "Action": [
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::${var.bucket}/*"
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
