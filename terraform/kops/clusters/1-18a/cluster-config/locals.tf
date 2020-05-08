locals {
  cluster_short_name = "1-18a-${terraform.workspace}"

  kubernetes_version   = "1.18.2"
  master_instance_type = "c5d.large"
  node_instance_type   = "r5dn.xlarge"
  node_count           = -1
}
