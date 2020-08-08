resource "aws_route53_zone" "ecr" {
  name    = data.aws_vpc_endpoint_service.ecr.private_dns_name
  comment = "${data.aws_vpc_endpoint_service.ecr.service_name} vpce"

  vpc {
    vpc_id = module.vpc.vpc.id
  }

  tags = {
    Name = data.aws_vpc_endpoint_service.ecr.private_dns_name
  }
  
  lifecycle {
    ignore_changes = [vpc]
  }

  force_destroy = true # Removes records dynamically added by kops/protokube for etcd that prevent zone destruction
}
