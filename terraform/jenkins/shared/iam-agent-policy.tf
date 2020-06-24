resource "aws_iam_policy" "jenkins_agent" {
  name   = "JenkinsAgent"
  policy = data.aws_iam_policy_document.jenkins_agent.json
}

data "aws_iam_policy_document" "jenkins_agent" {
  # ecr - jenkins agent image
  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
    ]

    resources = [
      local.ecr_jenkins_agent.arn,
    ]
  }
  
  # ecr - ci builds image
  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
    ]

    resources = [
      local.ecr_ci_builds.arn,
    ]
  }
  
  # ecr - pull/push
  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
    ]

    resources = [
      "arn:aws:ecr:${var.target_region}:${local.main_account.id}:repository/*",
      "arn:aws:ecr:${var.target_region}:${local.this_account.id}:repository/*",
    ]
  }

  # secrets manager
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      local.jenkins_agent_secrets.arn,
    ]
  }

  # s3 cache bucket
  statement {
    actions = [
      "s3:Head*",
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      "${aws_s3_bucket.jenkins_builds.arn}/instances/*",
      "${aws_s3_bucket.jenkins_builds.arn}/shared/*",
    ]
  }

  # s3 cache objects
  statement {
    actions = [
      "s3:*"
    ]

    resources = [
      "${aws_s3_bucket.jenkins_builds.arn}/*",
    ]
  }
}
