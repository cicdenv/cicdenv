resource "aws_iam_role" "jenkins_server" {
  name = "jenkins-server"
  
  assume_role_policy = data.aws_iam_policy_document.jenkins_trust.json

  force_detach_policies = true
  
  max_session_duration = 60 * 60 * 12 # 12 hours in seconds
}

resource "aws_iam_role_policy_attachment" "jenkins_server_common" {
  role       = aws_iam_role.jenkins_server.name
  policy_arn = aws_iam_policy.jenkins_common.arn
}

resource "aws_iam_role_policy_attachment" "jenkins_server" {
  role       = aws_iam_role.jenkins_server.name
  policy_arn = aws_iam_policy.jenkins_server.arn
}

resource "aws_iam_role_policy_attachment" "jenkins_server_apt_repo" {
  role       = aws_iam_role.jenkins_server.name
  policy_arn = local.apt_repo_policy.arn
}

resource "aws_iam_role_policy_attachment" "jenkins_server_ssm_core" {
  role       = aws_iam_role.jenkins_server.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "jenkins_server" {
  name = "jenkins-server"
  role = aws_iam_role.jenkins_server.name
}
