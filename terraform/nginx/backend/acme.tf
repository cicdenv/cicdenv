resource "acme_registration" "nginx" {
  account_key_pem = file("${path.module}/acme/nginx-key")
  email_address   = var.email_address
}
