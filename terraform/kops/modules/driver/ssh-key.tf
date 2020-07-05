resource "local_file" "user_kubeconfig" {
  content  = jsondecode(data.aws_secretsmanager_secret_version.shared_ssh_key.secret_string)["public-key"]
  filename = pathexpand(local.ssh_key)
}
