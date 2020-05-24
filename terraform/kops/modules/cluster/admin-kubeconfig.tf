resource "null_resource" "admin_kubeconfig" {
  triggers = {
    admin_kubeconfig = local.admin_kubeconfig
  }

  provisioner "local-exec" {
    command = module.kops_commands.export_kubecfg
  }

  depends_on = [
    null_resource.kops_update,
  ]

  provisioner "local-exec" {
    command = <<EOF
rm -f "${self.triggers.admin_kubeconfig}"
EOF
    when = destroy
  }
}
