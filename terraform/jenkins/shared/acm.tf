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
  type    = "CNAME"
  name    =  aws_acm_certificate.jenkins_cert.domain_validation_options.0.resource_record_name
  records = [aws_acm_certificate.jenkins_cert.domain_validation_options.0.resource_record_value]
  zone_id = local.account_hosted_zone.zone_id
  ttl     = 60
}

resource "aws_acm_certificate_validation" "jenkins_cert" {
  certificate_arn = aws_acm_certificate.jenkins_cert.arn

  validation_record_fqdns = [
    aws_route53_record.cert_validations.fqdn,
  ]
}
