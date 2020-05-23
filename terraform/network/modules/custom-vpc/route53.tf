resource "aws_route53_zone" "private" {
  name = var.domain

  vpc {
    vpc_id = aws_vpc.me.id
  }

  tags = {
    Name = "${var.name}-${var.domain}"
  }

  force_destroy = true # Removes records dynamically added by kops/protokube for etcd that prevent zone destruction
}
