output "user_data" {
  value = data.template_cloudinit_config.config.rendered
}
