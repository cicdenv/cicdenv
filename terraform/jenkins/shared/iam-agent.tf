resource "aws_iam_role" "jenkins_agent" {
  name = "jenkins-agent"
  
  assume_role_policy = data.aws_iam_policy_document.jenkins_trust.json

  force_detach_policies = true
  
  max_session_duration = 60 * 60 * 12 # 12 hours in seconds
}

resource "aws_iam_role_policy_attachment" "jenkins_agent_common" {
  role       = aws_iam_role.jenkins_agent.name
  policy_arn = aws_iam_policy.jenkins_common.arn
}

resource "aws_iam_role_policy_attachment" "jenkins_agent" {
  role       = aws_iam_role.jenkins_agent.name
  policy_arn = aws_iam_policy.jenkins_agent.arn
}

resource "aws_iam_role_policy_attachment" "jenkins_agent_apt_repo" {
  role       = aws_iam_role.jenkins_agent.name
  policy_arn = local.apt_repo_policy.arn
}

resource "aws_iam_instance_profile" "jenkins_agent" {
  name = "jenkins-agent"
  role = aws_iam_role.jenkins_agent.name
}
