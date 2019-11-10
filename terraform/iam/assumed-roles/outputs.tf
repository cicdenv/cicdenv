output "identity_resolver_role_arn" {
  value = aws_iam_role.identity_resolver.arn
}

output "ses_sender_role_arn" {
  value = aws_iam_role.ses_sender.arn
}
