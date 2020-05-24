output "kops_public_zone" {
  value = {
    name    = aws_route53_zone.kops_dns_zone.name
    zone_id = aws_route53_zone.kops_dns_zone.zone_id
    
    # .name with trailing dot stripped
    domain = replace(data.aws_route53_zone.public_main.name, "/\\.$/", "")
  }
}
