output "acme" {
  value = {
    registration = {
      id = acme_registration.nginx.id
      
      registration_url = acme_registration.nginx.registration_url
    }
  }
}

output "secrets" {
  value = {
    nginx = {
      name = aws_secretsmanager_secret.nginx.name
      arn  = aws_secretsmanager_secret.nginx.arn
    }
    key = {
      key_id = aws_kms_key.nginx_secrets.key_id
      alias  = aws_kms_alias.nginx_secrets.name
      arn    = aws_kms_key.nginx_secrets.arn
    }
  }
}
