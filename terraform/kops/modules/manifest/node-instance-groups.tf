data "template_file" "node_instance_group" {
  for_each = toset(local.availability_zones)

  template = file("${path.module}/templates/instance-group.tpl")

  vars = {
    name             = "nodes-${each.key}"
    role             = "Node"
    cluster_fqdn     = local.cluster_fqdn
    ami_id           = local.ami_id
    instance_type    = local.node_instance_type
    max_size         = local.nodes_per_az * 5
    min_size         = local.nodes_per_az
    root_volume_size = local.node_volume_size

    iam_profile_arn = local.iam.node.instance_profile.arn

    security_groups = "[${join(",", local.node_security_groups)}]"

    subnet_name = "private-${each.key}"
  }
}
