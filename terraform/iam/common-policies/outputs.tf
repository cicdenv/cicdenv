output "iam" {
  value = {
    apt_repo = {
      role = {
        name = aws_iam_role.apt_repo.name
        arn  = aws_iam_role.apt_repo.arn
      }
      policy = {
        name = aws_iam_policy.apt_repo.name
        path = aws_iam_policy.apt_repo.path
        arn  = aws_iam_policy.apt_repo.arn
      }
    }
  }
}
