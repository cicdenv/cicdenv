resource "aws_iam_role" "mysql_group" {
  name = "mysql-${var.name}"
  
  assume_role_policy = data.aws_iam_policy_document.mysql_group_trust.json

  force_detach_policies = true
}

data "aws_iam_policy_document" "mysql_group_trust" {
  statement {
    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_policy" "mysql_group" {
  name   = "MySQL${var.name}"
  policy = data.aws_iam_policy_document.mysql_group.json
}

data "aws_iam_policy_document" "mysql_group" {
  # secrets manager - server TLS key
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      module.tls_keys.secret.arn,
      module.credentials.secret.arn,
    ]
  }

  # create EBS snapshots (1)
  statement {
    actions = [
      "ec2:CreateSnapshot",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
    ]

    resources = [
      "*",
    ]
  }

  # create EBS snapshots (2)
  statement {
    actions = [
      "ec2:CreateTags",
      "ec2:ModifySnapshotAttribute",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values   = [
        "CreateSnapshot",
      ]
    }
  }

  # dumps (1)
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:GetEncryptionConfiguration",
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${local.mysql_backups.bucket.name}",
    ]
  }

  # dumps (2)
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectTagging",
    ]

    resources = [
      "arn:aws:s3:::${local.mysql_backups.bucket.name}/dumps/${var.name}/",
    ]
  }

  # dumps (2)
  statement {
    actions = [
      "kms:DescribeKey",
      "kms:Encrypt",
    ]

    resources = [
      local.mysql_backups.key.arn,
    ]
  }
}

resource "aws_iam_role_policy_attachment" "mysql_group_apt_repo" {
  role       = aws_iam_role.mysql_group.name
  policy_arn = local.apt_repo_policy.arn
}

resource "aws_iam_role_policy_attachment" "mysql_group" {
  role       = aws_iam_role.mysql_group.name
  policy_arn = aws_iam_policy.mysql_group.arn
}

resource "aws_iam_instance_profile" "mysql_group" {
  name = "mysql-${var.name}"
  role = aws_iam_role.mysql_group.name
}
