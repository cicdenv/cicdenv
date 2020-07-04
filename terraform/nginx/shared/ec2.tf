resource "aws_key_pair" "nginx_node" {
  key_name   = "nginx-cluster-node"
  public_key = file(pathexpand(local.ssh_key))
}
