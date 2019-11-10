output "kops_public_zone_name" {
  value = aws_route53_zone.kops_dns_zone.name
}

output "kops_public_zone_id" {
  value = aws_route53_zone.kops_dns_zone.zone_id
}
