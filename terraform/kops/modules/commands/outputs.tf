output "create_cluster" {
  value = data.template_file.create_command.rendered
}

output "create_ca" {
  value = data.template_file.create_ca_command.rendered
}

output "edit_cluster" {
  value = data.template_file.edit_command.rendered
}

output "sshkey_secret" {
  value = data.template_file.sshkey_command.rendered
}

output "export_kubecfg" {
  value = data.template_file.export_kubecfg_command.rendered
}

output "update_cluster" {
  value = data.template_file.update_command.rendered
}

output "rolling_update_cluster" {
  value = data.template_file.rolling_update_command.rendered
}

output "replace_cluster" {
  value = data.template_file.replace_command.rendered
}

output "validate_cluster" {
  value = data.template_file.validate_command.rendered
}

output "delete_cluster" {
  value = data.template_file.delete_command.rendered
}
