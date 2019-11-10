data "template_file" "kops_master_subnet_names" {
  count = length(var.availability_zones)

  template = file("${path.module}/templates/subnet-name.tpl")

  vars = {
    subnet_name = var.availability_zones[count.index]
  }
}

data "template_file" "kops_master_instance_group" {
  count = length(var.availability_zones) % 2 == 0 ? length(var.availability_zones) - 1 : length(var.availability_zones)

  template = file("${path.module}/templates/instance-group.tpl")

  vars = {
    name             = "master-${var.availability_zones[count.index]}"
    role             = "Master"
    cluster_name     = var.cluster_name
    ami              = var.ami
    instance_type    = var.master_instance_type
    max_size         = "1"
    min_size         = "1"
    root_volume_size = var.master_volume_size

    iam_profile_arn = var.master_iam_profile

    security_groups = length(var.master_security_groups) == 0 ? "[]": "[${join(",", var.master_security_groups)}]"

    subnet_names = data.template_file.kops_master_subnet_names.*.rendered[count.index]

    cloud_labels = join("\n", data.template_file.kops_cloud_labels.*.rendered)

    addition_user_data = <<EOF
  - name: a-instance-stores
    type: text/x-shellscript
    content: |
      ${indent(6, file("${path.module}/files/mount-instance-stores.sh"))}
  - name: a-setup-dns
    type: text/x-shellscript
    content: |
      ${indent(6, file("${path.module}/files/setup-dns.sh"))}
EOF
  }
}
