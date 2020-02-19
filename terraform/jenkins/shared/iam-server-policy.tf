resource "aws_iam_policy" "jenkins_server" {
  name   = "JenkinsServer"
  policy = data.aws_iam_policy_document.jenkins_server.json
}

data "aws_iam_policy_document" "jenkins_server" {
  # ecr - jenkins server image
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability"
    ]

    resources = [
      local.ecr_jenkins_server_arn,
    ]
  }

  # secrets manager
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      local.jenkins_server_secrets.arn,
      local.jenkins_github_secrets.arn,
      local.jenkins_github_localhost_secrets.arn,
    ]
  }

  # s3 build records bucket
  statement {
    effect = "Allow"
    
    actions = [
      "s3:Head*",
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      aws_s3_bucket.jenkins_build_records.arn,
    ]
  }

  # s3 build records objects
  statement {
    effect = "Allow"
    
    actions = [
      "s3:*"
    ]

    resources = [
      "${aws_s3_bucket.jenkins_build_records.arn}/*",
    ]
  }
}
