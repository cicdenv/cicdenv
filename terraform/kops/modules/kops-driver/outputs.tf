output "cluster_short_name" {
  value = local.cluster_short_name
}

output "cluster_name" {
  value = local.cluster_name
}

output "ami" {
    value = local.ami
}

output "export_kubecfg_command" {
  value = module.kops_cluster.export_kubecfg_command
}

output "update_command" {
  value = module.kops_cluster.update_command
}

output "rolling_update_command" {
  value = module.kops_cluster.rolling_update_command
}

output "replace_command" {
  value = module.kops_cluster.replace_command
}

output "validate_command" {
  value = module.kops_cluster.validate_command
}

output "delete_command" {
  value = module.kops_cluster.delete_command
}
