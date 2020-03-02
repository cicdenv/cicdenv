data "aws_iam_policy_document" "multi_account_access" {
  statement {
    principals {
      type = "AWS"
      identifiers = local.all_account_roots
    }

    actions = ["ecr:*"]
  }
}
