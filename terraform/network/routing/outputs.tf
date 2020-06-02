output "nat_gateways" {
  value = module.nat_gateways.topology
}

output "vpc_endpoints" {
  value = {
    s3 = module.vpc_endpoints.s3
    ecr = module.vpc_endpoints.ecr
  }
}

output "bastion" {
  value = {
    dns = "${aws_route53_record.bastion.name}.${local.account_hosted_zone.domain}"
    nlb = {
      arn      = aws_lb.bastion.arn
      dns_name = aws_lb.bastion.dns_name
      zone_id  = aws_lb.bastion.zone_id

      target_groups = [
        {
          arn = aws_lb_target_group.bastion_service.arn
        },
        {
          arn = aws_lb_target_group.bastion_host.arn
        },
      ]
    }
  }
}
