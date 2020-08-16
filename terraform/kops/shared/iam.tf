data "aws_iam_policy_document" "lambda_trust" {
  statement {
    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}
