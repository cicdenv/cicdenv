resource "aws_route53_zone" "private" {
  name = var.domain

  vpc {
    vpc_id = module.test_vpc.vpc.id
  }

  tags = {
    Name = "test-${var.domain}"
  }

  force_destroy = true # Removes records dynamically added by kops/protokube for etcd that prevent zone destruction
}
