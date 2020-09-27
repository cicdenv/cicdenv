resource "aws_iam_role" "test" {
  name = "test"
  
  assume_role_policy = data.aws_iam_policy_document.test_trust.json
}

data "aws_iam_policy_document" "test_trust" {
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

data "aws_iam_policy_document" "test" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    resources = local.assume_role_arns
  }
}

resource "aws_iam_policy" "test" {
  name   = "ManualTesting"
  policy = data.aws_iam_policy_document.test.json
}

resource "aws_iam_role_policy_attachment" "test" {
  role       = aws_iam_role.test.name
  policy_arn = aws_iam_policy.test.arn
}

resource "aws_iam_role_policy_attachment" "apt_repo" {
  role       = aws_iam_role.test.name
  policy_arn = local.apt_repo_policy.arn
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.test.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "test" {
  name = "test"
  role = aws_iam_role.test.name
}
