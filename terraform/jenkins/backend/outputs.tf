output "jenkins_key_arn" {
  value = aws_kms_key.jenkins.arn
}

output "jenkins_s3_bucket" {
  value = aws_s3_bucket.jenkins.bucket
}
