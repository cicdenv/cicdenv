data "aws_iam_policy_document" "kops_etcd" {
  statement {
    principals {
      type = "AWS"

      identifiers = [
        local.account["root"],
      ]
    }

    actions = [
      "kms:*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_kms_key" "kops_etcd" {
  description = "Used for for encrypting etcd EBS volumes"
  policy      = data.aws_iam_policy_document.kops_etcd.json
}

resource "aws_kms_alias" "kops_etcd" {
  name          = "alias/kops-etcd"
  target_key_id = aws_kms_key.kops_etcd.key_id
}
