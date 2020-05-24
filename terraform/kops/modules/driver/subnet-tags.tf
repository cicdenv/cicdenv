resource "null_resource" "subnet_tags" {
  triggers = {
    region          = data.aws_region.current.name
    cluster_name    = local.cluster_name
    workspace       = terraform.workspace
    public_subnets  = join(" ", values(local.public_subnets).*.id)
    private_subnets = join(" ", values(local.private_subnets).*.id)
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

  # Remove kubernetes.io/cluster/ tag needed by external/internal ELBs
  provisioner "local-exec" {
    command = <<EOF
aws --region=${self.triggers.region}    \
    ec2 delete-tags                     \
    --resources                         \
      ${self.triggers.public_subnets}   \
      ${self.triggers.private_subnets}  \
    --tags 'Key=kubernetes.io/cluster/${self.triggers.cluster_name},Value=shared'
EOF
    when = destroy
  }
}
