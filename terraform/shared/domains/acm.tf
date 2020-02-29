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
  type    = "CNAME"
  name    =  aws_acm_certificate.wildcard_cert.domain_validation_options.0.resource_record_name
  records = [aws_acm_certificate.wildcard_cert.domain_validation_options.0.resource_record_value]
  zone_id = local.public_hosted_zone.id
  ttl     = 60
}

resource "aws_acm_certificate_validation" "wildcard_cert" {
  certificate_arn = aws_acm_certificate.wildcard_cert.arn

  validation_record_fqdns = [
    aws_route53_record.wildcard_cert_validations.fqdn,
  ]
  
  provider = aws.special
}
