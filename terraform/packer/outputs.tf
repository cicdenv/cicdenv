output "key" {
  value = {
    key_id = aws_kms_key.ebs.key_id
    arn    = aws_kms_key.ebs.arn
    alias  = aws_kms_alias.ebs.name
  }
}

output "allowed_account_ids" {
  value = local.allowed_account_ids
}

output "iam" {
  value = {
    role = {
      name = aws_iam_role.packer_build.name
      arn  = aws_iam_role.packer_build.arn
    }
    policy = {
      name = aws_iam_policy.packer_build.name
      path = aws_iam_policy.packer_build.path
      arn  = aws_iam_policy.packer_build.arn
    }
    instance_profile = {
      arn = aws_iam_instance_profile.packer_build.arn
    }
  }
}
