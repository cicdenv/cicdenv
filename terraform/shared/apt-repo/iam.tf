data "aws_iam_policy_document" "lambda_trust" {
  statement {
    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
      ]
    }
    
    principals {
      type = "AWS"

      identifiers = [
        local.main_account.root,
      ]
    }
    
    actions = [
      "sts:AssumeRole",
    ]
  }
}
