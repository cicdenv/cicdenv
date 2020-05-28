# https://docs.aws.amazon.com/awscloudtrail/latest/userguide/default-cmk-policy.html
data "aws_iam_policy_document" "cloudtrail_kms" {
  statement {
    sid = "Enable IAM User Permissions"

    principals {
      type = "AWS"

      identifiers = [
        "arn:${local.main_account.partition}:iam::${local.main_account.id}:root",
      ]
    }

    actions = [
      "kms:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "Allow CloudTrail to encrypt logs"

    principals {
      type = "Service"

      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
    }

    actions = [
      "kms:GenerateDataKey*",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = [
        "arn:${local.main_account.partition}:cloudtrail:*:${local.main_account.id}:trail/*",
      ]
    }
  }

  statement {
    sid = "Allow CloudTrail to describe key"

    principals {
      type = "Service"

      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
    }

    actions = [
      "kms:DescribeKey",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "Allow principals in the account to decrypt log files"

    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }

    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [
        local.main_account.id,
      ]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = [
        "arn:${local.main_account.partition}:cloudtrail:*:${local.main_account.id}:trail/*",
      ]
    }
  }

  statement {
    sid = "Allow alias creation during setup"

    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }
    
    actions = [
      "kms:CreateAlias",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = [
        "ec2.${data.aws_region.current.name}.amazonaws.com",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [
        local.main_account.id,
      ]
    }
  }

  statement {
    sid = "Enable cross account log decryption"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [
        local.main_account.id,
      ]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = [
        "arn:${local.main_account.partition}:cloudtrail:*:${local.main_account.id}:trail/*",
      ]
    }
  }
}

resource "aws_kms_key" "cloudtrail" {
  description             = "A KMS key used to encrypt CloudTrail log files stored in S3."
  deletion_window_in_days = 7
  enable_key_rotation     = "true"
  policy                  = data.aws_iam_policy_document.cloudtrail_kms.json
}

resource "aws_kms_alias" "cloudtrail" {
  name          = "alias/cloudtrail"
  target_key_id = aws_kms_key.cloudtrail.key_id
}
