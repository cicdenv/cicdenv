output "key_pairs" {
  value = {
    redis_node = {
      key_name    = aws_key_pair.redis_node.key_name
      key_pair_id = aws_key_pair.redis_node.key_pair_id
      fingerprint = aws_key_pair.redis_node.fingerprint
    }
  }
}

output "iam" {
  value = {
    redis_node = {
      instance_profile = {
        name = aws_iam_instance_profile.redis_node.name
        arn  = aws_iam_instance_profile.redis_node.arn
        role = aws_iam_instance_profile.redis_node.role
        path = aws_iam_instance_profile.redis_node.path
      }
    }
  }
}

output "security_groups" {
  value = {
    redis_node = {
      id = aws_security_group.redis_node.id
    }
  }
}
