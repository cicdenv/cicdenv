resource "aws_sns_topic" "iam_user_updates" {
  name = "iam-user-updates"
  
  provider = aws.us-east-1
}
