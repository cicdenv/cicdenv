resource "aws_route53_zone" "private" {
  name    = var.domain
  comment = "backend private services"

  vpc {
    vpc_id = module.vpc.vpc.id
  }

  tags = {
    Name = "${var.domain}"
  }
  
  lifecycle {
    ignore_changes = [vpc]
  }

  force_destroy = true # Removes records dynamically added by kops/protokube for etcd that prevent zone destruction
}
