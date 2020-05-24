output "manifest" {
  value = local_file.manifest.filename
}

output "master_instance_group_specs" {
  value = {for az, ig in data.template_file.master_instance_group : az => ig.rendered}
}

output "node_instance_group_specs" {
  value = {for az, ig in data.template_file.node_instance_group : az => ig.rendered}
}
