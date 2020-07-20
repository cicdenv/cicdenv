output "acme" {
  value = {
    certificates = {for key, cert in acme_certificate.mysql_group : key => {
      id              = cert.id
      certificate_pem = cert.certificate_pem
      issuer_pem      = cert.issuer_pem

      bundle = <<EOF
${cert.certificate_pem}
${cert.issuer_pem}
EOF
    }}
  }
}
