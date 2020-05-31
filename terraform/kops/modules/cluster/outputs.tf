output "export_kubecfg_command" {
  value = module.kops_commands.export_kubecfg
}

output "update_command" {
  value = module.kops_commands.update_cluster
}

output "rolling_update_command" {
  value = module.kops_commands.rolling_update_cluster
}

output "replace_command" {
  value = module.kops_commands.replace_cluster
}

output "validate_command" {
  value = module.kops_commands.validate_cluster
}

output "delete_command" {
  value = module.kops_commands.delete_cluster
}

output "ca_cert" {
  value = local.fetched.ca_cert
}
