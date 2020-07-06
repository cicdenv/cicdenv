resource "local_file" "ssh_key" {
  content  = local.shared_ssh_key
  filename = pathexpand(local.ssh_key)
}
