resource "aws_iam_role" "test" {
  name = "test"
  
  assume_role_policy = data.aws_iam_policy_document.test_trust.json
}

data "aws_iam_policy_document" "test_trust" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "test" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = local.assume_role_arns
  }

  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    resources = [
      local.apt_repo_bucket_arn
    ]
  }

  statement {
    actions = [
      "s3:Get*",
    ]
    resources = [
      "${local.apt_repo_bucket_arn}",
      "${local.apt_repo_bucket_arn}/repo/dists/*",
    ]
  }
}

resource "aws_iam_policy" "test" {
  name   = "ManualTesting"
  policy = data.aws_iam_policy_document.test.json
}

resource "aws_iam_role_policy_attachment" "test" {
  role       = aws_iam_role.test.name
  policy_arn = aws_iam_policy.test.arn
}

resource "aws_iam_instance_profile" "test" {
  name = "test"
  role = aws_iam_role.test.name
}
