resource "aws_route53_zone" "private" {
  name = local.domain

  vpc {
    vpc_id = module.vpc.vpc_id
  }

  tags = {
    Name = "test-${local.domain}"
  }

  force_destroy = true # Removes dynamically added etcd records that prevent zone destruction
}
