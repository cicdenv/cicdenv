resource "null_resource" "kops_sshkey" {
  provisioner "local-exec" {
    command = module.kops_commands.sshkey_secret
  }

  depends_on = [null_resource.kops_create]
}
