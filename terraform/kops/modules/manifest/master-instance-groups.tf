data "template_file" "master_instance_group" {
  for_each = toset(local.etcd_zones)

  template = file("${path.module}/templates/instance-group.tpl")

  vars = {
    name             = "master-${each.key}"
    role             = "Master"
    cluster_fqdn     = local.cluster_fqdn
    ami_id           = local.ami_id
    instance_type    = local.master_instance_type
    max_size         = "1"
    min_size         = "1"
    root_volume_size = local.master_volume_size

    iam_profile_arn = local.iam.master.instance_profile.arn

    security_groups = "[${join(",", local.master_security_groups)}]"

    subnet_name = "private-${each.key}"
    
    addition_user_data = <<EOF
  - name: configure-container-runtime.sh
    type: text/x-shellscript
    content: |
      ${indent(6, file("${path.module}/files/configure-container-runtime.sh"))}
EOF
  }
}
