output "role_arn" {
  value = aws_iam_role.bastion.arn
}

output "role_name" {
  value = aws_iam_role.bastion.name
}
