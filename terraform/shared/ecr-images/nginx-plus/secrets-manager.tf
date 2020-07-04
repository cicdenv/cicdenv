resource "aws_secretsmanager_secret" "nginx_plus" {
  name = "nginx-plus"

  description = "NGINX Plus repo access"
}
