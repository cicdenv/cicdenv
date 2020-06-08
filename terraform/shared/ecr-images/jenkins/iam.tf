data "aws_iam_policy_document" "multi_account_read_access" {
  statement {
    principals {
      type = "AWS"

      identifiers = local.all_account_roots
    }

    actions = local.ecr_read_actions
  }
}

data "aws_iam_policy_document" "multi_account_readwrite_access" {
  statement {
    principals {
      type = "AWS"

      identifiers = local.all_account_roots
    }

    actions = local.ecr_readwrite_actions
  }
}
