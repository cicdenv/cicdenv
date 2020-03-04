resource "null_resource" "subnet_tags" {
  triggers = {
    region          = data.aws_region.current.name
    cluster_name    = local.cluster_name
    workspace       = terraform.workspace
    public_subnets  = join(" ", local.public_subnets)
    private_subnets = join(" ", local.private_subnets)
  }

  # Add kubernetes.io/cluster/ tag needed by external/internal ELBs
  provisioner "local-exec" {
    command = <<EOF
aws --region=${self.triggers.region}    \
    ec2 create-tags                     \
    --resources                         \
      ${self.triggers.public_subnets}   \
      ${self.triggers.private_subnets}  \
    --tags 'Key=kubernetes.io/cluster/${self.triggers.cluster_name},Value=shared'
EOF
  }
}
