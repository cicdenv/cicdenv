resource "aws_iam_policy" "jenkins_server" {
  name   = "JenkinsServer"
  policy = data.aws_iam_policy_document.jenkins_server.json
}

data "aws_iam_policy_document" "jenkins_server" {
  # ecr - jenkins server image
  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability"
    ]

    resources = [
      local.ecr_jenkins_server.arn,
    ]
  }

  # secrets manager
  statement {
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
    actions = [
      "s3:Head*",
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      aws_s3_bucket.jenkins_builds.arn,
    ]
  }

  # s3 build records objects
  statement {
    actions = [
      "s3:*"
    ]

    resources = [
      "${aws_s3_bucket.jenkins_builds.arn}/instances/*",
      "${aws_s3_bucket.jenkins_builds.arn}/shared/*",
    ]
  }

  # Describe agent EC2 instances
  statement {
    actions = [
      "ec2:DescribeInstances"
    ]

    resources = [
      "*",
    ]
  }
}
