output "identity_resolver_role" {
  value = {
    name = aws_iam_role.identity_resolver.name
    path = aws_iam_role.identity_resolver.path
    arn  = aws_iam_role.identity_resolver.arn
  }
}

output "ses_sender_role" {
  value = {
    name = aws_iam_role.ses_sender.name
    path = aws_iam_role.ses_sender.path
    arn  = aws_iam_role.ses_sender.arn
  }
}
