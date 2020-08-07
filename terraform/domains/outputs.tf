output "main_public_zone" {
  value = {
    name    = data.aws_route53_zone.public_main.name
    zone_id = data.aws_route53_zone.public_main.zone_id

    # .name with trailing dot stripped
    domain = replace(data.aws_route53_zone.public_main.name, "/\\.$/", "")
  }
}

output "account_public_zone" {
  value = {
    name    = aws_route53_zone.account.name
    zone_id = aws_route53_zone.account.zone_id

    # .name with trailing dot stripped
    domain = replace(aws_route53_zone.account.name, "/\\.$/", "")
  }
}

output "private_dns_zone" {
  value = {
    name         = aws_route53_zone.private.name
    zone_id      = aws_route53_zone.private.zone_id
    name_servers = aws_route53_zone.private.name_servers

    # .name with trailing dot stripped
    domain       = replace(aws_route53_zone.private.name, "/\\.$/", "")
  }
}
