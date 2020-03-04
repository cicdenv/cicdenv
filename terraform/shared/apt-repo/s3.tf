resource "aws_s3_bucket" "apt_repo" {
  bucket = "apt-repo-${replace(var.domain, ".", "-")}"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "apt_repo" {
  bucket = aws_s3_bucket.apt_repo.id

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
        "s3:List*",
        "s3:Get*"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.apt_repo.id}",
        "arn:aws:s3:::${aws_s3_bucket.apt_repo.id}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:List*",
        "s3:Get*"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.apt_repo.id}",
        "arn:aws:s3:::${aws_s3_bucket.apt_repo.id}/*"
      ],
      "Condition": {
        "StringEquals": {
          "aws:sourceVpce": ${jsonencode(local.vpc_endpoints)}
        }
      }
    }
  ]
}
EOF
}
