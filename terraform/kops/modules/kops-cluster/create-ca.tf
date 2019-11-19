resource "null_resource" "kops_ca" {
  provisioner "local-exec" {
    command = module.kops_commands.create_ca
  }

  depends_on = [null_resource.kops_create]
}
