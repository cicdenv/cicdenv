#
# For now avoid having more than one SAN (Subject Alternative Name).
#
# https://github.com/terraform-providers/terraform-provider-aws/issues/8531
#

#
# *.cicdenv.com
#
resource "aws_acm_certificate" "wildcard_cert" {
  domain_name = var.domain
  
  subject_alternative_names = [
    "*.${var.domain}",
  ]

  validation_method = "DNS"
  
  provider = aws.special
}

resource "aws_route53_record" "wildcard_cert_validations" {
  for_each = {
    for dvo in aws_acm_certificate.wildcard_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  zone_id         = local.public_hosted_zone.id
  allow_overwrite = true
  ttl             = 60
}

resource "aws_acm_certificate_validation" "wildcard_cert" {
  certificate_arn = aws_acm_certificate.wildcard_cert.arn

  validation_record_fqdns = [for record in aws_route53_record.wildcard_cert_validations : record.fqdn]
  
  provider = aws.special
}
