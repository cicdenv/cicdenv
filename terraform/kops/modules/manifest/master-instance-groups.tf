data "template_file" "master_instance_group" {
  for_each = toset(local.etcd_zones)

  template = file("${path.module}/templates/instance-group.tpl")

  vars = {
    name             = "master-${each.key}"
    role             = "Master"
    cluster_name     = local.cluster_name
    ami_id           = local.ami_id
    instance_type    = local.master_instance_type
    max_size         = "1"
    min_size         = "1"
    root_volume_size = local.master_volume_size

    iam_profile_arn = local.iam.master.instance_profile.arn

    security_groups = "[${join(",", local.master_security_groups)}]"

    subnet_name = each.key
  }
}
