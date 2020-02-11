resource "null_resource" "kops_update" {
  triggers = {
    working_dir = var.working_dir
  }

  provisioner "local-exec" {
    command     = module.kops_commands.update_cluster
    working_dir = var.working_dir
  }

  depends_on = [null_resource.kops_sshkey, null_resource.kops_ca]

  provisioner "local-exec" {
    command = <<EOF
rm -rf "data/" "kubernetes.tf"
EOF
    working_dir = self.triggers.working_dir
    when = destroy
  }
}
