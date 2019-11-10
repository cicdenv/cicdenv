locals {
  default_cloud_labels = {
    # "project" = "kops"
    # "role"    = "kubernetes"
  }

  node_cloud_labels = merge(local.default_cloud_labels, var.cloud_labels)
}

data "template_file" "kops_cloud_labels" {
  count = length(keys(local.node_cloud_labels))

  template = file("${path.module}/templates/cloud-label.tpl")

  vars = {
    key   = element(keys(local.node_cloud_labels), count.index)
    value = element(values(local.node_cloud_labels), count.index)
  }
}
