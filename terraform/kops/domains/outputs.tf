output "kops_public_zone" {
  value = {
    name    = aws_route53_zone.kops_dns_zone.name
    zone_id = aws_route53_zone.kops_dns_zone.zone_id
    
    # .name with trailing dot stripped
    domain = replace(aws_route53_zone.kops_dns_zone.name, "/\\.$/", "")
  }
}
