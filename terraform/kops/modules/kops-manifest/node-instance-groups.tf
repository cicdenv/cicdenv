data "template_file" "kops_node_subnet_names" {
  count = length(var.availability_zones)

  template = file("${path.module}/templates/subnet-name.tpl")

  vars = {
    subnet_name = var.availability_zones[count.index]
  }
}

data "template_file" "kops_node_instance_group" {
  count = length(var.availability_zones)

  template = file("${path.module}/templates/instance-group.tpl")

  vars = {
    name             = "nodes-${var.availability_zones[count.index]}"
    role             = "Node"
    cluster_name     = var.cluster_name
    ami_id           = var.ami_id
    instance_type    = var.node_instance_type
    max_size         = ceil(var.node_count / length(var.availability_zones))
    min_size         = ceil(var.node_count / length(var.availability_zones))
    root_volume_size = var.node_volume_size

    iam_profile_arn = var.node_iam_profile.arn

    security_groups = length(var.node_security_groups) == 0 ? "[]": "[${join(",", var.node_security_groups)}]"

    subnet_names = data.template_file.kops_node_subnet_names[count.index].rendered

    cloud_labels = join("\n", data.template_file.kops_cloud_labels.*.rendered)
  }
}
