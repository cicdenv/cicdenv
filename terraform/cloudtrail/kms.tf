# https://docs.aws.amazon.com/awscloudtrail/latest/userguide/default-cmk-policy.html
data "aws_iam_policy_document" "cloudtrail_kms" {
  statement {
    sid = "Enable IAM User Permissions"

    effect = "Allow"

    actions = [
      "kms:*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }

    resources = ["*"]
  }

  statement {
    sid = "Allow CloudTrail to encrypt logs"

    effect = "Allow"

    actions = [
      "kms:GenerateDataKey*",
    ]

    principals {
      type = "Service"

      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = [
        "arn:${data.aws_partition.current.partition}:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*",
      ]
    }

    resources = ["*"]
  }

  statement {
    sid = "Allow CloudTrail to describe key"
    
    effect = "Allow"
    
    actions = [
      "kms:DescribeKey",
    ]

    principals {
      type = "Service"

      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
    }

    resources = ["*"]
  }

  statement {
    sid = "Allow principals in the account to decrypt log files"

    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [
        data.aws_caller_identity.current.account_id,
      ]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = [
        "arn:${data.aws_partition.current.partition}:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*",
      ]
    }

    resources = ["*"]
  }

  statement {
    sid = "Allow alias creation during setup"

    effect = "Allow"
    
    actions = [
      "kms:CreateAlias",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["ec2.${data.aws_region.current.name}.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    resources = ["*"]
  }

  statement {
    sid = "Enable cross account log decryption"

    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom",
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [
        data.aws_caller_identity.current.account_id,
      ]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = [
        "arn:${data.aws_partition.current.partition}:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*",
      ]
    }

    resources = ["*"]
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
