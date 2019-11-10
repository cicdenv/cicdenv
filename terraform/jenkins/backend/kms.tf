data "aws_iam_policy_document" "jenkins_kms" {
  statement {
    principals {
      type = "AWS"
      identifiers = local.all_account_roots
    }

    actions = ["kms:*"]

    resources = ["*"]
  }
}

resource "aws_kms_key" "jenkins" {
  description = "Used for encrypting jenkins secrets"
  policy = data.aws_iam_policy_document.jenkins_kms.json
}

resource "aws_kms_alias" "jenkins" {
  name          = "alias/jenkins"
  target_key_id = aws_kms_key.jenkins.key_id
}
