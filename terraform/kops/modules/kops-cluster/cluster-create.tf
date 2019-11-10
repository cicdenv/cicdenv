resource "null_resource" "kops_create" {
  provisioner "local-exec" {
    command = module.kops_commands.create_cluster
  }

  provisioner "local-exec" {
    command = <<EOF
aws --region ${data.aws_region.current.name} s3 rm "s3://${var.state_store}/${var.cluster_name}" --recursive
EOF
    when = "destroy"
  }
}
