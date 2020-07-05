output "iam" {
  value = {
    server = {
      instance_profile = {
        name = aws_iam_instance_profile.nginx_node.name
        arn  = aws_iam_instance_profile.nginx_node.arn
        role = aws_iam_instance_profile.nginx_node.role
        path = aws_iam_instance_profile.nginx_node.path
      }
    }
  }
}

output "security_groups" {
  value = {
    server = {
      id = aws_security_group.nginx_node.id
    }
  }
}

output "secrets" {
  value = {
    nginx_tls = {
      name = aws_secretsmanager_secret.nginx_tls.name
      arn  = aws_secretsmanager_secret.nginx_tls.arn
    }
  }
}
