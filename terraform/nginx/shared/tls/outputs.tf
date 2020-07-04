output "acme" {
  value = {
    certificate = {
      id              = acme_certificate.nginx.id
      certificate_pem = acme_certificate.nginx.certificate_pem
      issuer_pem      = acme_certificate.nginx.issuer_pem

      bundle = <<EOF
${acme_certificate.nginx.certificate_pem}
${acme_certificate.nginx.issuer_pem}
EOF
    }
  }
}
