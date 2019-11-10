output "lb_dns_name" {
  value = aws_elb.api_public_clb.dns_name
}

output "lb_zone_id" {
  value = aws_elb.api_public_clb.zone_id
}
