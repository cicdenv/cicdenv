output "iam" {
  value = {
    server = {
      instance_profile = {
        name = aws_iam_instance_profile.mysql_group.name
        arn  = aws_iam_instance_profile.mysql_group.arn
        role = aws_iam_instance_profile.mysql_group.role
        path = aws_iam_instance_profile.mysql_group.path
      }
    }
  }
}

output "security_groups" {
  value = {
    server = {
      id = aws_security_group.mysql_group.id
    }
  }
}

output "secrets" {
  value = {
    mysql_group_tls   = module.tls_keys.secret
    mysql_group_creds = module.credentials.secret
  }
}
