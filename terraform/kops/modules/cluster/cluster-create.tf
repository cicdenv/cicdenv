resource "null_resource" "kops_create" {
  triggers = {
    region       = local.region
    state_store  = local.state_store.bucket.name
    cluster_fqdn = local.cluster_fqdn
  }

  provisioner "local-exec" {
    command = module.kops_commands.create_cluster
  }

  provisioner "local-exec" {
    command = <<EOF
aws --region ${self.triggers.region} s3 rm "s3://${self.triggers.state_store}/${self.triggers.cluster_fqdn}" --recursive
EOF
    when = destroy
  }
}
