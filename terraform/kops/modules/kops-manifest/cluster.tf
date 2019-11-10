data "template_file" "kops_etcd_members" {
  count = length(var.availability_zones) % 2 == 0 ? length(var.availability_zones) - 1 : length(var.availability_zones)

  template = file("${path.module}/templates/etcd-member.tpl")

  vars = {
    availability_zone = var.availability_zones[count.index]
    region            = data.aws_region.current.name
    etcd_key_arn      = var.etcd_key_arn
  }
}

data "template_file" "kops_private_subnets" {
  count = length(var.availability_zones)

  template = file("${path.module}/templates/subnet.tpl")

  vars = {
    availability_zone = var.availability_zones[count.index]
    subnet_name       = var.availability_zones[count.index]
    subnet_id         = var.private_subnets[count.index]
    subnet_cidr       = data.aws_subnet.private_subnets.*.cidr_block[count.index]
    subnet_type       = "Private"
  }
}

data "template_file" "kops_public_subnets" {
  count = length(var.availability_zones)

  template = file("${path.module}/templates/subnet.tpl")

  vars = {
    availability_zone = var.availability_zones[count.index]
    subnet_name       = "utility-${var.availability_zones[count.index]}"
    subnet_id         = var.public_subnets[count.index]
    subnet_cidr       = data.aws_subnet.public_subnets.*.cidr_block[count.index]
    subnet_type       = "Utility"
  }
}

data "template_file" "kops_cluster_spec" {
  template = file("${path.module}/templates/cluster-spec.tpl")

  vars = {
    cluster_name = var.cluster_name
    state_store  = var.state_store
    
    kubernetes_version = var.kubernetes_version

    vpc_id           = var.vpc_id
    network_cidr     = var.network_cidr
    networking       = var.networking
    private_dns_zone = var.private_dns_zone

    etcd_members    = join("\n", data.template_file.kops_etcd_members.*.rendered)
    private_subnets = join("\n", data.template_file.kops_private_subnets.*.rendered)
    public_subnets  = join("\n", data.template_file.kops_public_subnets.*.rendered)

    lb_security_groups = length(var.internal_apiserver_security_groups) == 0 ? "[]": "[${join(",", var.internal_apiserver_security_groups)}]"

    audit_policy = indent(6, file("${path.module}/files/audit-policy.yaml"))
  }
}
