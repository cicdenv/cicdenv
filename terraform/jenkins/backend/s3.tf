resource "aws_s3_bucket" "jenkins" {
  bucket = "jenkins-${replace(var.domain, ".", "-")}"
  acl    = "private"

  versioning {
    enabled    = true
    mfa_delete = false
  }
}

data "aws_iam_policy_document" "jenkins_s3" {
  statement {
    principals {
      type = "AWS"
      identifiers = local.all_account_roots
    }

    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.jenkins.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.jenkins.bucket}/*"
    ]
  }

  statement {
    principals {
      type = "AWS"
      identifiers = local.all_account_roots
    }

    actions = ["s3:PutObject"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.jenkins.bucket}/*"
    ]

    condition {
      test = "StringEquals"
      variable = "s3:x-amz-acl"
      values = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "jenkins_s3" {
  bucket = aws_s3_bucket.jenkins.bucket
  policy = data.aws_iam_policy_document.jenkins_s3.json
}
