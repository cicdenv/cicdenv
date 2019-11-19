resource "null_resource" "subnet_tags" {
  # Add kubernetes.io/cluster/ tag needed by external/internal ELBs
  provisioner "local-exec" {
    command = <<EOF
aws --region=${data.aws_region.current.name}                              \
    ec2 create-tags                                                       \
    --resources                                                           \
      ${join(" ", local.public_subnets)}                                  \
      ${join(" ", local.private_subnets)}                                 \
    --tags 'Key=kubernetes.io/cluster/${local.cluster_name},Value=shared'
EOF
  }

  # Add this cluster to the list of tags sourced by the shared state
  provisioner "local-exec" {
    command = "echo '${local.cluster_name}' >> ../../../shared/data/${terraform.workspace}/clusters.txt"
  }

  # Remove this cluster to the list of tags sourced by the shared state
  provisioner "local-exec" {
    command = "sed -i'' -e '/^${local.cluster_name}$/d' ../../../shared/data/${terraform.workspace}/clusters.txt"
    when = destroy
  }
}
