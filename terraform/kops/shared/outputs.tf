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

output "iam" {
  value = {
    master = {
      role = {
        name = aws_iam_role.kops_master.name
        arn  = aws_iam_role.kops_master.arn
      }
      instance_profile = {
        arn = aws_iam_instance_profile.kops_master.arn
      }
    }
    node = {
      role = {
        name = aws_iam_role.kops_node.name
        arn  = aws_iam_role.kops_node.arn
      }
      instance_profile = {
        arn = aws_iam_instance_profile.kops_node.arn
      }
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
