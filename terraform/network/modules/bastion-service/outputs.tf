output "iam" {
  value = {
    role = {
      name = aws_iam_role.bastion.name
      arn  = aws_iam_role.bastion.arn
    }
    policy = {
      name = aws_iam_policy.bastion.name
      path = aws_iam_policy.bastion.path
      arn  = aws_iam_policy.bastion.arn
    }
    instance_profile = {
      arn = aws_iam_instance_profile.bastion.arn
    }
  }
}

output "autoscaling_group" {
  value = {
    id   = aws_autoscaling_group.bastion.id
    name = aws_autoscaling_group.bastion.name
    arn  = aws_autoscaling_group.bastion.arn
  }
}

output "dns" {
  value = "${aws_route53_record.bastion.name}.${local.account_hosted_zone.domain}"
}

output "nlb" {
  value = {
    arn      = aws_lb.bastion.arn
    dns_name = aws_lb.bastion.dns_name
    zone_id  = aws_lb.bastion.zone_id
  }
}
