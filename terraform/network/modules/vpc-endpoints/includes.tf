data "aws_vpc_endpoint_service" "ecr" {
  service = "ecr.api"
}

data "aws_route53_zone" "ecr" {
  name         = "${data.aws_vpc_endpoint_service.ecr.private_dns_name}."
  private_zone = true
}
