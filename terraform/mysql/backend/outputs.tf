output "acme" {
  value = {
    registration = {
      id = acme_registration.mysql.id
      
      registration_url = acme_registration.mysql.registration_url
    }
  }
}

output "secrets" {
  value = {
    mysql = {
      name = aws_secretsmanager_secret.mysql.name
      arn  = aws_secretsmanager_secret.mysql.arn
    }
    key = {
      key_id = aws_kms_key.mysql_secrets.key_id
      alias  = aws_kms_alias.mysql_secrets.name
      arn    = aws_kms_key.mysql_secrets.arn
    }
  }
}
