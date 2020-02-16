resource "aws_kms_key" "jenkins" {
  description = "Used for jenkins resources shared with sub-accounts."
  
  policy = data.aws_iam_policy_document.jenkins_key.json
}

resource "aws_kms_alias" "jenkins" {
  name          = "alias/jenkins"
  target_key_id = aws_kms_key.jenkins.key_id
}
