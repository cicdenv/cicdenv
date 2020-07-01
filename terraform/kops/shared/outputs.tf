output "security_groups" {
  value = {
    master = {
      id = aws_security_group.kops_masters.id
    }
    node = {
      id = aws_security_group.kops_nodes.id
    }
    internal_apiserver = {
      id = aws_security_group.kops_internal_apiserver.id
    }
    external_apiserver = {
      id = aws_security_group.kops_external_apiserver.id
    }
  }
}

output "etcd_kms_key" {
  value = {
    name   = aws_kms_alias.kops_etcd.name
    key_id = aws_kms_key.kops_etcd.key_id
    arn    = aws_kms_key.kops_etcd.arn
  }
}

output "secrets" {
  value = {
    service_accounts = {
      name = aws_secretsmanager_secret.kops_ca.name
      arn  = aws_secretsmanager_secret.kops_ca.arn
    }
  }
}
