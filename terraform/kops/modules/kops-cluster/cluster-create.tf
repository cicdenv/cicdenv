resource "null_resource" "kops_create" {
  triggers = {
    region       = data.aws_region.current.name
    state_store  = var.state_store
    cluster_name = var.cluster_name
  }

  provisioner "local-exec" {
    command = module.kops_commands.create_cluster
  }

  provisioner "local-exec" {
    command = <<EOF
aws --region ${self.triggers.region} s3 rm "s3://${self.triggers.state_store}/${self.triggers.cluster_name}" --recursive
EOF
    when = destroy
  }
}
