output "iam" {
  value = {
    identity_resolver = {
      role = {
        name = aws_iam_role.identity_resolver.name
        path = aws_iam_role.identity_resolver.path
        arn  = aws_iam_role.identity_resolver.arn
      }
      policy = {
        name = aws_iam_policy.iam_ssh_authorized_keys.name
        path = aws_iam_policy.iam_ssh_authorized_keys.path
        arn  = aws_iam_policy.iam_ssh_authorized_keys.arn
      }
    }
    ses_sender = {
      role = {
        name = aws_iam_role.ses_sender.name
        path = aws_iam_role.ses_sender.path
        arn  = aws_iam_role.ses_sender.arn
      }
      policy = {
        name = aws_iam_policy.send_email.name
        path = aws_iam_policy.send_email.path
        arn  = aws_iam_policy.send_email.arn
      }
    }
  }
}
