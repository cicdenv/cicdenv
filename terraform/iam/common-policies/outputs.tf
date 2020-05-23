output "apt_repo_policy" {
  value = {
    name = aws_iam_policy.apt_repo.name
    path = aws_iam_policy.apt_repo.path
    arn  = aws_iam_policy.apt_repo.arn
  }
}
