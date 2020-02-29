output "wildcard_site_cert" {
  value = {
    arn = aws_acm_certificate_validation.wildcard_cert.certificate_arn
  }
}
