output "wireguard" {
  value = {
    security_group = {
      id = aws_security_group.wireguard.id
    }
  }
}

output "iam" {
  value = {
    wireguard = {
      role = {
        name = aws_iam_role.wireguard.name
        arn  = aws_iam_role.wireguard.arn
      }
      policy = {
        name = aws_iam_policy.wireguard.name
        path = aws_iam_policy.wireguard.path
        arn  = aws_iam_policy.wireguard.arn
      }
      instance_profile = {
        arn = aws_iam_instance_profile.wireguard.arn
      }
    }
  }
}

output "secrets" {
  value = {
    wireguard_keys = {
      name = aws_secretsmanager_secret.wireguard_keys.name
      arn  = aws_secretsmanager_secret.wireguard_keys.arn
    }
  }
}
