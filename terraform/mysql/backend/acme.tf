resource "acme_registration" "mysql" {
  account_key_pem = file("${path.module}/acme/mysql-key")
  email_address   = var.email_address
}
