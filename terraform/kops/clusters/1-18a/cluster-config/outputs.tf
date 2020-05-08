output "cluster_short_name" {
  value = local.cluster_short_name
}

output "cluster_name" {
  value = module.kops_driver.cluster_name
}

output "image_id" {
    value = module.kops_driver.ami
}

output "kops_export_kubecfg_command" {
  value = module.kops_driver.export_kubecfg_command
}

output "kops_update_command" {
  value = module.kops_driver.update_command
}

output "kops_rolling_update_command" {
  value = module.kops_driver.rolling_update_command
}

output "kops_replace_command" {
  value = module.kops_driver.replace_command
}

output "kops_validate_command" {
  value = module.kops_driver.validate_command
}

output "kops_delete_command" {
  value = module.kops_driver.delete_command
}
