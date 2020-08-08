resource "aws_route53_record" "ecr" {
  count = var.private_dns_enabled ? 0 : 1 # For cross account access only

  zone_id = data.aws_route53_zone.ecr.zone_id
  name    = ""
  type    = "A"

  alias {
    name                   = aws_vpc_endpoint.ecr.dns_entry[0]["dns_name"]
    zone_id                = aws_vpc_endpoint.ecr.dns_entry[0]["hosted_zone_id"]
    evaluate_target_health = true
  }
}
