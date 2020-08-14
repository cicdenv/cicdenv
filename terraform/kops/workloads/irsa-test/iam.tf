resource "aws_iam_role" "irsa_test" {
  name = local.service_account["name"]

  description = "KOPS - IAM Roles for Kubernetes Service Accounts test role"

  assume_role_policy = data.aws_iam_policy_document.openidc_trust.json
}

data "aws_iam_policy_document" "openidc_trust" {
  statement {
    principals {
      type = "Federated"

      identifiers = [
        local.openidc_provider.arn,
      ]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    condition {
      test     = "StringEquals"
      variable = "${local.openidc_provider.url}:sub"
      values   = [
        "system:serviceaccount:default:${local.service_account["name"]}",
      ]
    }
  }
}

data "aws_iam_policy_document" "irsa_test" {
  statement {
    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    resources = [
      local.builds_bucket.arn,
      "${local.builds_bucket.arn}/*",
    ]
  }
}

resource "aws_iam_policy" "irsa_test" {
  name   = "KopsIRSATest"
  path   = "/"
  policy = data.aws_iam_policy_document.irsa_test.json
}

resource "aws_iam_role_policy_attachment" "irsa_test" {
  role       = aws_iam_role.irsa_test.name
  policy_arn = aws_iam_policy.irsa_test.arn
}