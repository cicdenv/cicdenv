resource "aws_iam_role" "jenkins_colo" {
  name = "jenkins-colo"
  
  assume_role_policy = data.aws_iam_policy_document.jenkins_trust.json

  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "jenkins_colo_common" {
  role       = aws_iam_role.jenkins_colo.name
  policy_arn = aws_iam_policy.jenkins_common.arn
}

resource "aws_iam_role_policy_attachment" "jenkins_colo_server" {
  role       = aws_iam_role.jenkins_colo.name
  policy_arn = aws_iam_policy.jenkins_server.arn
}

resource "aws_iam_role_policy_attachment" "jenkins_colo_agent" {
  role       = aws_iam_role.jenkins_colo.name
  policy_arn = aws_iam_policy.jenkins_agent.arn
}

resource "aws_iam_role_policy_attachment" "jenkins_colo_apt_repo" {
  role       = aws_iam_role.jenkins_colo.name
  policy_arn = local.apt_repo_policy_arn
}

resource "aws_iam_instance_profile" "jenkins_colo" {
  name = "jenkins-colo"
  role = aws_iam_role.jenkins_colo.name
}
