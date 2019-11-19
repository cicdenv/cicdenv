resource "aws_route53_record" "dns" {
  name    = "api.${var.cluster_short_name}-${terraform.workspace}"
  zone_id = var.zone_id
  type    = "A"

  alias {
    name                   = aws_elb.api_public_clb.dns_name
    zone_id                = aws_elb.api_public_clb.zone_id
    evaluate_target_health = false
  }

  provider = aws.main
}