data "template_file" "manifest" {
  template = <<EOF
${data.template_file.cluster_spec.rendered}
${join("\n", [for ig in values(data.template_file.master_instance_group) : ig.rendered])}
${join("\n", [for ig in values(data.template_file.node_instance_group)   : ig.rendered])}
EOF
}

resource "local_file" "manifest" {
  content  = data.template_file.manifest.rendered
  filename = local.manifest
}
