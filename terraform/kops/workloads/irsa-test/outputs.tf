output "iam" {
  value = {
    irsa_test = {
      role = {
        name = aws_iam_role.irsa_test.name
        arn  = aws_iam_role.irsa_test.arn
      }
    }
  }
}
