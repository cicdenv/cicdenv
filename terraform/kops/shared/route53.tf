resource "aws_route53_zone" "private" {
  name = local.domain

  vpc {
    vpc_id = module.vpc.vpc_id
  }

  tags = {
    Name = "kops-private-${local.domain}"
  }

  force_destroy = true # Removes etcd records dynamically added by kops/protokube that prevent zone destruction
}
