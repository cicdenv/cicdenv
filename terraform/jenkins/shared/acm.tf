#
# For now avoid having more than one SAN (Subject Alternative Name).
#
# https://github.com/terraform-providers/terraform-provider-aws/issues/8531
#

resource "aws_acm_certificate" "jenkins_cert" {
  domain_name = local.account_hosted_zone.domain
  
  subject_alternative_names = [
    "*.${local.account_hosted_zone.domain}",
  ]
  
  validation_method = "DNS"
}

resource "aws_route53_record" "cert_validations" {
  for_each = {
    for dvo in aws_acm_certificate.jenkins_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  zone_id         = local.account_hosted_zone.zone_id
  allow_overwrite = true
  ttl             = 60
}

resource "aws_acm_certificate_validation" "jenkins_cert" {
  certificate_arn = aws_acm_certificate.jenkins_cert.arn

  validation_record_fqdns = [for record in aws_route53_record.cert_validations : record.fqdn]
}
