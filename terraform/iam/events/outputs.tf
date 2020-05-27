output "sns" {
  value = {
    topics = {
      iam_user_updates = {
        arn = aws_sns_topic.iam_user_updates.arn
        name = aws_sns_topic.iam_user_updates.name
      }
    }
  }
}
