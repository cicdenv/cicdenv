resource "aws_key_pair" "redis_node" {
  key_name   = "redis-cluster-node"
  public_key = file(pathexpand(local.ssh_key))
}
