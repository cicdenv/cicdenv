resource "tls_cert_request" "mysql_group" {
  for_each = toset(["server", "client"])

  key_algorithm   = "RSA"
  private_key_pem = file("${path.module}/../../../groups/tls/keys/${var.name}/${terraform.workspace}/${each.key}-key.pem")
  
  dns_names = [
    "*.${local.account_hosted_zone.domain}",
    "${each.key}.${var.name}.${local.account_hosted_zone.domain}",
  ]

  subject {
    common_name = local.account_hosted_zone.domain
  }
}

resource "acme_certificate" "mysql_group" {
  for_each = toset(["server", "client"])

  account_key_pem         = file(local.account_key_file)
  certificate_request_pem = tls_cert_request.mysql_group[each.key].cert_request_pem

  dns_challenge {
    provider = "route53"

    config = {
      AWS_HOSTED_ZONE_ID = local.account_hosted_zone.zone_id
    }
  }
}
