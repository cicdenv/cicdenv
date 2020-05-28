resource "aws_s3_bucket" "jenkins_builds" {
  bucket = "jenkins-builds-${terraform.workspace}-${replace(var.domain, ".", "-")}"
  acl    = "private"

  versioning {
    enabled    = true
    mfa_delete = false
  }
}

data "aws_iam_policy_document" "jenkins_builds" {
  # Administrators
  statement {
    principals {
      type = "AWS"

      identifiers = [
        local.main_account.root
      ]
    }

    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.jenkins_builds.arn,
    ]
  }

  # AWSLogs from ALBs
  statement {
    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::797873946194:root", # us-west-2
      ]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.jenkins_builds.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "jenkins_builds" {
  bucket = aws_s3_bucket.jenkins_builds.id
  policy = data.aws_iam_policy_document.jenkins_builds.json
}
