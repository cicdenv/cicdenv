output "cluster_name" {
  value = local.cluster_name
}

output "cluster_instance" {
  value = local.cluster_instance
}

output "cluster_fqdn" {
  value = local.cluster_fqdn
}

output "ami" {
  value = {
    id = local.ami_id
  }
}

output "export_kubecfg_command" {
  value = module.cluster.export_kubecfg_command
}

output "update_command" {
  value = module.cluster.update_command
}

output "rolling_update_command" {
  value = module.cluster.rolling_update_command
}

output "replace_command" {
  value = module.cluster.replace_command
}

output "validate_command" {
  value = module.cluster.validate_command
}

output "delete_command" {
  value = module.cluster.delete_command
}
