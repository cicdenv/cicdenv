
resource "aws_iam_policy" "jenkins_agent" {
  name   = "JenkinsAgent"
  policy = data.aws_iam_policy_document.jenkins_agent.json
}

data "aws_iam_policy_document" "jenkins_agent" {
  # ecr - jenkins agent image
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability"
    ]

    resources = [
      local.ecr_jenkins_agent_arn,
    ]
  }

  # s3 cache bucket
  statement {
    effect = "Allow"
    
    actions = [
      "s3:Head*",
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      aws_s3_bucket.jenkins_cache.arn,
    ]
  }

  # s3 cache objects
  statement {
    effect = "Allow"
    
    actions = [
      "s3:*"
    ]

    resources = [
      "${aws_s3_bucket.jenkins_cache.arn}/*",
    ]
  }
}
