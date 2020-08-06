output "vpc" {
  value = module.shared_vpc.vpc
}

output "subnets" {
  value = module.shared_vpc.subnets
}

output "route_tables" {
  value = module.shared_vpc.route_tables
}

output "subnet_tags" {
  value = {
    public  = merge(local.cluster_tags, local.public_subnet_tags)
    private = merge(local.cluster_tags, local.private_subnet_tags)
  }
}

output "iam" {
  value = {
    ssh_keys = {
      role = {
        name = aws_iam_role.ssh_keys.name
        arn  = aws_iam_role.ssh_keys.arn
      }
      policy = {
        name = aws_iam_policy.ssh_keys.name
        path = aws_iam_policy.ssh_keys.path
        arn  = aws_iam_policy.ssh_keys.arn
      }
    }
  }
}

output "cloudwatch_log_groups" {
  value = {
    ssh_keys = {
      name = aws_cloudwatch_log_group.ssh_keys.name
      arn  = aws_cloudwatch_log_group.ssh_keys.arn
    }
  }
}

output "secrets" {
  value = {
    shared_ec2_keypair = {
      name = aws_secretsmanager_secret.ssh_keys.name
      arn  = aws_secretsmanager_secret.ssh_keys.arn
    }
  }
}

output "lambdas" {
  value = {
    ssh_keys = {
      function_name = aws_lambda_function.ssh_keys.function_name
      handler       = aws_lambda_function.ssh_keys.handler
      runtime       = aws_lambda_function.ssh_keys.runtime
    }
  }
}

output "private_dns_zone" {
  value = local.private_hosted_zone
}
