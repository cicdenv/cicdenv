data "template_file" "kops_manifest" {
  template = <<EOF
${data.template_file.kops_cluster_spec.rendered}
${join("\n", data.template_file.kops_master_instance_group.*.rendered)}
${join("\n", data.template_file.kops_node_instance_group.*.rendered)}
EOF
}

resource "local_file" "kops_manifest" {
  content  = data.template_file.kops_manifest.rendered
  filename = var.kops_manifest
}
