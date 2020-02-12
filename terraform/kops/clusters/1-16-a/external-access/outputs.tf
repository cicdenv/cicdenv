output "lb_dns_name" {
  value = module.kops_external_access.lb_dns_name
}

output "lb_zone_id" {
  value = module.kops_external_access.lb_zone_id
}
