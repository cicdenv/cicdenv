output "kops_manifest" {
  value = local_file.kops_manifest.filename
}

output "master_instance_group_specs" {
  value = data.template_file.kops_master_instance_group.*.rendered
}

output "node_instance_group_specs" {
  value = data.template_file.kops_node_instance_group.*.rendered
}
