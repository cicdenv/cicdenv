output "iam_user_updates_sns_topic" {
  value = {
    arn = aws_sns_topic.iam_user_updates.arn
    name = aws_sns_topic.iam_user_updates.name
  }
}
