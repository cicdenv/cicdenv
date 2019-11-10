output "security_group" {
  value = aws_security_group.bastion.id
}

output "role_arn" {
  value = aws_iam_role.bastion.arn
}

output "role_name" {
  value = aws_iam_role.bastion.name
}
